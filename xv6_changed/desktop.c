#include "types.h"
#include "stat.h"
#include "user.h"
#include "context.h"
#include "drawingAPI.h"
#include "bitmap.h"
#include "message.h"
#include "clickable.h"

ICON iconlist[] = {
    {"music.bmp", 175, 400},
    {"finder.bmp", 300, 400},
    {"terminal.bmp", 425, 400},
    //{"setting.bmp", 550, 400}
};

void shellinit(Point point)
{
    int pid;
    char* shell_argv[] = { "shell_gui", 0 };

    printf(1, "init shell: starting shell\n");
    pid = fork();
    if (pid < 0)
    {
        printf(1, "init shell: fork failed\n");
        exit();
    }
    if (pid == 0)
    {
        exec("shell_gui", shell_argv);
        printf(1, "init shell: exec shell failed\n");
        exit();
    }
//    return pid;
}

void finderinit(Point point)
{
    int pid;
    char* finder_argv[] = { "finder", 0 };

    printf(1, "init finder: starting finder\n");
    pid = fork();
    if (pid < 0)
    {
        printf(1, "init finder: fork failed\n");
        exit();
    }
    if (pid == 0)
    {
        exec("finder", finder_argv);
        printf(1, "init finder: exec finder failed\n");
        exit();
    }
//    return pid;
}

void playmusic(Point point)
{
    int pid;
    char* argv[] = { "playmusic", "qian.wav" , "test.wav", "in.mp3"};
    printf(0, "init player: starting player \n");
    pid = fork();
    if (pid < 0)
    {
        printf(1, "init player: fork failed\n");
        exit();
    }
    if (pid == 0)
    {
        exec("playmusic", argv);
        printf(1, "init player: exec play failed\n");
        exit();
    }
}

int main(int argc, char *argv[])
{
    int winid;
    struct Msg msg;
    struct Context context;
    //int shell_pid;
    //int finder_pid;
    short isRun = 1;
//    short isInit = 1;
    ClickableManager manager;

    winid = init_context(&context, 800, 600);
    fill_rect(context, 0, 0, context.width, context.height, 0xffff);
//    puts_str(context, "desktop: welcome", 0x0, 0, 0);

    PICNODE pic1, pic2, pic3, background;
    loadBitmap(&pic1, "music.bmp");
    loadBitmap(&pic2, "setting.bmp");
    loadBitmap(&pic3, "notes.bmp");
    //loadBitmap(&background, "bg.bmp");
    set_icon_alpha(&pic1);
    set_icon_alpha(&pic2);
    set_icon_alpha(&pic3);
//    set_icon_alpha(&pic4);
//
    //fill_rect(context, 160, 400, 500, 150, 0x0101);
//    //loadBitmap(&background, "bg.bmp");

    draw_picture(context, background, 0, 0);
    draw_picture(context, pic1, 225, 450);
    draw_picture(context, pic2, 363, 450);
    draw_picture(context, pic3, 500, 450);
    //draw_iconlist(context, iconlist, sizeof(iconlist) / sizeof(ICON));

    manager = initClickManager(context);
    createClickable(&manager, initRect(225, 450, 75, 75), MSG_DOUBLECLICK, playmusic);
    createClickable(&manager, initRect(367, 450, 75, 75), MSG_DOUBLECLICK, shellinit);
    createClickable(&manager, initRect(500, 450, 75, 75), MSG_DOUBLECLICK, finderinit);

    while(isRun)
    {
        getMsg(&msg);
        switch(msg.msg_type)
        {
            case MSG_UPDATE:
                printf(1, "msg_detail %d\n", msg.msg_detail);
                updateWindow(winid, context.addr, msg.msg_detail);
                //printf(0, "desktop");
                /*if (isInit)
                {
                    finderinit((Point){0, 0});
                    //finderinit((Point){0, 0});
                    //shell_pid = shellinit((Point){context.width / 2, context.height / 2});
                    //shellinit((Point){context.width / 2, context.height / 2});
                    isInit = 0;
                }*/
                break;
            case MSG_PARTIAL_UPDATE:
                updatePartialWindow(winid, context.addr, msg.concrete_msg.msg_partial_update.x1, msg.concrete_msg.msg_partial_update.y1, msg.concrete_msg.msg_partial_update.x2, msg.concrete_msg.msg_partial_update.y2);
                break;
            case MSG_DOUBLECLICK:
                executeHandler(manager.double_click, initPoint(msg.concrete_msg.msg_mouse.x, msg.concrete_msg.msg_mouse.y));
                break;
            default:
                break;
        }
    }

    //int windowId;
    //int result;

    //windowId = createWindow(0, 0, 800, 600);
    //printf(0, "windowId: %d\n", windowId);


    //result = updateWindow(windowId, context.addr);
    //printf(0, "updateResult: %d\n", result);

    free_context(&context, winid);
    exit();
}
