#include "picviewer.h"

struct Icon wndRes[] = {//一个图标数组
    { "close.bmp", 3, 3 }
};

Handler wndEvents[] = {
    h_closeWnd
};

PICNODE pic;
int isRun = 1;
int isZooming = 1;//0为不动，1为扩大，2为缩小，其他给跪

// 压缩图片
void compressPic(int width, int height) {
    int w0, h0, w1, h1;
    float fw, fh;
    int x0, y0, x1, x2, y1, y2;
    float fx1, fx2, fy1, fy2;
    int x, y, index;
    RGBQUAD* data;

    w0 = pic.width;//图宽
    h0 = pic.height;//图高
    w1 = width;//设定宽
    h1 = height;//设定高

    fw = w0 * 1.0 / w1;//宽缩比
    fh = h0 * 1.0 / h1;//高缩比

    index = 0;
    data = (RGBQUAD*)malloc(w1*h1*sizeof(RGBQUAD));//新图颜色表
    memset(data, 0, (uint)w1*h1*sizeof(RGBQUAD));
    
    for (y = 0; y < h1; ++y)//双线性插值法  此算法个人认为需要看一下效果，如果好就用它缩放 h1=10,h0=5,w1=9,w0=3
    {
        y0 = y*fh;//y=0,y0=0
        y1 = (int)y0;//y1=0
        y2 = (y1 == h0-1) ? y1 : y1 + 1;//y2=1

        fy1 = y1-y0;//fy1=0
        fy2 = 1.0f-fy1;//fy2=1

        for (x = 0; x < w1; ++x) {
            x0 = x*fw;//x=0,x0=0
            x1 = (int)x0;//x1=0
            x2 = (x1 == w0-1) ? x1 : x1 + 1;//x2=1

            fx1 = x1-x0;//fx1=0    //y1=y0??????
            fx2 = 1.0f-fx1;//fx2=1

            float s1 = fx1*fy1;//s1=0
            float s2 = fx2*fy1;//s2=0
            float s3 = fx2*fy2;//s3=1
            float s4 = fx1*fy2;//s4=0

            RGBQUAD p1, p2, p3, p4;
            p1 = pic.data[x1+y1*w0];//p1=pic.data[0]
            p2 = pic.data[x2+y1*w0];//p2=pic.data[1]
            p3 = pic.data[x1+y2*w0];//p3=pic.data[3]
            p4 = pic.data[x2+y2*w0];//p4=pic.data[4]

            data[index].rgbRed = (BYTE)(p1.rgbRed*s3 + p2.rgbRed*s4 + p3.rgbRed*s2 + p4.rgbRed*s1);
            data[index].rgbGreen = (BYTE)(p1.rgbGreen*s3 + p2.rgbGreen*s4 + p3.rgbGreen*s2 + p4.rgbGreen*s1);
            data[index].rgbBlue = (BYTE)(p1.rgbBlue*s3 + p2.rgbBlue*s4 + p3.rgbBlue*s2 + p4.rgbBlue*s1);

            data[index].rgbRed = p1.rgbRed;
            data[index].rgbGreen = p1.rgbGreen;
            data[index].rgbBlue = p1.rgbBlue;

            ++index;
        }
    }

    freepic(&pic);
    pic.data = data;
    pic.width = width;
    pic.height = height;
}

void modifyPic(Context context)//调整大小来适应背景
{
    int c_width, c_height;
    int pic_width, pic_height;

    c_width = context.width;
    c_height = context.height;
    pic_width = pic.width;
    pic_height = pic.height;

    if (pic_width < c_width && pic_height < c_height) {//比背景小，不动
        return;
    }

    float scale_p, scale_c;//宽高比
    scale_p = pic_width * 1.0 / pic_height;
    scale_c = c_width * 1.0 / c_height;

    if (scale_p <= scale_c) {
        pic_width = scale_p * (c_height-10);
        pic_height = c_height-10;
    } else {
        pic_height = (c_width-5) / scale_p;
        pic_width = c_width-5;
    }
    printf(0, "modifyPic: pic_width: %d, pic_height: %d\n", pic_width, pic_height);

    compressPic(pic_width, pic_height);
}

//放大图片
void enlargePic(Context context,int enlargeRate,int centerX, int centerY)
{
    int width = pic.pic_width*enlargeRate;
    int height = pic.pic_height*enlargeRate;
    compressPic(width,height);
    int centerConX = context.width/2.0;
    int centerConY = context.height/2.0;
    int moveX = centerConX - centerX;
    int moveY = centerConY - centerY;
    draw_picture(content, pic, moveX, TOPBAR_HEIGHT+moveY);
}

//缩小图片
void narrowPic(Context context,int narrowRate,int centerX, int centerY)
{
    int width = pic.pic_width/(double)enlargeRate;
    int height = pic.pic_height/(double)enlargeRate;
    compressPic(width,height);
    int centerConX = context.width/2.0;
    int centerConY = context.height/2.0;
    int moveX = centerConX - centerX;
    int moveY = centerConY - centerY;
    draw_picture(content, pic, moveX, TOPBAR_HEIGHT+moveY);
}

//图片放缩
void zoomingPic(Context context,int centerX, int centerY)
{
    if(centerX > context.width || centerY > context.height) return;
    int rate = 10;//待定等改
    switch(isZooming)
    {
        case 1:
            enlargePic(context,rate,centerX,centerY);
            iszooming = 2;
            break;
        case 2:
            narrowPic(context,rate,centerX,centerY);
            iszooming = 1;
            break;
        default:
            iszooming = 1;
            break;
    }
}


// 绘制窗口
void drawPicViewerWnd(Context context) {
    int width, height;

    width = context.width;
    height = context.height;

    fill_rect(context, 0, 0, width, height, 0xFFFF);

    draw_line(context, 0, 0, width-1, 0, BORDERLINE_COLOR);
    draw_line(context, width-1, 0, width-1, height-1, BORDERLINE_COLOR);
    draw_line(context, 0, height-1, width-1, height-1, BORDERLINE_COLOR);
    draw_line(context, 0, height-1, 0, 0, BORDERLINE_COLOR);

    fill_rect(context, 1, 1, width-2, TOPBAR_HEIGHT, TOPBAR_COLOR);
    puts_str(context, "PictureViewer", 0, WINDOW_WIDTH/2 - 53, 3);

    draw_iconlist(context, wndRes, sizeof(wndRes) / sizeof(ICON));
}

void drawPicViewerContent(Context context, char* fileName) {
    int c_width, c_height;
    int pic_width, pic_height;

    c_width = context.width;
    c_height = context.height;
    pic_width = pic.width;
    pic_height = pic.height;

    printf(0, "drawPicViewerContent: pic_width: %d, pic_height: %d\n", pic_width, pic_height);
    draw_picture(context, pic, (c_width-pic_width) >> 1, TOPBAR_HEIGHT + ((c_height-pic_height) >> 1));//这个居中写的我服！
}

void h_closeWnd(Point p) {
    isRun = 0;
}

void addWndEvent(ClickableManager *cm) {
    int i;
	int n = sizeof(wndEvents) / sizeof(Handler);

	for (i = 0; i < n; i++) {
		createClickable(cm,
				initRect(wndRes[i].position_x, wndRes[i].position_y,
						wndRes[i].pic.width, wndRes[i].pic.height), MSG_LPRESS,
				wndEvents[i]);
	}
}

int main(int argc, char *argv[]) {
    struct Context context;
    ClickableManager cm;//（这个东西是干吗用的？）
    int winid;
    struct Msg msg;
    Point p;

    winid = init_context(&context, WINDOW_WIDTH, WINDOW_HEIGHT);//根据窗口大小初始化背景
    cm = initClickManager(context);//根据背景初始化ClickableManager

    loadBitmap(&pic, argv[1]);//载入bmp
    load_iconlist(wndRes, sizeof(wndRes) / sizeof(ICON));//载入图标数组

    modifyPic(context);//按照背景修改图片
    deleteClickable(&cm.left_click, initRect(0, 0, 800, 600));
    addWndEvent(&cm);//添加cm到窗口事件

    while (isRun) {
        getMsg(&msg);//获取消息
        switch (msg.msg_type) {//判断消息类型
		case MSG_DOUBLECLICK://双击消息
			p = initPoint(msg.concrete_msg.msg_mouse.x,msg.concrete_msg.msg_mouse.y);//获取到鼠标现在的点
			if (executeHandler(cm.double_click, p))//（暂时不懂）
            {
				updateWindow(winid, context.addr, msg.msg_detail);//更新窗口
			}
            
            zoomingPic(context,p.x,p.y);
            updateWindow(winid, context.addr, msg.msg_detail);
                
			break;
		case MSG_UPDATE://更新消息（太好了貌似可以直接调重绘了）
			drawPicViewerWnd(context);//绘制窗口
			drawPicViewerContent(context, argv[1]);//背景里绘制图片
			updateWindow(winid, context.addr, msg.msg_detail);//更新窗口
			break;
		case MSG_PARTIAL_UPDATE://部分更新消息
			updatePartialWindow(winid, context.addr,
					msg.concrete_msg.msg_partial_update.x1,
					msg.concrete_msg.msg_partial_update.y1,
					msg.concrete_msg.msg_partial_update.x2,
					msg.concrete_msg.msg_partial_update.y2);//还能部分更新窗口？以一个矩形区域更新
			break;
		case MSG_LPRESS://鼠标左键按下
			p = initPoint(msg.concrete_msg.msg_mouse.x,
					msg.concrete_msg.msg_mouse.y);//获取到鼠标现在的点
			if (executeHandler(cm.left_click, p)) {//（暂时不懂）

				updateWindow(winid, context.addr, msg.msg_detail);
			}
			break;
		case MSG_RPRESS://鼠标右键按下
			p = initPoint(msg.concrete_msg.msg_mouse.x,
					msg.concrete_msg.msg_mouse.y);
			if (executeHandler(cm.right_click, p)) {
				updateWindow(winid, context.addr, msg.msg_detail);
			}
			break;
		default:
			break;
		}
    }
    free_context(&context, winid);
    exit();
}
