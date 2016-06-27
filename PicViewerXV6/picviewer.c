#include "picviewer.h"


struct Icon wndRes[] = {//一个图标数组
    { "close.bmp", 3, 3 }
};

Handler wndEvents[] = {
    h_closeWnd
};

PICNODE pic;
int len;
int pos;
char* file[100];
int isRun = 1;
int isZooming = 1;//0为不动，1为扩大，2为缩小，其他给跪
int isShowing = 0;//0 not showing 1 showing
int startXsave = 0;
int startYsave = 0;
int X_shift = 0;
int Y_shift = 0;
#define shift_at_once 5

void drawPicViewerContent(Context context, char* fileName);
void updateWindowWithoutBlank(Context context);

//Initialize
void Initialize(Context context)
{
	startXsave = (context.width-pic.width) >> 1;
	startYsave = TOPBAR_HEIGHT + ((context.height-pic.height) >> 1);
}

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

void compressAnyPic(PICNODE* anypic, int width, int height) {
    int w0, h0, w1, h1;
    float fw, fh;
    int x0, y0, x1, x2, y1, y2;
    float fx1, fx2, fy1, fy2;
    int x, y, index;
    RGBQUAD* data;

    w0 = anypic->width;//图宽
    h0 = anypic->height;//图高
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
            p1 = anypic->data[x1+y1*w0];//p1=pic.data[0]
            p2 = anypic->data[x2+y1*w0];//p2=pic.data[1]
            p3 = anypic->data[x1+y2*w0];//p3=pic.data[3]
            p4 = anypic->data[x2+y2*w0];//p4=pic.data[4]

            data[index].rgbRed = (BYTE)(p1.rgbRed*s3 + p2.rgbRed*s4 + p3.rgbRed*s2 + p4.rgbRed*s1);
            data[index].rgbGreen = (BYTE)(p1.rgbGreen*s3 + p2.rgbGreen*s4 + p3.rgbGreen*s2 + p4.rgbGreen*s1);
            data[index].rgbBlue = (BYTE)(p1.rgbBlue*s3 + p2.rgbBlue*s4 + p3.rgbBlue*s2 + p4.rgbBlue*s1);

            data[index].rgbRed = p1.rgbRed;
            data[index].rgbGreen = p1.rgbGreen;
            data[index].rgbBlue = p1.rgbBlue;

            ++index;
        }
    }

    freepic(anypic);
    anypic->data = data;
    anypic->width = width;
    anypic->height = height;
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
    if(centerX<0 || centerY<0 || centerX>context.width || centerY>context.height)return;
    int width = pic.width*enlargeRate;
    int height = pic.height*enlargeRate;
    compressPic(width,height);
    /*int centerConX = context.width/2.0;
    int centerConY = context.height/2.0;
    int moveX = centerConX - centerX;
    int moveY = centerConY - centerY;*/
    drawPicViewerWnd(context);
    draw_picture(context, pic, ((context.width >> 1) - centerX)*enlargeRate + ((context.width-width/enlargeRate) >> 1)+X_shift*enlargeRate, 
TOPBAR_HEIGHT + (((context.height-TOPBAR_HEIGHT) >> 1) - (centerY-TOPBAR_HEIGHT))*enlargeRate + ((context.height-TOPBAR_HEIGHT-height/enlargeRate) >> 1)+Y_shift*enlargeRate);
	startXsave = ((context.width >> 1) - centerX)*enlargeRate + ((context.width-width/enlargeRate) >> 1)+X_shift*enlargeRate;
	startYsave = TOPBAR_HEIGHT + (((context.height-TOPBAR_HEIGHT) >> 1) - (centerY-TOPBAR_HEIGHT))*enlargeRate + ((context.height-TOPBAR_HEIGHT-height/enlargeRate) >> 1)+Y_shift*enlargeRate;

	printf(0,"Enlarge: context_width: %d, context_height: %d\n", context.width, context.height);
	printf(0,"Enlarge: width: %d, height: %d\n", width, height);
        printf(0,"Enlarge: centerX: %d, centerY: %d\n", centerX, centerY);
 	updateWindowWithoutBlank(context);
	X_shift *= ((context.width-width/enlargeRate) >> 1)+X_shift*enlargeRate;
    	Y_shift *= ((context.height-TOPBAR_HEIGHT-height/enlargeRate) >> 1)+Y_shift*enlargeRate;
}

//缩小图片
void narrowPic(Context context,int narrowRate,int centerX, int centerY)
{
    int width = pic.width/(double)narrowRate;
    int height = pic.height/(double)narrowRate;
    compressPic(width,height);
    /*int centerConX = context.width/2.0;
    int centerConY = context.height/2.0;
    int moveX = centerConX - centerX;
    int moveY = centerConY - centerY;*/
    drawPicViewerWnd(context);
    draw_picture(context, pic, (context.width-width) >> 1, TOPBAR_HEIGHT + ((context.height-height) >> 1));
    startXsave = (context.width-width) >> 1;
    startYsave = TOPBAR_HEIGHT + ((context.height-height) >> 1);
    X_shift = 0;
    Y_shift = 0;
}

//图片放缩
void zoomingPic(Context context,int centerX, int centerY)
{
	
    if(centerX > context.width || centerY > context.height) return;
    int rate = 2;//待定等改
    switch(isZooming)
    {
        case 1:
            enlargePic(context,rate,centerX,centerY);
            isZooming = 2;
            break;
        case 2:
            narrowPic(context,rate,centerX,centerY);
            isZooming = 1;
            break;
        default:
            isZooming = 1;
            break;
    }
} 

//Picture Rolling
void rollingPic(Context context)
{
	RGBQUAD* cache = (RGBQUAD *) malloc(pic.width * pic.height * sizeof(RGBQUAD));
	int i,j;
	for (i = 0; i < pic.height; i++){
		for(j = 0; j < pic.width;j++){
			cache[(pic.width - 1 - j)*pic.height + i] = pic.data[i*pic.width + j];
		}	
	}
	free(pic.data);
	i = pic.width;
	pic.width = pic.height;
	pic.height = i;
	pic.data = cache;	
	drawPicViewerWnd(context);
    	draw_picture(context, pic, (context.width-pic.width) >> 1, TOPBAR_HEIGHT + ((context.height-pic.height) >> 1));
	startXsave = (context.width-pic.width) >> 1;
        startYsave = TOPBAR_HEIGHT + ((context.height-pic.height) >> 1);
	updateWindowWithoutBlank(context);
	
}

//Picture next
void nextPic(Context context)
{
	X_shift = 0;
	Y_shift = 0;
	isZooming = 1;
	pos = (pos+1) % len;	
	if(pos==0)pos++;
	printf(0,"%d\n",pos);
	loadBitmap(&pic, file[pos]);
	drawPicViewerWnd(context);
	drawPicViewerContent(context, file[pos]);
	updateWindowWithoutBlank(context);
	


	printf(0,"NEXT!\n");
	
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
    PICNODE rolling;
    loadBitmap(&rolling, "rolling.bmp");
    compressAnyPic(&rolling,16,16);
    draw_picture(context, rolling, 40, 3);
    freepic(&rolling);

    PICNODE next;
    loadBitmap(&next, "next.bmp");
    compressAnyPic(&next,16,16);
    draw_picture(context, next, 60, 3);
    freepic(&next);
}

//Update Something
void updateWindowWithoutBlank(Context context)
{
	PICNODE picCha;
  	draw_line(context, 0, 0, context.width - 1, 0, BORDERLINE_COLOR);
  	draw_line(context, context.width - 1, 0, context.width - 1, context.height - 1, BORDERLINE_COLOR);
  	draw_line(context, context.width - 1, context.height - 1, 0, context.height - 1, BORDERLINE_COLOR);
  	draw_line(context, 0, context.height - 1, 0, 0, BORDERLINE_COLOR);
  	fill_rect(context, 1, 1, context.width - 2, BOTTOMBAR_HEIGHT, TOPBAR_COLOR);
  	loadBitmap(&picCha, "close.bmp");
  	draw_picture(context, picCha, 3, 3);
  	puts_str(context, "PictureViewer", 0, WINDOW_WIDTH/2 - 53, 3);
  	freepic(&picCha);
	PICNODE rolling;
    	loadBitmap(&rolling, "rolling.bmp");
    	compressAnyPic(&rolling,16,16);
    	draw_picture(context, rolling, 40, 3);
    	freepic(&rolling);

	PICNODE next;
        loadBitmap(&next, "next.bmp");
        compressAnyPic(&next,16,16);
        draw_picture(context, next, 60, 3);
        freepic(&next);
	
}

void drawPicViewerContent(Context context, char* fileName) {
    int c_width, c_height;
    int pic_width, pic_height;

    c_width = context.width;
    c_height = context.height;
    pic_width = pic.width;
    pic_height = pic.height;

    printf(0, "drawPicViewerContent: pic_width: %d, pic_height: %d\n", pic_width, pic_height);
    draw_picture(context, pic, ((c_width-pic_width) >> 1) + X_shift, TOPBAR_HEIGHT + ((c_height-pic_height) >> 1) + Y_shift);
    startXsave = ((c_width-pic_width) >> 1) + X_shift;
    startYsave = TOPBAR_HEIGHT + ((c_height-pic_height) >> 1) + Y_shift;
}

void drawPicViewerContentForProper(Context context, char* fileName) {
    
    draw_picture(context, pic, startXsave, startYsave);
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


void propertyShow(Context context, int startX, int startY)
{
	printf(0, "Right Clicked: p.x:%d, p.y:%d\n",startX,startY);
	printf(0, "Right Clicked: pic.width:%d, pic.height:%d\n",pic.width,pic.height);
	//int lengthX = 100;
	//int lengthY = 200;
	int width = pic.width;
	int height = pic.height;
	
	char*strw = (char*)malloc(10*sizeof(char));
	char*strh = (char*)malloc(10*sizeof(char));
	int i = 0;
	int lengthwt; 
	while(width>0)
	{
		strw[i] = width%10 + '0';
		width/=10;
		i++;	
	}
	
	lengthwt = i;
	for(;i<=10;i++)
	{
		strw[i] = '\0';
	}
	char* strwt = (char*)malloc((lengthwt+1)*sizeof(char));
	//printf(0,"%d",lengthwt);
	int k0 = 0;
	int k = lengthwt - 1;
	for(;k >= 0;k--)
	{
		if(strw[k0] != '\0')strwt[k] = strw[k0];
		else break;
		k0++;
		
	}
	strwt[lengthwt] = '\0';
	free(strw);
	
	printf(0,"In itoa w:");
	printf(0,strwt);
	printf(0,"\n");

	int j = 0;
	int lengthht; 
	while(height>0)
	{
		strh[j] = height%10 + '0';
		height/=10;
		j++;	
	}
	
	lengthht = j;
	for(;j<=10;j++)
	{
		strh[j] = '\0';
	}
	char* strht = (char*)malloc((lengthht+1)*sizeof(char));
	//printf(0,"%d",lengthht);
	int t0 = 0;
	int t = lengthht - 1;
	for(;t >= 0;t--)
	{
		if(strh[t0] != '\0')strht[t] = strh[t0];
		else break;
		t0++;
		
	}
	strht[lengthht] = '\0';
	free(strh);
	
	printf(0,"In itoa h:");
	printf(0,strht);
	printf(0,"\n");

	
	puts_str(context, "Width:", 0, startX+10, startY+10);
	puts_str(context, strwt, 0, startX+70, startY+10);
	puts_str(context, "Height:", 0, startX+10, startY+30);
	puts_str(context, strht, 0, startX+70, startY+30);
	
	//lengthX = 0;
	//lengthY = 0;
	updateWindowWithoutBlank(context);

}



int main(int argc, char *argv[]) {
    struct Context context;
    ClickableManager cm;//（这个东西是干吗用的？）
    int winid;
    struct Msg msg;
    Point p;
    len = atoi(argv[2]);
    pos = atoi(argv[3]) - 1;
printf(0,"%d",pos);
printf(0,"   %d   ",len);
    int i = 0;
    int j = 0;
    int k = 0;
    int end = -1;
    while(i <= len + 3){
	if (argv[2][i]=='\1'){
	    file[j] = (char*)malloc((i-end)*sizeof(char));
	    for(k = 0;k < (i-end);k++)
		file[j][k] = argv[2][end+1+k];
	    file[j][k-1] = '\0';
	    end = i;
	    j++;
	    
	}
	i++;
    }

	len = j;
	
	



    winid = init_context(&context, WINDOW_WIDTH, WINDOW_HEIGHT);//根据窗口大小初始化背景
    cm = initClickManager(context);//根据背景初始化ClickableManager

    loadBitmap(&pic, file[pos]);//载入bmp
    load_iconlist(wndRes, sizeof(wndRes) / sizeof(ICON));//载入图标数组

    modifyPic(context);//按照背景修改图片
    deleteClickable(&cm.left_click, initRect(0, 0, 800, 600));
    addWndEvent(&cm);//添加cm到窗口事件

    Initialize(context);

    while (isRun) {
        getMsg(&msg);//获取消息
        switch (msg.msg_type) {//判断消息类型
		case MSG_DOUBLECLICK://双击消息
			p = initPoint(msg.concrete_msg.msg_mouse.x,msg.concrete_msg.msg_mouse.y);//获取到鼠标现在的点
			if (executeHandler(cm.double_click, p))//（暂时不懂）
            		{
				updateWindow(winid, context.addr, msg.msg_detail);//更新窗口
			}
            		printf(0,"DoubleClick: context_width: %d, context_height: %d\n", context.width, context.height);
			printf(0,"DoubleClick: mouseX: %d, mouseY: %d\n", p.x, p.y);
            		zoomingPic(context,p.x,p.y);
            		updateWindow(winid, context.addr, msg.msg_detail);
                
			break;
		case MSG_UPDATE://更新消息（太好了貌似可以直接调重绘了）
			drawPicViewerWnd(context);//绘制窗口
			drawPicViewerContent(context, file[pos]);//背景里绘制图片
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

			//Rolling Button Area:(40,3),(56,18)
			int RBlowX = 40;
			int RBlowY = 3;
			int RBhighX = 56;
			int RBhighY = 18;
			if(p.x >= RBlowX && p.x <= RBhighX && p.y >= RBlowY && p.y <= RBhighY)
			{
				rollingPic(context);
				
			}

			int NElowX = 60;
			int NElowY = 3;
			int NEhighX = 76;
			int NEhighY = 18;
			if(p.x >= NElowX && p.x <= NEhighX && p.y >= NElowY && p.y <= NEhighY)
			{
				nextPic(context);
			}

			updateWindow(winid, context.addr, msg.msg_detail);//更新窗口

			if (executeHandler(cm.left_click, p)) {//（暂时不懂）

				updateWindow(winid, context.addr, msg.msg_detail);
			}
			break;
		case MSG_RPRESS://鼠标右键按下
			p = initPoint(msg.concrete_msg.msg_mouse.x,
					msg.concrete_msg.msg_mouse.y);
			if(isShowing == 0)
			{
				propertyShow(context, p.x, p.y);
				isShowing = 1;
			}
			else if(isShowing == 1)
			{
				drawPicViewerWnd(context);
				drawPicViewerContentForProper(context, file[pos]);//背景里绘制图片
				isShowing = 0;
			}
			updateWindow(winid, context.addr, msg.msg_detail);//更新窗口
			if (executeHandler(cm.right_click, p)) {
				updateWindow(winid, context.addr, msg.msg_detail);
			}
			break;
		case MSG_KEYDOWN:
			switch(msg.concrete_msg.msg_key.key) {
				case 52:
					X_shift -= shift_at_once;
					break;
				case 54:
					X_shift += shift_at_once;
					break;
				case 56:
					Y_shift -= shift_at_once;
					break;
				case 50:
					Y_shift += shift_at_once;
					break;
				default:
					break;
			}
			drawPicViewerWnd(context);
			drawPicViewerContent(context, file[pos]);
			updateWindowWithoutBlank(context);
			updateWindow(winid, context.addr, msg.msg_detail);
			break;
		default:
			break;
		}
    }
    free_context(&context, winid);
    exit();
}
