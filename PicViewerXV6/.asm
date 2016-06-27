
_picviewer:     file format elf32-i386


Disassembly of section .text:

00000000 <Initialize>:
void drawPicViewerContent(Context context, char* fileName);
void updateWindowWithoutBlank(Context context);

//Initialize
void Initialize(Context context)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
	startXsave = (context.width-pic.width) >> 1;
       3:	8b 55 0c             	mov    0xc(%ebp),%edx
       6:	a1 04 1a 01 00       	mov    0x11a04,%eax
       b:	29 c2                	sub    %eax,%edx
       d:	89 d0                	mov    %edx,%eax
       f:	d1 f8                	sar    %eax
      11:	a3 04 ec 00 00       	mov    %eax,0xec04
	startYsave = TOPBAR_HEIGHT + ((context.height-pic.height) >> 1);
      16:	8b 55 10             	mov    0x10(%ebp),%edx
      19:	a1 08 1a 01 00       	mov    0x11a08,%eax
      1e:	29 c2                	sub    %eax,%edx
      20:	89 d0                	mov    %edx,%eax
      22:	d1 f8                	sar    %eax
      24:	83 c0 14             	add    $0x14,%eax
      27:	a3 08 ec 00 00       	mov    %eax,0xec08
}
      2c:	5d                   	pop    %ebp
      2d:	c3                   	ret    

0000002e <compressPic>:

// 压缩图片
void compressPic(int width, int height) {
      2e:	55                   	push   %ebp
      2f:	89 e5                	mov    %esp,%ebp
      31:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int x0, y0, x1, x2, y1, y2;
    float fx1, fx2, fy1, fy2;
    int x, y, index;
    RGBQUAD* data;

    w0 = pic.width;//图宽
      37:	a1 04 1a 01 00       	mov    0x11a04,%eax
      3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    h0 = pic.height;//图高
      3f:	a1 08 1a 01 00       	mov    0x11a08,%eax
      44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    w1 = width;//设定宽
      47:	8b 45 08             	mov    0x8(%ebp),%eax
      4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    h1 = height;//设定高
      4d:	8b 45 0c             	mov    0xc(%ebp),%eax
      50:	89 45 dc             	mov    %eax,-0x24(%ebp)

    fw = w0 * 1.0 / w1;//宽缩比
      53:	db 45 e8             	fildl  -0x18(%ebp)
      56:	db 45 e0             	fildl  -0x20(%ebp)
      59:	de f9                	fdivrp %st,%st(1)
      5b:	d9 5d d8             	fstps  -0x28(%ebp)
    fh = h0 * 1.0 / h1;//高缩比
      5e:	db 45 e4             	fildl  -0x1c(%ebp)
      61:	db 45 dc             	fildl  -0x24(%ebp)
      64:	de f9                	fdivrp %st,%st(1)
      66:	d9 5d d4             	fstps  -0x2c(%ebp)

    index = 0;
      69:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    data = (RGBQUAD*)malloc(w1*h1*sizeof(RGBQUAD));//新图颜色表
      70:	8b 45 e0             	mov    -0x20(%ebp),%eax
      73:	0f af 45 dc          	imul   -0x24(%ebp),%eax
      77:	c1 e0 02             	shl    $0x2,%eax
      7a:	89 04 24             	mov    %eax,(%esp)
      7d:	e8 ac 45 00 00       	call   462e <malloc>
      82:	89 45 d0             	mov    %eax,-0x30(%ebp)
    memset(data, 0, (uint)w1*h1*sizeof(RGBQUAD));
      85:	8b 55 e0             	mov    -0x20(%ebp),%edx
      88:	8b 45 dc             	mov    -0x24(%ebp),%eax
      8b:	0f af c2             	imul   %edx,%eax
      8e:	c1 e0 02             	shl    $0x2,%eax
      91:	89 44 24 08          	mov    %eax,0x8(%esp)
      95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      9c:	00 
      9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
      a0:	89 04 24             	mov    %eax,(%esp)
      a3:	e8 05 3f 00 00       	call   3fad <memset>
    
    for (y = 0; y < h1; ++y)//双线性插值法  此算法个人认为需要看一下效果，如果好就用它缩放 h1=10,h0=5,w1=9,w0=3
      a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      af:	e9 07 03 00 00       	jmp    3bb <compressPic+0x38d>
    {
        y0 = y*fh;//y=0,y0=0
      b4:	db 45 f0             	fildl  -0x10(%ebp)
      b7:	d8 4d d4             	fmuls  -0x2c(%ebp)
      ba:	d9 bd 7e ff ff ff    	fnstcw -0x82(%ebp)
      c0:	0f b7 85 7e ff ff ff 	movzwl -0x82(%ebp),%eax
      c7:	b4 0c                	mov    $0xc,%ah
      c9:	66 89 85 7c ff ff ff 	mov    %ax,-0x84(%ebp)
      d0:	d9 ad 7c ff ff ff    	fldcw  -0x84(%ebp)
      d6:	db 5d cc             	fistpl -0x34(%ebp)
      d9:	d9 ad 7e ff ff ff    	fldcw  -0x82(%ebp)
        y1 = (int)y0;//y1=0
      df:	8b 45 cc             	mov    -0x34(%ebp),%eax
      e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
        y2 = (y1 == h0-1) ? y1 : y1 + 1;//y2=1
      e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      e8:	83 e8 01             	sub    $0x1,%eax
      eb:	3b 45 c8             	cmp    -0x38(%ebp),%eax
      ee:	74 08                	je     f8 <compressPic+0xca>
      f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
      f3:	83 c0 01             	add    $0x1,%eax
      f6:	eb 03                	jmp    fb <compressPic+0xcd>
      f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
      fb:	89 45 c4             	mov    %eax,-0x3c(%ebp)

        fy1 = y1-y0;//fy1=0
      fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
     101:	8b 55 c8             	mov    -0x38(%ebp),%edx
     104:	29 c2                	sub    %eax,%edx
     106:	89 d0                	mov    %edx,%eax
     108:	89 45 80             	mov    %eax,-0x80(%ebp)
     10b:	db 45 80             	fildl  -0x80(%ebp)
     10e:	d9 5d c0             	fstps  -0x40(%ebp)
        fy2 = 1.0f-fy1;//fy2=1
     111:	d9 e8                	fld1   
     113:	d8 65 c0             	fsubs  -0x40(%ebp)
     116:	d9 5d bc             	fstps  -0x44(%ebp)

        for (x = 0; x < w1; ++x) {
     119:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     120:	e9 86 02 00 00       	jmp    3ab <compressPic+0x37d>
            x0 = x*fw;//x=0,x0=0
     125:	db 45 f4             	fildl  -0xc(%ebp)
     128:	d8 4d d8             	fmuls  -0x28(%ebp)
     12b:	d9 ad 7c ff ff ff    	fldcw  -0x84(%ebp)
     131:	db 5d b8             	fistpl -0x48(%ebp)
     134:	d9 ad 7e ff ff ff    	fldcw  -0x82(%ebp)
            x1 = (int)x0;//x1=0
     13a:	8b 45 b8             	mov    -0x48(%ebp),%eax
     13d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
            x2 = (x1 == w0-1) ? x1 : x1 + 1;//x2=1
     140:	8b 45 e8             	mov    -0x18(%ebp),%eax
     143:	83 e8 01             	sub    $0x1,%eax
     146:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
     149:	74 08                	je     153 <compressPic+0x125>
     14b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     14e:	83 c0 01             	add    $0x1,%eax
     151:	eb 03                	jmp    156 <compressPic+0x128>
     153:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     156:	89 45 b0             	mov    %eax,-0x50(%ebp)

            fx1 = x1-x0;//fx1=0    //y1=y0??????
     159:	8b 45 b8             	mov    -0x48(%ebp),%eax
     15c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
     15f:	29 c2                	sub    %eax,%edx
     161:	89 d0                	mov    %edx,%eax
     163:	89 45 80             	mov    %eax,-0x80(%ebp)
     166:	db 45 80             	fildl  -0x80(%ebp)
     169:	d9 5d ac             	fstps  -0x54(%ebp)
            fx2 = 1.0f-fx1;//fx2=1
     16c:	d9 e8                	fld1   
     16e:	d8 65 ac             	fsubs  -0x54(%ebp)
     171:	d9 5d a8             	fstps  -0x58(%ebp)

            float s1 = fx1*fy1;//s1=0
     174:	d9 45 ac             	flds   -0x54(%ebp)
     177:	d8 4d c0             	fmuls  -0x40(%ebp)
     17a:	d9 5d a4             	fstps  -0x5c(%ebp)
            float s2 = fx2*fy1;//s2=0
     17d:	d9 45 a8             	flds   -0x58(%ebp)
     180:	d8 4d c0             	fmuls  -0x40(%ebp)
     183:	d9 5d a0             	fstps  -0x60(%ebp)
            float s3 = fx2*fy2;//s3=1
     186:	d9 45 a8             	flds   -0x58(%ebp)
     189:	d8 4d bc             	fmuls  -0x44(%ebp)
     18c:	d9 5d 9c             	fstps  -0x64(%ebp)
            float s4 = fx1*fy2;//s4=0
     18f:	d9 45 ac             	flds   -0x54(%ebp)
     192:	d8 4d bc             	fmuls  -0x44(%ebp)
     195:	d9 5d 98             	fstps  -0x68(%ebp)

            RGBQUAD p1, p2, p3, p4;
            p1 = pic.data[x1+y1*w0];//p1=pic.data[0]
     198:	8b 15 00 1a 01 00    	mov    0x11a00,%edx
     19e:	8b 45 c8             	mov    -0x38(%ebp),%eax
     1a1:	0f af 45 e8          	imul   -0x18(%ebp),%eax
     1a5:	89 c1                	mov    %eax,%ecx
     1a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     1aa:	01 c8                	add    %ecx,%eax
     1ac:	c1 e0 02             	shl    $0x2,%eax
     1af:	01 d0                	add    %edx,%eax
     1b1:	8b 00                	mov    (%eax),%eax
     1b3:	89 45 94             	mov    %eax,-0x6c(%ebp)
            p2 = pic.data[x2+y1*w0];//p2=pic.data[1]
     1b6:	8b 15 00 1a 01 00    	mov    0x11a00,%edx
     1bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
     1bf:	0f af 45 e8          	imul   -0x18(%ebp),%eax
     1c3:	89 c1                	mov    %eax,%ecx
     1c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
     1c8:	01 c8                	add    %ecx,%eax
     1ca:	c1 e0 02             	shl    $0x2,%eax
     1cd:	01 d0                	add    %edx,%eax
     1cf:	8b 00                	mov    (%eax),%eax
     1d1:	89 45 90             	mov    %eax,-0x70(%ebp)
            p3 = pic.data[x1+y2*w0];//p3=pic.data[3]
     1d4:	8b 15 00 1a 01 00    	mov    0x11a00,%edx
     1da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     1dd:	0f af 45 e8          	imul   -0x18(%ebp),%eax
     1e1:	89 c1                	mov    %eax,%ecx
     1e3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     1e6:	01 c8                	add    %ecx,%eax
     1e8:	c1 e0 02             	shl    $0x2,%eax
     1eb:	01 d0                	add    %edx,%eax
     1ed:	8b 00                	mov    (%eax),%eax
     1ef:	89 45 8c             	mov    %eax,-0x74(%ebp)
            p4 = pic.data[x2+y2*w0];//p4=pic.data[4]
     1f2:	8b 15 00 1a 01 00    	mov    0x11a00,%edx
     1f8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     1fb:	0f af 45 e8          	imul   -0x18(%ebp),%eax
     1ff:	89 c1                	mov    %eax,%ecx
     201:	8b 45 b0             	mov    -0x50(%ebp),%eax
     204:	01 c8                	add    %ecx,%eax
     206:	c1 e0 02             	shl    $0x2,%eax
     209:	01 d0                	add    %edx,%eax
     20b:	8b 00                	mov    (%eax),%eax
     20d:	89 45 88             	mov    %eax,-0x78(%ebp)

            data[index].rgbRed = (BYTE)(p1.rgbRed*s3 + p2.rgbRed*s4 + p3.rgbRed*s2 + p4.rgbRed*s1);
     210:	8b 45 ec             	mov    -0x14(%ebp),%eax
     213:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     21a:	8b 45 d0             	mov    -0x30(%ebp),%eax
     21d:	01 c2                	add    %eax,%edx
     21f:	0f b6 45 96          	movzbl -0x6a(%ebp),%eax
     223:	0f b6 c0             	movzbl %al,%eax
     226:	89 45 80             	mov    %eax,-0x80(%ebp)
     229:	db 45 80             	fildl  -0x80(%ebp)
     22c:	d8 4d 9c             	fmuls  -0x64(%ebp)
     22f:	0f b6 45 92          	movzbl -0x6e(%ebp),%eax
     233:	0f b6 c0             	movzbl %al,%eax
     236:	89 45 80             	mov    %eax,-0x80(%ebp)
     239:	db 45 80             	fildl  -0x80(%ebp)
     23c:	d8 4d 98             	fmuls  -0x68(%ebp)
     23f:	de c1                	faddp  %st,%st(1)
     241:	0f b6 45 8e          	movzbl -0x72(%ebp),%eax
     245:	0f b6 c0             	movzbl %al,%eax
     248:	89 45 80             	mov    %eax,-0x80(%ebp)
     24b:	db 45 80             	fildl  -0x80(%ebp)
     24e:	d8 4d a0             	fmuls  -0x60(%ebp)
     251:	de c1                	faddp  %st,%st(1)
     253:	0f b6 45 8a          	movzbl -0x76(%ebp),%eax
     257:	0f b6 c0             	movzbl %al,%eax
     25a:	89 45 80             	mov    %eax,-0x80(%ebp)
     25d:	db 45 80             	fildl  -0x80(%ebp)
     260:	d8 4d a4             	fmuls  -0x5c(%ebp)
     263:	de c1                	faddp  %st,%st(1)
     265:	d9 ad 7c ff ff ff    	fldcw  -0x84(%ebp)
     26b:	df 9d 7a ff ff ff    	fistp  -0x86(%ebp)
     271:	d9 ad 7e ff ff ff    	fldcw  -0x82(%ebp)
     277:	0f b7 85 7a ff ff ff 	movzwl -0x86(%ebp),%eax
     27e:	88 42 02             	mov    %al,0x2(%edx)
            data[index].rgbGreen = (BYTE)(p1.rgbGreen*s3 + p2.rgbGreen*s4 + p3.rgbGreen*s2 + p4.rgbGreen*s1);
     281:	8b 45 ec             	mov    -0x14(%ebp),%eax
     284:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     28b:	8b 45 d0             	mov    -0x30(%ebp),%eax
     28e:	01 c2                	add    %eax,%edx
     290:	0f b6 45 95          	movzbl -0x6b(%ebp),%eax
     294:	0f b6 c0             	movzbl %al,%eax
     297:	89 45 80             	mov    %eax,-0x80(%ebp)
     29a:	db 45 80             	fildl  -0x80(%ebp)
     29d:	d8 4d 9c             	fmuls  -0x64(%ebp)
     2a0:	0f b6 45 91          	movzbl -0x6f(%ebp),%eax
     2a4:	0f b6 c0             	movzbl %al,%eax
     2a7:	89 45 80             	mov    %eax,-0x80(%ebp)
     2aa:	db 45 80             	fildl  -0x80(%ebp)
     2ad:	d8 4d 98             	fmuls  -0x68(%ebp)
     2b0:	de c1                	faddp  %st,%st(1)
     2b2:	0f b6 45 8d          	movzbl -0x73(%ebp),%eax
     2b6:	0f b6 c0             	movzbl %al,%eax
     2b9:	89 45 80             	mov    %eax,-0x80(%ebp)
     2bc:	db 45 80             	fildl  -0x80(%ebp)
     2bf:	d8 4d a0             	fmuls  -0x60(%ebp)
     2c2:	de c1                	faddp  %st,%st(1)
     2c4:	0f b6 45 89          	movzbl -0x77(%ebp),%eax
     2c8:	0f b6 c0             	movzbl %al,%eax
     2cb:	89 45 80             	mov    %eax,-0x80(%ebp)
     2ce:	db 45 80             	fildl  -0x80(%ebp)
     2d1:	d8 4d a4             	fmuls  -0x5c(%ebp)
     2d4:	de c1                	faddp  %st,%st(1)
     2d6:	d9 ad 7c ff ff ff    	fldcw  -0x84(%ebp)
     2dc:	df 9d 7a ff ff ff    	fistp  -0x86(%ebp)
     2e2:	d9 ad 7e ff ff ff    	fldcw  -0x82(%ebp)
     2e8:	0f b7 85 7a ff ff ff 	movzwl -0x86(%ebp),%eax
     2ef:	88 42 01             	mov    %al,0x1(%edx)
            data[index].rgbBlue = (BYTE)(p1.rgbBlue*s3 + p2.rgbBlue*s4 + p3.rgbBlue*s2 + p4.rgbBlue*s1);
     2f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     2fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
     2ff:	01 c2                	add    %eax,%edx
     301:	0f b6 45 94          	movzbl -0x6c(%ebp),%eax
     305:	0f b6 c0             	movzbl %al,%eax
     308:	89 45 80             	mov    %eax,-0x80(%ebp)
     30b:	db 45 80             	fildl  -0x80(%ebp)
     30e:	d8 4d 9c             	fmuls  -0x64(%ebp)
     311:	0f b6 45 90          	movzbl -0x70(%ebp),%eax
     315:	0f b6 c0             	movzbl %al,%eax
     318:	89 45 80             	mov    %eax,-0x80(%ebp)
     31b:	db 45 80             	fildl  -0x80(%ebp)
     31e:	d8 4d 98             	fmuls  -0x68(%ebp)
     321:	de c1                	faddp  %st,%st(1)
     323:	0f b6 45 8c          	movzbl -0x74(%ebp),%eax
     327:	0f b6 c0             	movzbl %al,%eax
     32a:	89 45 80             	mov    %eax,-0x80(%ebp)
     32d:	db 45 80             	fildl  -0x80(%ebp)
     330:	d8 4d a0             	fmuls  -0x60(%ebp)
     333:	de c1                	faddp  %st,%st(1)
     335:	0f b6 45 88          	movzbl -0x78(%ebp),%eax
     339:	0f b6 c0             	movzbl %al,%eax
     33c:	89 45 80             	mov    %eax,-0x80(%ebp)
     33f:	db 45 80             	fildl  -0x80(%ebp)
     342:	d8 4d a4             	fmuls  -0x5c(%ebp)
     345:	de c1                	faddp  %st,%st(1)
     347:	d9 ad 7c ff ff ff    	fldcw  -0x84(%ebp)
     34d:	df 9d 7a ff ff ff    	fistp  -0x86(%ebp)
     353:	d9 ad 7e ff ff ff    	fldcw  -0x82(%ebp)
     359:	0f b7 85 7a ff ff ff 	movzwl -0x86(%ebp),%eax
     360:	88 02                	mov    %al,(%edx)

            data[index].rgbRed = p1.rgbRed;
     362:	8b 45 ec             	mov    -0x14(%ebp),%eax
     365:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     36c:	8b 45 d0             	mov    -0x30(%ebp),%eax
     36f:	01 c2                	add    %eax,%edx
     371:	0f b6 45 96          	movzbl -0x6a(%ebp),%eax
     375:	88 42 02             	mov    %al,0x2(%edx)
            data[index].rgbGreen = p1.rgbGreen;
     378:	8b 45 ec             	mov    -0x14(%ebp),%eax
     37b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     382:	8b 45 d0             	mov    -0x30(%ebp),%eax
     385:	01 c2                	add    %eax,%edx
     387:	0f b6 45 95          	movzbl -0x6b(%ebp),%eax
     38b:	88 42 01             	mov    %al,0x1(%edx)
            data[index].rgbBlue = p1.rgbBlue;
     38e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     398:	8b 45 d0             	mov    -0x30(%ebp),%eax
     39b:	01 c2                	add    %eax,%edx
     39d:	0f b6 45 94          	movzbl -0x6c(%ebp),%eax
     3a1:	88 02                	mov    %al,(%edx)

            ++index;
     3a3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        y2 = (y1 == h0-1) ? y1 : y1 + 1;//y2=1

        fy1 = y1-y0;//fy1=0
        fy2 = 1.0f-fy1;//fy2=1

        for (x = 0; x < w1; ++x) {
     3a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     3ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3ae:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     3b1:	0f 8c 6e fd ff ff    	jl     125 <compressPic+0xf7>

    index = 0;
    data = (RGBQUAD*)malloc(w1*h1*sizeof(RGBQUAD));//新图颜色表
    memset(data, 0, (uint)w1*h1*sizeof(RGBQUAD));
    
    for (y = 0; y < h1; ++y)//双线性插值法  此算法个人认为需要看一下效果，如果好就用它缩放 h1=10,h0=5,w1=9,w0=3
     3b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     3bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3be:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     3c1:	0f 8c ed fc ff ff    	jl     b4 <compressPic+0x86>

            ++index;
        }
    }

    freepic(&pic);
     3c7:	c7 04 24 00 1a 01 00 	movl   $0x11a00,(%esp)
     3ce:	e8 61 31 00 00       	call   3534 <freepic>
    pic.data = data;
     3d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
     3d6:	a3 00 1a 01 00       	mov    %eax,0x11a00
    pic.width = width;
     3db:	8b 45 08             	mov    0x8(%ebp),%eax
     3de:	a3 04 1a 01 00       	mov    %eax,0x11a04
    pic.height = height;
     3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
     3e6:	a3 08 1a 01 00       	mov    %eax,0x11a08
}
     3eb:	c9                   	leave  
     3ec:	c3                   	ret    

000003ed <compressAnyPic>:

void compressAnyPic(PICNODE* anypic, int width, int height) {
     3ed:	55                   	push   %ebp
     3ee:	89 e5                	mov    %esp,%ebp
     3f0:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int x0, y0, x1, x2, y1, y2;
    float fx1, fx2, fy1, fy2;
    int x, y, index;
    RGBQUAD* data;

    w0 = anypic->width;//图宽
     3f6:	8b 45 08             	mov    0x8(%ebp),%eax
     3f9:	8b 40 04             	mov    0x4(%eax),%eax
     3fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    h0 = anypic->height;//图高
     3ff:	8b 45 08             	mov    0x8(%ebp),%eax
     402:	8b 40 08             	mov    0x8(%eax),%eax
     405:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    w1 = width;//设定宽
     408:	8b 45 0c             	mov    0xc(%ebp),%eax
     40b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    h1 = height;//设定高
     40e:	8b 45 10             	mov    0x10(%ebp),%eax
     411:	89 45 dc             	mov    %eax,-0x24(%ebp)

    fw = w0 * 1.0 / w1;//宽缩比
     414:	db 45 e8             	fildl  -0x18(%ebp)
     417:	db 45 e0             	fildl  -0x20(%ebp)
     41a:	de f9                	fdivrp %st,%st(1)
     41c:	d9 5d d8             	fstps  -0x28(%ebp)
    fh = h0 * 1.0 / h1;//高缩比
     41f:	db 45 e4             	fildl  -0x1c(%ebp)
     422:	db 45 dc             	fildl  -0x24(%ebp)
     425:	de f9                	fdivrp %st,%st(1)
     427:	d9 5d d4             	fstps  -0x2c(%ebp)

    index = 0;
     42a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    data = (RGBQUAD*)malloc(w1*h1*sizeof(RGBQUAD));//新图颜色表
     431:	8b 45 e0             	mov    -0x20(%ebp),%eax
     434:	0f af 45 dc          	imul   -0x24(%ebp),%eax
     438:	c1 e0 02             	shl    $0x2,%eax
     43b:	89 04 24             	mov    %eax,(%esp)
     43e:	e8 eb 41 00 00       	call   462e <malloc>
     443:	89 45 d0             	mov    %eax,-0x30(%ebp)
    memset(data, 0, (uint)w1*h1*sizeof(RGBQUAD));
     446:	8b 55 e0             	mov    -0x20(%ebp),%edx
     449:	8b 45 dc             	mov    -0x24(%ebp),%eax
     44c:	0f af c2             	imul   %edx,%eax
     44f:	c1 e0 02             	shl    $0x2,%eax
     452:	89 44 24 08          	mov    %eax,0x8(%esp)
     456:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     45d:	00 
     45e:	8b 45 d0             	mov    -0x30(%ebp),%eax
     461:	89 04 24             	mov    %eax,(%esp)
     464:	e8 44 3b 00 00       	call   3fad <memset>
    
    for (y = 0; y < h1; ++y)//双线性插值法  此算法个人认为需要看一下效果，如果好就用它缩放 h1=10,h0=5,w1=9,w0=3
     469:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     470:	e9 03 03 00 00       	jmp    778 <compressAnyPic+0x38b>
    {
        y0 = y*fh;//y=0,y0=0
     475:	db 45 f0             	fildl  -0x10(%ebp)
     478:	d8 4d d4             	fmuls  -0x2c(%ebp)
     47b:	d9 bd 7e ff ff ff    	fnstcw -0x82(%ebp)
     481:	0f b7 85 7e ff ff ff 	movzwl -0x82(%ebp),%eax
     488:	b4 0c                	mov    $0xc,%ah
     48a:	66 89 85 7c ff ff ff 	mov    %ax,-0x84(%ebp)
     491:	d9 ad 7c ff ff ff    	fldcw  -0x84(%ebp)
     497:	db 5d cc             	fistpl -0x34(%ebp)
     49a:	d9 ad 7e ff ff ff    	fldcw  -0x82(%ebp)
        y1 = (int)y0;//y1=0
     4a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
     4a3:	89 45 c8             	mov    %eax,-0x38(%ebp)
        y2 = (y1 == h0-1) ? y1 : y1 + 1;//y2=1
     4a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     4a9:	83 e8 01             	sub    $0x1,%eax
     4ac:	3b 45 c8             	cmp    -0x38(%ebp),%eax
     4af:	74 08                	je     4b9 <compressAnyPic+0xcc>
     4b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
     4b4:	83 c0 01             	add    $0x1,%eax
     4b7:	eb 03                	jmp    4bc <compressAnyPic+0xcf>
     4b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
     4bc:	89 45 c4             	mov    %eax,-0x3c(%ebp)

        fy1 = y1-y0;//fy1=0
     4bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
     4c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
     4c5:	29 c2                	sub    %eax,%edx
     4c7:	89 d0                	mov    %edx,%eax
     4c9:	89 45 80             	mov    %eax,-0x80(%ebp)
     4cc:	db 45 80             	fildl  -0x80(%ebp)
     4cf:	d9 5d c0             	fstps  -0x40(%ebp)
        fy2 = 1.0f-fy1;//fy2=1
     4d2:	d9 e8                	fld1   
     4d4:	d8 65 c0             	fsubs  -0x40(%ebp)
     4d7:	d9 5d bc             	fstps  -0x44(%ebp)

        for (x = 0; x < w1; ++x) {
     4da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4e1:	e9 82 02 00 00       	jmp    768 <compressAnyPic+0x37b>
            x0 = x*fw;//x=0,x0=0
     4e6:	db 45 f4             	fildl  -0xc(%ebp)
     4e9:	d8 4d d8             	fmuls  -0x28(%ebp)
     4ec:	d9 ad 7c ff ff ff    	fldcw  -0x84(%ebp)
     4f2:	db 5d b8             	fistpl -0x48(%ebp)
     4f5:	d9 ad 7e ff ff ff    	fldcw  -0x82(%ebp)
            x1 = (int)x0;//x1=0
     4fb:	8b 45 b8             	mov    -0x48(%ebp),%eax
     4fe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
            x2 = (x1 == w0-1) ? x1 : x1 + 1;//x2=1
     501:	8b 45 e8             	mov    -0x18(%ebp),%eax
     504:	83 e8 01             	sub    $0x1,%eax
     507:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
     50a:	74 08                	je     514 <compressAnyPic+0x127>
     50c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     50f:	83 c0 01             	add    $0x1,%eax
     512:	eb 03                	jmp    517 <compressAnyPic+0x12a>
     514:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     517:	89 45 b0             	mov    %eax,-0x50(%ebp)

            fx1 = x1-x0;//fx1=0    //y1=y0??????
     51a:	8b 45 b8             	mov    -0x48(%ebp),%eax
     51d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
     520:	29 c2                	sub    %eax,%edx
     522:	89 d0                	mov    %edx,%eax
     524:	89 45 80             	mov    %eax,-0x80(%ebp)
     527:	db 45 80             	fildl  -0x80(%ebp)
     52a:	d9 5d ac             	fstps  -0x54(%ebp)
            fx2 = 1.0f-fx1;//fx2=1
     52d:	d9 e8                	fld1   
     52f:	d8 65 ac             	fsubs  -0x54(%ebp)
     532:	d9 5d a8             	fstps  -0x58(%ebp)

            float s1 = fx1*fy1;//s1=0
     535:	d9 45 ac             	flds   -0x54(%ebp)
     538:	d8 4d c0             	fmuls  -0x40(%ebp)
     53b:	d9 5d a4             	fstps  -0x5c(%ebp)
            float s2 = fx2*fy1;//s2=0
     53e:	d9 45 a8             	flds   -0x58(%ebp)
     541:	d8 4d c0             	fmuls  -0x40(%ebp)
     544:	d9 5d a0             	fstps  -0x60(%ebp)
            float s3 = fx2*fy2;//s3=1
     547:	d9 45 a8             	flds   -0x58(%ebp)
     54a:	d8 4d bc             	fmuls  -0x44(%ebp)
     54d:	d9 5d 9c             	fstps  -0x64(%ebp)
            float s4 = fx1*fy2;//s4=0
     550:	d9 45 ac             	flds   -0x54(%ebp)
     553:	d8 4d bc             	fmuls  -0x44(%ebp)
     556:	d9 5d 98             	fstps  -0x68(%ebp)

            RGBQUAD p1, p2, p3, p4;
            p1 = anypic->data[x1+y1*w0];//p1=pic.data[0]
     559:	8b 45 08             	mov    0x8(%ebp),%eax
     55c:	8b 10                	mov    (%eax),%edx
     55e:	8b 45 c8             	mov    -0x38(%ebp),%eax
     561:	0f af 45 e8          	imul   -0x18(%ebp),%eax
     565:	89 c1                	mov    %eax,%ecx
     567:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     56a:	01 c8                	add    %ecx,%eax
     56c:	c1 e0 02             	shl    $0x2,%eax
     56f:	01 d0                	add    %edx,%eax
     571:	8b 00                	mov    (%eax),%eax
     573:	89 45 94             	mov    %eax,-0x6c(%ebp)
            p2 = anypic->data[x2+y1*w0];//p2=pic.data[1]
     576:	8b 45 08             	mov    0x8(%ebp),%eax
     579:	8b 10                	mov    (%eax),%edx
     57b:	8b 45 c8             	mov    -0x38(%ebp),%eax
     57e:	0f af 45 e8          	imul   -0x18(%ebp),%eax
     582:	89 c1                	mov    %eax,%ecx
     584:	8b 45 b0             	mov    -0x50(%ebp),%eax
     587:	01 c8                	add    %ecx,%eax
     589:	c1 e0 02             	shl    $0x2,%eax
     58c:	01 d0                	add    %edx,%eax
     58e:	8b 00                	mov    (%eax),%eax
     590:	89 45 90             	mov    %eax,-0x70(%ebp)
            p3 = anypic->data[x1+y2*w0];//p3=pic.data[3]
     593:	8b 45 08             	mov    0x8(%ebp),%eax
     596:	8b 10                	mov    (%eax),%edx
     598:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     59b:	0f af 45 e8          	imul   -0x18(%ebp),%eax
     59f:	89 c1                	mov    %eax,%ecx
     5a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     5a4:	01 c8                	add    %ecx,%eax
     5a6:	c1 e0 02             	shl    $0x2,%eax
     5a9:	01 d0                	add    %edx,%eax
     5ab:	8b 00                	mov    (%eax),%eax
     5ad:	89 45 8c             	mov    %eax,-0x74(%ebp)
            p4 = anypic->data[x2+y2*w0];//p4=pic.data[4]
     5b0:	8b 45 08             	mov    0x8(%ebp),%eax
     5b3:	8b 10                	mov    (%eax),%edx
     5b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     5b8:	0f af 45 e8          	imul   -0x18(%ebp),%eax
     5bc:	89 c1                	mov    %eax,%ecx
     5be:	8b 45 b0             	mov    -0x50(%ebp),%eax
     5c1:	01 c8                	add    %ecx,%eax
     5c3:	c1 e0 02             	shl    $0x2,%eax
     5c6:	01 d0                	add    %edx,%eax
     5c8:	8b 00                	mov    (%eax),%eax
     5ca:	89 45 88             	mov    %eax,-0x78(%ebp)

            data[index].rgbRed = (BYTE)(p1.rgbRed*s3 + p2.rgbRed*s4 + p3.rgbRed*s2 + p4.rgbRed*s1);
     5cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     5d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
     5da:	01 c2                	add    %eax,%edx
     5dc:	0f b6 45 96          	movzbl -0x6a(%ebp),%eax
     5e0:	0f b6 c0             	movzbl %al,%eax
     5e3:	89 45 80             	mov    %eax,-0x80(%ebp)
     5e6:	db 45 80             	fildl  -0x80(%ebp)
     5e9:	d8 4d 9c             	fmuls  -0x64(%ebp)
     5ec:	0f b6 45 92          	movzbl -0x6e(%ebp),%eax
     5f0:	0f b6 c0             	movzbl %al,%eax
     5f3:	89 45 80             	mov    %eax,-0x80(%ebp)
     5f6:	db 45 80             	fildl  -0x80(%ebp)
     5f9:	d8 4d 98             	fmuls  -0x68(%ebp)
     5fc:	de c1                	faddp  %st,%st(1)
     5fe:	0f b6 45 8e          	movzbl -0x72(%ebp),%eax
     602:	0f b6 c0             	movzbl %al,%eax
     605:	89 45 80             	mov    %eax,-0x80(%ebp)
     608:	db 45 80             	fildl  -0x80(%ebp)
     60b:	d8 4d a0             	fmuls  -0x60(%ebp)
     60e:	de c1                	faddp  %st,%st(1)
     610:	0f b6 45 8a          	movzbl -0x76(%ebp),%eax
     614:	0f b6 c0             	movzbl %al,%eax
     617:	89 45 80             	mov    %eax,-0x80(%ebp)
     61a:	db 45 80             	fildl  -0x80(%ebp)
     61d:	d8 4d a4             	fmuls  -0x5c(%ebp)
     620:	de c1                	faddp  %st,%st(1)
     622:	d9 ad 7c ff ff ff    	fldcw  -0x84(%ebp)
     628:	df 9d 7a ff ff ff    	fistp  -0x86(%ebp)
     62e:	d9 ad 7e ff ff ff    	fldcw  -0x82(%ebp)
     634:	0f b7 85 7a ff ff ff 	movzwl -0x86(%ebp),%eax
     63b:	88 42 02             	mov    %al,0x2(%edx)
            data[index].rgbGreen = (BYTE)(p1.rgbGreen*s3 + p2.rgbGreen*s4 + p3.rgbGreen*s2 + p4.rgbGreen*s1);
     63e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     641:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     648:	8b 45 d0             	mov    -0x30(%ebp),%eax
     64b:	01 c2                	add    %eax,%edx
     64d:	0f b6 45 95          	movzbl -0x6b(%ebp),%eax
     651:	0f b6 c0             	movzbl %al,%eax
     654:	89 45 80             	mov    %eax,-0x80(%ebp)
     657:	db 45 80             	fildl  -0x80(%ebp)
     65a:	d8 4d 9c             	fmuls  -0x64(%ebp)
     65d:	0f b6 45 91          	movzbl -0x6f(%ebp),%eax
     661:	0f b6 c0             	movzbl %al,%eax
     664:	89 45 80             	mov    %eax,-0x80(%ebp)
     667:	db 45 80             	fildl  -0x80(%ebp)
     66a:	d8 4d 98             	fmuls  -0x68(%ebp)
     66d:	de c1                	faddp  %st,%st(1)
     66f:	0f b6 45 8d          	movzbl -0x73(%ebp),%eax
     673:	0f b6 c0             	movzbl %al,%eax
     676:	89 45 80             	mov    %eax,-0x80(%ebp)
     679:	db 45 80             	fildl  -0x80(%ebp)
     67c:	d8 4d a0             	fmuls  -0x60(%ebp)
     67f:	de c1                	faddp  %st,%st(1)
     681:	0f b6 45 89          	movzbl -0x77(%ebp),%eax
     685:	0f b6 c0             	movzbl %al,%eax
     688:	89 45 80             	mov    %eax,-0x80(%ebp)
     68b:	db 45 80             	fildl  -0x80(%ebp)
     68e:	d8 4d a4             	fmuls  -0x5c(%ebp)
     691:	de c1                	faddp  %st,%st(1)
     693:	d9 ad 7c ff ff ff    	fldcw  -0x84(%ebp)
     699:	df 9d 7a ff ff ff    	fistp  -0x86(%ebp)
     69f:	d9 ad 7e ff ff ff    	fldcw  -0x82(%ebp)
     6a5:	0f b7 85 7a ff ff ff 	movzwl -0x86(%ebp),%eax
     6ac:	88 42 01             	mov    %al,0x1(%edx)
            data[index].rgbBlue = (BYTE)(p1.rgbBlue*s3 + p2.rgbBlue*s4 + p3.rgbBlue*s2 + p4.rgbBlue*s1);
     6af:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     6b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
     6bc:	01 c2                	add    %eax,%edx
     6be:	0f b6 45 94          	movzbl -0x6c(%ebp),%eax
     6c2:	0f b6 c0             	movzbl %al,%eax
     6c5:	89 45 80             	mov    %eax,-0x80(%ebp)
     6c8:	db 45 80             	fildl  -0x80(%ebp)
     6cb:	d8 4d 9c             	fmuls  -0x64(%ebp)
     6ce:	0f b6 45 90          	movzbl -0x70(%ebp),%eax
     6d2:	0f b6 c0             	movzbl %al,%eax
     6d5:	89 45 80             	mov    %eax,-0x80(%ebp)
     6d8:	db 45 80             	fildl  -0x80(%ebp)
     6db:	d8 4d 98             	fmuls  -0x68(%ebp)
     6de:	de c1                	faddp  %st,%st(1)
     6e0:	0f b6 45 8c          	movzbl -0x74(%ebp),%eax
     6e4:	0f b6 c0             	movzbl %al,%eax
     6e7:	89 45 80             	mov    %eax,-0x80(%ebp)
     6ea:	db 45 80             	fildl  -0x80(%ebp)
     6ed:	d8 4d a0             	fmuls  -0x60(%ebp)
     6f0:	de c1                	faddp  %st,%st(1)
     6f2:	0f b6 45 88          	movzbl -0x78(%ebp),%eax
     6f6:	0f b6 c0             	movzbl %al,%eax
     6f9:	89 45 80             	mov    %eax,-0x80(%ebp)
     6fc:	db 45 80             	fildl  -0x80(%ebp)
     6ff:	d8 4d a4             	fmuls  -0x5c(%ebp)
     702:	de c1                	faddp  %st,%st(1)
     704:	d9 ad 7c ff ff ff    	fldcw  -0x84(%ebp)
     70a:	df 9d 7a ff ff ff    	fistp  -0x86(%ebp)
     710:	d9 ad 7e ff ff ff    	fldcw  -0x82(%ebp)
     716:	0f b7 85 7a ff ff ff 	movzwl -0x86(%ebp),%eax
     71d:	88 02                	mov    %al,(%edx)

            data[index].rgbRed = p1.rgbRed;
     71f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     722:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     729:	8b 45 d0             	mov    -0x30(%ebp),%eax
     72c:	01 c2                	add    %eax,%edx
     72e:	0f b6 45 96          	movzbl -0x6a(%ebp),%eax
     732:	88 42 02             	mov    %al,0x2(%edx)
            data[index].rgbGreen = p1.rgbGreen;
     735:	8b 45 ec             	mov    -0x14(%ebp),%eax
     738:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     73f:	8b 45 d0             	mov    -0x30(%ebp),%eax
     742:	01 c2                	add    %eax,%edx
     744:	0f b6 45 95          	movzbl -0x6b(%ebp),%eax
     748:	88 42 01             	mov    %al,0x1(%edx)
            data[index].rgbBlue = p1.rgbBlue;
     74b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     74e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     755:	8b 45 d0             	mov    -0x30(%ebp),%eax
     758:	01 c2                	add    %eax,%edx
     75a:	0f b6 45 94          	movzbl -0x6c(%ebp),%eax
     75e:	88 02                	mov    %al,(%edx)

            ++index;
     760:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        y2 = (y1 == h0-1) ? y1 : y1 + 1;//y2=1

        fy1 = y1-y0;//fy1=0
        fy2 = 1.0f-fy1;//fy2=1

        for (x = 0; x < w1; ++x) {
     764:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     768:	8b 45 f4             	mov    -0xc(%ebp),%eax
     76b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     76e:	0f 8c 72 fd ff ff    	jl     4e6 <compressAnyPic+0xf9>

    index = 0;
    data = (RGBQUAD*)malloc(w1*h1*sizeof(RGBQUAD));//新图颜色表
    memset(data, 0, (uint)w1*h1*sizeof(RGBQUAD));
    
    for (y = 0; y < h1; ++y)//双线性插值法  此算法个人认为需要看一下效果，如果好就用它缩放 h1=10,h0=5,w1=9,w0=3
     774:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     778:	8b 45 f0             	mov    -0x10(%ebp),%eax
     77b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     77e:	0f 8c f1 fc ff ff    	jl     475 <compressAnyPic+0x88>

            ++index;
        }
    }

    freepic(anypic);
     784:	8b 45 08             	mov    0x8(%ebp),%eax
     787:	89 04 24             	mov    %eax,(%esp)
     78a:	e8 a5 2d 00 00       	call   3534 <freepic>
    anypic->data = data;
     78f:	8b 45 08             	mov    0x8(%ebp),%eax
     792:	8b 55 d0             	mov    -0x30(%ebp),%edx
     795:	89 10                	mov    %edx,(%eax)
    anypic->width = width;
     797:	8b 45 08             	mov    0x8(%ebp),%eax
     79a:	8b 55 0c             	mov    0xc(%ebp),%edx
     79d:	89 50 04             	mov    %edx,0x4(%eax)
    anypic->height = height;
     7a0:	8b 45 08             	mov    0x8(%ebp),%eax
     7a3:	8b 55 10             	mov    0x10(%ebp),%edx
     7a6:	89 50 08             	mov    %edx,0x8(%eax)
}
     7a9:	c9                   	leave  
     7aa:	c3                   	ret    

000007ab <modifyPic>:

void modifyPic(Context context)//调整大小来适应背景
{
     7ab:	55                   	push   %ebp
     7ac:	89 e5                	mov    %esp,%ebp
     7ae:	83 ec 48             	sub    $0x48,%esp
    int c_width, c_height;
    int pic_width, pic_height;

    c_width = context.width;
     7b1:	8b 45 0c             	mov    0xc(%ebp),%eax
     7b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    c_height = context.height;
     7b7:	8b 45 10             	mov    0x10(%ebp),%eax
     7ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pic_width = pic.width;
     7bd:	a1 04 1a 01 00       	mov    0x11a04,%eax
     7c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pic_height = pic.height;
     7c5:	a1 08 1a 01 00       	mov    0x11a08,%eax
     7ca:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if (pic_width < c_width && pic_height < c_height) {//比背景小，不动
     7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7d3:	7d 0d                	jge    7e2 <modifyPic+0x37>
     7d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7d8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     7db:	7d 05                	jge    7e2 <modifyPic+0x37>
        return;
     7dd:	e9 b6 00 00 00       	jmp    898 <modifyPic+0xed>
    }

    float scale_p, scale_c;//宽高比
    scale_p = pic_width * 1.0 / pic_height;
     7e2:	db 45 f4             	fildl  -0xc(%ebp)
     7e5:	db 45 f0             	fildl  -0x10(%ebp)
     7e8:	de f9                	fdivrp %st,%st(1)
     7ea:	d9 5d e4             	fstps  -0x1c(%ebp)
    scale_c = c_width * 1.0 / c_height;
     7ed:	db 45 ec             	fildl  -0x14(%ebp)
     7f0:	db 45 e8             	fildl  -0x18(%ebp)
     7f3:	de f9                	fdivrp %st,%st(1)
     7f5:	d9 5d e0             	fstps  -0x20(%ebp)

    if (scale_p <= scale_c) {
     7f8:	d9 45 e0             	flds   -0x20(%ebp)
     7fb:	d9 45 e4             	flds   -0x1c(%ebp)
     7fe:	d9 c9                	fxch   %st(1)
     800:	df e9                	fucomip %st(1),%st
     802:	dd d8                	fstp   %st(0)
     804:	72 30                	jb     836 <modifyPic+0x8b>
        pic_width = scale_p * (c_height-10);
     806:	8b 45 e8             	mov    -0x18(%ebp),%eax
     809:	83 e8 0a             	sub    $0xa,%eax
     80c:	89 45 d0             	mov    %eax,-0x30(%ebp)
     80f:	db 45 d0             	fildl  -0x30(%ebp)
     812:	d8 4d e4             	fmuls  -0x1c(%ebp)
     815:	d9 7d ce             	fnstcw -0x32(%ebp)
     818:	0f b7 45 ce          	movzwl -0x32(%ebp),%eax
     81c:	b4 0c                	mov    $0xc,%ah
     81e:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
     822:	d9 6d cc             	fldcw  -0x34(%ebp)
     825:	db 5d f4             	fistpl -0xc(%ebp)
     828:	d9 6d ce             	fldcw  -0x32(%ebp)
        pic_height = c_height-10;
     82b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     82e:	83 e8 0a             	sub    $0xa,%eax
     831:	89 45 f0             	mov    %eax,-0x10(%ebp)
     834:	eb 2e                	jmp    864 <modifyPic+0xb9>
    } else {
        pic_height = (c_width-5) / scale_p;
     836:	8b 45 ec             	mov    -0x14(%ebp),%eax
     839:	83 e8 05             	sub    $0x5,%eax
     83c:	89 45 d0             	mov    %eax,-0x30(%ebp)
     83f:	db 45 d0             	fildl  -0x30(%ebp)
     842:	d8 75 e4             	fdivs  -0x1c(%ebp)
     845:	d9 7d ce             	fnstcw -0x32(%ebp)
     848:	0f b7 45 ce          	movzwl -0x32(%ebp),%eax
     84c:	b4 0c                	mov    $0xc,%ah
     84e:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
     852:	d9 6d cc             	fldcw  -0x34(%ebp)
     855:	db 5d f0             	fistpl -0x10(%ebp)
     858:	d9 6d ce             	fldcw  -0x32(%ebp)
        pic_width = c_width-5;
     85b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     85e:	83 e8 05             	sub    $0x5,%eax
     861:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    printf(0, "modifyPic: pic_width: %d, pic_height: %d\n", pic_width, pic_height);
     864:	8b 45 f0             	mov    -0x10(%ebp),%eax
     867:	89 44 24 0c          	mov    %eax,0xc(%esp)
     86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     86e:	89 44 24 08          	mov    %eax,0x8(%esp)
     872:	c7 44 24 04 c0 a9 00 	movl   $0xa9c0,0x4(%esp)
     879:	00 
     87a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     881:	e8 bc 3a 00 00       	call   4342 <printf>

    compressPic(pic_width, pic_height);
     886:	8b 45 f0             	mov    -0x10(%ebp),%eax
     889:	89 44 24 04          	mov    %eax,0x4(%esp)
     88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     890:	89 04 24             	mov    %eax,(%esp)
     893:	e8 96 f7 ff ff       	call   2e <compressPic>
}
     898:	c9                   	leave  
     899:	c3                   	ret    

0000089a <enlargePic>:

//放大图片
void enlargePic(Context context,int enlargeRate,int centerX, int centerY)
{
     89a:	55                   	push   %ebp
     89b:	89 e5                	mov    %esp,%ebp
     89d:	56                   	push   %esi
     89e:	53                   	push   %ebx
     89f:	83 ec 30             	sub    $0x30,%esp
    if(centerX<0 || centerY<0 || centerX>context.width || centerY>context.height)return;
     8a2:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
     8a6:	78 16                	js     8be <enlargePic+0x24>
     8a8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
     8ac:	78 10                	js     8be <enlargePic+0x24>
     8ae:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b1:	3b 45 18             	cmp    0x18(%ebp),%eax
     8b4:	7c 08                	jl     8be <enlargePic+0x24>
     8b6:	8b 45 10             	mov    0x10(%ebp),%eax
     8b9:	3b 45 1c             	cmp    0x1c(%ebp),%eax
     8bc:	7d 05                	jge    8c3 <enlargePic+0x29>
     8be:	e9 30 02 00 00       	jmp    af3 <enlargePic+0x259>
    int width = pic.width*enlargeRate;
     8c3:	a1 04 1a 01 00       	mov    0x11a04,%eax
     8c8:	0f af 45 14          	imul   0x14(%ebp),%eax
     8cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int height = pic.height*enlargeRate;
     8cf:	a1 08 1a 01 00       	mov    0x11a08,%eax
     8d4:	0f af 45 14          	imul   0x14(%ebp),%eax
     8d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    compressPic(width,height);
     8db:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8de:	89 44 24 04          	mov    %eax,0x4(%esp)
     8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8e5:	89 04 24             	mov    %eax,(%esp)
     8e8:	e8 41 f7 ff ff       	call   2e <compressPic>
    /*int centerConX = context.width/2.0;
    int centerConY = context.height/2.0;
    int moveX = centerConX - centerX;
    int moveY = centerConY - centerY;*/
    drawPicViewerWnd(context);
     8ed:	8b 45 08             	mov    0x8(%ebp),%eax
     8f0:	89 04 24             	mov    %eax,(%esp)
     8f3:	8b 45 0c             	mov    0xc(%ebp),%eax
     8f6:	89 44 24 04          	mov    %eax,0x4(%esp)
     8fa:	8b 45 10             	mov    0x10(%ebp),%eax
     8fd:	89 44 24 08          	mov    %eax,0x8(%esp)
     901:	e8 17 06 00 00       	call   f1d <drawPicViewerWnd>
    draw_picture(context, pic, ((context.width >> 1) - centerX)*enlargeRate + ((context.width-width/enlargeRate) >> 1)+X_shift*enlargeRate, 
TOPBAR_HEIGHT + (((context.height-TOPBAR_HEIGHT) >> 1) - (centerY-TOPBAR_HEIGHT))*enlargeRate + ((context.height-TOPBAR_HEIGHT-height/enlargeRate) >> 1)+Y_shift*enlargeRate);
     906:	8b 45 10             	mov    0x10(%ebp),%eax
     909:	83 e8 14             	sub    $0x14,%eax
     90c:	d1 f8                	sar    %eax
     90e:	89 c2                	mov    %eax,%edx
     910:	b8 14 00 00 00       	mov    $0x14,%eax
     915:	2b 45 1c             	sub    0x1c(%ebp),%eax
     918:	01 d0                	add    %edx,%eax
     91a:	0f af 45 14          	imul   0x14(%ebp),%eax
     91e:	8d 48 14             	lea    0x14(%eax),%ecx
     921:	8b 45 10             	mov    0x10(%ebp),%eax
     924:	8d 58 ec             	lea    -0x14(%eax),%ebx
     927:	8b 45 f0             	mov    -0x10(%ebp),%eax
     92a:	99                   	cltd   
     92b:	f7 7d 14             	idivl  0x14(%ebp)
     92e:	29 c3                	sub    %eax,%ebx
     930:	89 d8                	mov    %ebx,%eax
     932:	d1 f8                	sar    %eax
     934:	8d 14 01             	lea    (%ecx,%eax,1),%edx
     937:	a1 10 ec 00 00       	mov    0xec10,%eax
     93c:	0f af 45 14          	imul   0x14(%ebp),%eax
    /*int centerConX = context.width/2.0;
    int centerConY = context.height/2.0;
    int moveX = centerConX - centerX;
    int moveY = centerConY - centerY;*/
    drawPicViewerWnd(context);
    draw_picture(context, pic, ((context.width >> 1) - centerX)*enlargeRate + ((context.width-width/enlargeRate) >> 1)+X_shift*enlargeRate, 
     940:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
     943:	8b 45 0c             	mov    0xc(%ebp),%eax
     946:	d1 f8                	sar    %eax
     948:	2b 45 18             	sub    0x18(%ebp),%eax
     94b:	0f af 45 14          	imul   0x14(%ebp),%eax
     94f:	89 c3                	mov    %eax,%ebx
     951:	8b 75 0c             	mov    0xc(%ebp),%esi
     954:	8b 45 f4             	mov    -0xc(%ebp),%eax
     957:	99                   	cltd   
     958:	f7 7d 14             	idivl  0x14(%ebp)
     95b:	29 c6                	sub    %eax,%esi
     95d:	89 f0                	mov    %esi,%eax
     95f:	d1 f8                	sar    %eax
     961:	8d 14 03             	lea    (%ebx,%eax,1),%edx
     964:	a1 0c ec 00 00       	mov    0xec0c,%eax
     969:	0f af 45 14          	imul   0x14(%ebp),%eax
     96d:	01 d0                	add    %edx,%eax
     96f:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
     973:	89 44 24 18          	mov    %eax,0x18(%esp)
     977:	a1 00 1a 01 00       	mov    0x11a00,%eax
     97c:	89 44 24 0c          	mov    %eax,0xc(%esp)
     980:	a1 04 1a 01 00       	mov    0x11a04,%eax
     985:	89 44 24 10          	mov    %eax,0x10(%esp)
     989:	a1 08 1a 01 00       	mov    0x11a08,%eax
     98e:	89 44 24 14          	mov    %eax,0x14(%esp)
     992:	8b 45 08             	mov    0x8(%ebp),%eax
     995:	89 04 24             	mov    %eax,(%esp)
     998:	8b 45 0c             	mov    0xc(%ebp),%eax
     99b:	89 44 24 04          	mov    %eax,0x4(%esp)
     99f:	8b 45 10             	mov    0x10(%ebp),%eax
     9a2:	89 44 24 08          	mov    %eax,0x8(%esp)
     9a6:	e8 ad 20 00 00       	call   2a58 <draw_picture>
TOPBAR_HEIGHT + (((context.height-TOPBAR_HEIGHT) >> 1) - (centerY-TOPBAR_HEIGHT))*enlargeRate + ((context.height-TOPBAR_HEIGHT-height/enlargeRate) >> 1)+Y_shift*enlargeRate);
	startXsave = ((context.width >> 1) - centerX)*enlargeRate + ((context.width-width/enlargeRate) >> 1)+X_shift*enlargeRate;
     9ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     9ae:	d1 f8                	sar    %eax
     9b0:	2b 45 18             	sub    0x18(%ebp),%eax
     9b3:	0f af 45 14          	imul   0x14(%ebp),%eax
     9b7:	89 c1                	mov    %eax,%ecx
     9b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9bf:	99                   	cltd   
     9c0:	f7 7d 14             	idivl  0x14(%ebp)
     9c3:	29 c3                	sub    %eax,%ebx
     9c5:	89 d8                	mov    %ebx,%eax
     9c7:	d1 f8                	sar    %eax
     9c9:	8d 14 01             	lea    (%ecx,%eax,1),%edx
     9cc:	a1 0c ec 00 00       	mov    0xec0c,%eax
     9d1:	0f af 45 14          	imul   0x14(%ebp),%eax
     9d5:	01 d0                	add    %edx,%eax
     9d7:	a3 04 ec 00 00       	mov    %eax,0xec04
	startYsave = TOPBAR_HEIGHT + (((context.height-TOPBAR_HEIGHT) >> 1) - (centerY-TOPBAR_HEIGHT))*enlargeRate + ((context.height-TOPBAR_HEIGHT-height/enlargeRate) >> 1)+Y_shift*enlargeRate;
     9dc:	8b 45 10             	mov    0x10(%ebp),%eax
     9df:	83 e8 14             	sub    $0x14,%eax
     9e2:	d1 f8                	sar    %eax
     9e4:	89 c2                	mov    %eax,%edx
     9e6:	b8 14 00 00 00       	mov    $0x14,%eax
     9eb:	2b 45 1c             	sub    0x1c(%ebp),%eax
     9ee:	01 d0                	add    %edx,%eax
     9f0:	0f af 45 14          	imul   0x14(%ebp),%eax
     9f4:	8d 48 14             	lea    0x14(%eax),%ecx
     9f7:	8b 45 10             	mov    0x10(%ebp),%eax
     9fa:	8d 58 ec             	lea    -0x14(%eax),%ebx
     9fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a00:	99                   	cltd   
     a01:	f7 7d 14             	idivl  0x14(%ebp)
     a04:	29 c3                	sub    %eax,%ebx
     a06:	89 d8                	mov    %ebx,%eax
     a08:	d1 f8                	sar    %eax
     a0a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
     a0d:	a1 10 ec 00 00       	mov    0xec10,%eax
     a12:	0f af 45 14          	imul   0x14(%ebp),%eax
     a16:	01 d0                	add    %edx,%eax
     a18:	a3 08 ec 00 00       	mov    %eax,0xec08

	printf(0,"Enlarge: context_width: %d, context_height: %d\n", context.width, context.height);
     a1d:	8b 55 10             	mov    0x10(%ebp),%edx
     a20:	8b 45 0c             	mov    0xc(%ebp),%eax
     a23:	89 54 24 0c          	mov    %edx,0xc(%esp)
     a27:	89 44 24 08          	mov    %eax,0x8(%esp)
     a2b:	c7 44 24 04 ec a9 00 	movl   $0xa9ec,0x4(%esp)
     a32:	00 
     a33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a3a:	e8 03 39 00 00       	call   4342 <printf>
	printf(0,"Enlarge: width: %d, height: %d\n", width, height);
     a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a42:	89 44 24 0c          	mov    %eax,0xc(%esp)
     a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a49:	89 44 24 08          	mov    %eax,0x8(%esp)
     a4d:	c7 44 24 04 1c aa 00 	movl   $0xaa1c,0x4(%esp)
     a54:	00 
     a55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a5c:	e8 e1 38 00 00       	call   4342 <printf>
        printf(0,"Enlarge: centerX: %d, centerY: %d\n", centerX, centerY);
     a61:	8b 45 1c             	mov    0x1c(%ebp),%eax
     a64:	89 44 24 0c          	mov    %eax,0xc(%esp)
     a68:	8b 45 18             	mov    0x18(%ebp),%eax
     a6b:	89 44 24 08          	mov    %eax,0x8(%esp)
     a6f:	c7 44 24 04 3c aa 00 	movl   $0xaa3c,0x4(%esp)
     a76:	00 
     a77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a7e:	e8 bf 38 00 00       	call   4342 <printf>
 	updateWindowWithoutBlank(context);
     a83:	8b 45 08             	mov    0x8(%ebp),%eax
     a86:	89 04 24             	mov    %eax,(%esp)
     a89:	8b 45 0c             	mov    0xc(%ebp),%eax
     a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
     a90:	8b 45 10             	mov    0x10(%ebp),%eax
     a93:	89 44 24 08          	mov    %eax,0x8(%esp)
     a97:	e8 7b 07 00 00       	call   1217 <updateWindowWithoutBlank>
	X_shift *= ((context.width-width/enlargeRate) >> 1)+X_shift*enlargeRate;
     a9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aa2:	99                   	cltd   
     aa3:	f7 7d 14             	idivl  0x14(%ebp)
     aa6:	29 c1                	sub    %eax,%ecx
     aa8:	89 c8                	mov    %ecx,%eax
     aaa:	d1 f8                	sar    %eax
     aac:	89 c2                	mov    %eax,%edx
     aae:	a1 0c ec 00 00       	mov    0xec0c,%eax
     ab3:	0f af 45 14          	imul   0x14(%ebp),%eax
     ab7:	01 c2                	add    %eax,%edx
     ab9:	a1 0c ec 00 00       	mov    0xec0c,%eax
     abe:	0f af c2             	imul   %edx,%eax
     ac1:	a3 0c ec 00 00       	mov    %eax,0xec0c
    	Y_shift *= ((context.height-TOPBAR_HEIGHT-height/enlargeRate) >> 1)+Y_shift*enlargeRate;
     ac6:	8b 45 10             	mov    0x10(%ebp),%eax
     ac9:	8d 48 ec             	lea    -0x14(%eax),%ecx
     acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     acf:	99                   	cltd   
     ad0:	f7 7d 14             	idivl  0x14(%ebp)
     ad3:	29 c1                	sub    %eax,%ecx
     ad5:	89 c8                	mov    %ecx,%eax
     ad7:	d1 f8                	sar    %eax
     ad9:	89 c2                	mov    %eax,%edx
     adb:	a1 10 ec 00 00       	mov    0xec10,%eax
     ae0:	0f af 45 14          	imul   0x14(%ebp),%eax
     ae4:	01 c2                	add    %eax,%edx
     ae6:	a1 10 ec 00 00       	mov    0xec10,%eax
     aeb:	0f af c2             	imul   %edx,%eax
     aee:	a3 10 ec 00 00       	mov    %eax,0xec10
}
     af3:	83 c4 30             	add    $0x30,%esp
     af6:	5b                   	pop    %ebx
     af7:	5e                   	pop    %esi
     af8:	5d                   	pop    %ebp
     af9:	c3                   	ret    

00000afa <narrowPic>:

//缩小图片
void narrowPic(Context context,int narrowRate,int centerX, int centerY)
{
     afa:	55                   	push   %ebp
     afb:	89 e5                	mov    %esp,%ebp
     afd:	83 ec 48             	sub    $0x48,%esp
    int width = pic.width/(double)narrowRate;
     b00:	a1 04 1a 01 00       	mov    0x11a04,%eax
     b05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     b08:	db 45 e4             	fildl  -0x1c(%ebp)
     b0b:	db 45 14             	fildl  0x14(%ebp)
     b0e:	de f9                	fdivrp %st,%st(1)
     b10:	d9 7d e2             	fnstcw -0x1e(%ebp)
     b13:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
     b17:	b4 0c                	mov    $0xc,%ah
     b19:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
     b1d:	d9 6d e0             	fldcw  -0x20(%ebp)
     b20:	db 5d f4             	fistpl -0xc(%ebp)
     b23:	d9 6d e2             	fldcw  -0x1e(%ebp)
    int height = pic.height/(double)narrowRate;
     b26:	a1 08 1a 01 00       	mov    0x11a08,%eax
     b2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     b2e:	db 45 e4             	fildl  -0x1c(%ebp)
     b31:	db 45 14             	fildl  0x14(%ebp)
     b34:	de f9                	fdivrp %st,%st(1)
     b36:	d9 6d e0             	fldcw  -0x20(%ebp)
     b39:	db 5d f0             	fistpl -0x10(%ebp)
     b3c:	d9 6d e2             	fldcw  -0x1e(%ebp)
    compressPic(width,height);
     b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b42:	89 44 24 04          	mov    %eax,0x4(%esp)
     b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b49:	89 04 24             	mov    %eax,(%esp)
     b4c:	e8 dd f4 ff ff       	call   2e <compressPic>
    /*int centerConX = context.width/2.0;
    int centerConY = context.height/2.0;
    int moveX = centerConX - centerX;
    int moveY = centerConY - centerY;*/
    drawPicViewerWnd(context);
     b51:	8b 45 08             	mov    0x8(%ebp),%eax
     b54:	89 04 24             	mov    %eax,(%esp)
     b57:	8b 45 0c             	mov    0xc(%ebp),%eax
     b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
     b5e:	8b 45 10             	mov    0x10(%ebp),%eax
     b61:	89 44 24 08          	mov    %eax,0x8(%esp)
     b65:	e8 b3 03 00 00       	call   f1d <drawPicViewerWnd>
    draw_picture(context, pic, (context.width-width) >> 1, TOPBAR_HEIGHT + ((context.height-height) >> 1));
     b6a:	8b 45 10             	mov    0x10(%ebp),%eax
     b6d:	2b 45 f0             	sub    -0x10(%ebp),%eax
     b70:	d1 f8                	sar    %eax
     b72:	8d 50 14             	lea    0x14(%eax),%edx
     b75:	8b 45 0c             	mov    0xc(%ebp),%eax
     b78:	2b 45 f4             	sub    -0xc(%ebp),%eax
     b7b:	d1 f8                	sar    %eax
     b7d:	89 54 24 1c          	mov    %edx,0x1c(%esp)
     b81:	89 44 24 18          	mov    %eax,0x18(%esp)
     b85:	a1 00 1a 01 00       	mov    0x11a00,%eax
     b8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b8e:	a1 04 1a 01 00       	mov    0x11a04,%eax
     b93:	89 44 24 10          	mov    %eax,0x10(%esp)
     b97:	a1 08 1a 01 00       	mov    0x11a08,%eax
     b9c:	89 44 24 14          	mov    %eax,0x14(%esp)
     ba0:	8b 45 08             	mov    0x8(%ebp),%eax
     ba3:	89 04 24             	mov    %eax,(%esp)
     ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
     bad:	8b 45 10             	mov    0x10(%ebp),%eax
     bb0:	89 44 24 08          	mov    %eax,0x8(%esp)
     bb4:	e8 9f 1e 00 00       	call   2a58 <draw_picture>
    startXsave = (context.width-width) >> 1;
     bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
     bbc:	2b 45 f4             	sub    -0xc(%ebp),%eax
     bbf:	d1 f8                	sar    %eax
     bc1:	a3 04 ec 00 00       	mov    %eax,0xec04
    startYsave = TOPBAR_HEIGHT + ((context.height-height) >> 1);
     bc6:	8b 45 10             	mov    0x10(%ebp),%eax
     bc9:	2b 45 f0             	sub    -0x10(%ebp),%eax
     bcc:	d1 f8                	sar    %eax
     bce:	83 c0 14             	add    $0x14,%eax
     bd1:	a3 08 ec 00 00       	mov    %eax,0xec08
    X_shift = 0;
     bd6:	c7 05 0c ec 00 00 00 	movl   $0x0,0xec0c
     bdd:	00 00 00 
    Y_shift = 0;
     be0:	c7 05 10 ec 00 00 00 	movl   $0x0,0xec10
     be7:	00 00 00 
}
     bea:	c9                   	leave  
     beb:	c3                   	ret    

00000bec <zoomingPic>:

//图片放缩
void zoomingPic(Context context,int centerX, int centerY)
{
     bec:	55                   	push   %ebp
     bed:	89 e5                	mov    %esp,%ebp
     bef:	83 ec 38             	sub    $0x38,%esp
	
    if(centerX > context.width || centerY > context.height) return;
     bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
     bf5:	3b 45 14             	cmp    0x14(%ebp),%eax
     bf8:	7c 08                	jl     c02 <zoomingPic+0x16>
     bfa:	8b 45 10             	mov    0x10(%ebp),%eax
     bfd:	3b 45 18             	cmp    0x18(%ebp),%eax
     c00:	7d 05                	jge    c07 <zoomingPic+0x1b>
     c02:	e9 97 00 00 00       	jmp    c9e <zoomingPic+0xb2>
    int rate = 2;//待定等改
     c07:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
    switch(isZooming)
     c0e:	a1 fc e6 00 00       	mov    0xe6fc,%eax
     c13:	83 f8 01             	cmp    $0x1,%eax
     c16:	74 07                	je     c1f <zoomingPic+0x33>
     c18:	83 f8 02             	cmp    $0x2,%eax
     c1b:	74 3c                	je     c59 <zoomingPic+0x6d>
     c1d:	eb 74                	jmp    c93 <zoomingPic+0xa7>
    {
        case 1:
            enlargePic(context,rate,centerX,centerY);
     c1f:	8b 45 18             	mov    0x18(%ebp),%eax
     c22:	89 44 24 14          	mov    %eax,0x14(%esp)
     c26:	8b 45 14             	mov    0x14(%ebp),%eax
     c29:	89 44 24 10          	mov    %eax,0x10(%esp)
     c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c30:	89 44 24 0c          	mov    %eax,0xc(%esp)
     c34:	8b 45 08             	mov    0x8(%ebp),%eax
     c37:	89 04 24             	mov    %eax,(%esp)
     c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
     c41:	8b 45 10             	mov    0x10(%ebp),%eax
     c44:	89 44 24 08          	mov    %eax,0x8(%esp)
     c48:	e8 4d fc ff ff       	call   89a <enlargePic>
            isZooming = 2;
     c4d:	c7 05 fc e6 00 00 02 	movl   $0x2,0xe6fc
     c54:	00 00 00 
            break;
     c57:	eb 45                	jmp    c9e <zoomingPic+0xb2>
        case 2:
            narrowPic(context,rate,centerX,centerY);
     c59:	8b 45 18             	mov    0x18(%ebp),%eax
     c5c:	89 44 24 14          	mov    %eax,0x14(%esp)
     c60:	8b 45 14             	mov    0x14(%ebp),%eax
     c63:	89 44 24 10          	mov    %eax,0x10(%esp)
     c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
     c6e:	8b 45 08             	mov    0x8(%ebp),%eax
     c71:	89 04 24             	mov    %eax,(%esp)
     c74:	8b 45 0c             	mov    0xc(%ebp),%eax
     c77:	89 44 24 04          	mov    %eax,0x4(%esp)
     c7b:	8b 45 10             	mov    0x10(%ebp),%eax
     c7e:	89 44 24 08          	mov    %eax,0x8(%esp)
     c82:	e8 73 fe ff ff       	call   afa <narrowPic>
            isZooming = 1;
     c87:	c7 05 fc e6 00 00 01 	movl   $0x1,0xe6fc
     c8e:	00 00 00 
            break;
     c91:	eb 0b                	jmp    c9e <zoomingPic+0xb2>
        default:
            isZooming = 1;
     c93:	c7 05 fc e6 00 00 01 	movl   $0x1,0xe6fc
     c9a:	00 00 00 
            break;
     c9d:	90                   	nop
    }
} 
     c9e:	c9                   	leave  
     c9f:	c3                   	ret    

00000ca0 <rollingPic>:

//Picture Rolling
void rollingPic(Context context)
{
     ca0:	55                   	push   %ebp
     ca1:	89 e5                	mov    %esp,%ebp
     ca3:	53                   	push   %ebx
     ca4:	83 ec 34             	sub    $0x34,%esp
	RGBQUAD* cache = (RGBQUAD *) malloc(pic.width * pic.height * sizeof(RGBQUAD));
     ca7:	8b 15 04 1a 01 00    	mov    0x11a04,%edx
     cad:	a1 08 1a 01 00       	mov    0x11a08,%eax
     cb2:	0f af c2             	imul   %edx,%eax
     cb5:	c1 e0 02             	shl    $0x2,%eax
     cb8:	89 04 24             	mov    %eax,(%esp)
     cbb:	e8 6e 39 00 00       	call   462e <malloc>
     cc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int i,j;
	for (i = 0; i < pic.height; i++){
     cc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cca:	eb 60                	jmp    d2c <rollingPic+0x8c>
		for(j = 0; j < pic.width;j++){
     ccc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     cd3:	eb 49                	jmp    d1e <rollingPic+0x7e>
			cache[(pic.width - 1 - j)*pic.height + i] = pic.data[i*pic.width + j];
     cd5:	a1 04 1a 01 00       	mov    0x11a04,%eax
     cda:	83 e8 01             	sub    $0x1,%eax
     cdd:	2b 45 f0             	sub    -0x10(%ebp),%eax
     ce0:	89 c2                	mov    %eax,%edx
     ce2:	a1 08 1a 01 00       	mov    0x11a08,%eax
     ce7:	0f af d0             	imul   %eax,%edx
     cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ced:	01 d0                	add    %edx,%eax
     cef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cf9:	01 c2                	add    %eax,%edx
     cfb:	8b 0d 00 1a 01 00    	mov    0x11a00,%ecx
     d01:	a1 04 1a 01 00       	mov    0x11a04,%eax
     d06:	0f af 45 f4          	imul   -0xc(%ebp),%eax
     d0a:	89 c3                	mov    %eax,%ebx
     d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d0f:	01 d8                	add    %ebx,%eax
     d11:	c1 e0 02             	shl    $0x2,%eax
     d14:	01 c8                	add    %ecx,%eax
     d16:	8b 00                	mov    (%eax),%eax
     d18:	89 02                	mov    %eax,(%edx)
void rollingPic(Context context)
{
	RGBQUAD* cache = (RGBQUAD *) malloc(pic.width * pic.height * sizeof(RGBQUAD));
	int i,j;
	for (i = 0; i < pic.height; i++){
		for(j = 0; j < pic.width;j++){
     d1a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     d1e:	a1 04 1a 01 00       	mov    0x11a04,%eax
     d23:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     d26:	7f ad                	jg     cd5 <rollingPic+0x35>
//Picture Rolling
void rollingPic(Context context)
{
	RGBQUAD* cache = (RGBQUAD *) malloc(pic.width * pic.height * sizeof(RGBQUAD));
	int i,j;
	for (i = 0; i < pic.height; i++){
     d28:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d2c:	a1 08 1a 01 00       	mov    0x11a08,%eax
     d31:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     d34:	7f 96                	jg     ccc <rollingPic+0x2c>
		for(j = 0; j < pic.width;j++){
			cache[(pic.width - 1 - j)*pic.height + i] = pic.data[i*pic.width + j];
		}	
	}
	free(pic.data);
     d36:	a1 00 1a 01 00       	mov    0x11a00,%eax
     d3b:	89 04 24             	mov    %eax,(%esp)
     d3e:	e8 b2 37 00 00       	call   44f5 <free>
	i = pic.width;
     d43:	a1 04 1a 01 00       	mov    0x11a04,%eax
     d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	pic.width = pic.height;
     d4b:	a1 08 1a 01 00       	mov    0x11a08,%eax
     d50:	a3 04 1a 01 00       	mov    %eax,0x11a04
	pic.height = i;
     d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d58:	a3 08 1a 01 00       	mov    %eax,0x11a08
	pic.data = cache;	
     d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d60:	a3 00 1a 01 00       	mov    %eax,0x11a00
	drawPicViewerWnd(context);
     d65:	8b 45 08             	mov    0x8(%ebp),%eax
     d68:	89 04 24             	mov    %eax,(%esp)
     d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
     d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
     d72:	8b 45 10             	mov    0x10(%ebp),%eax
     d75:	89 44 24 08          	mov    %eax,0x8(%esp)
     d79:	e8 9f 01 00 00       	call   f1d <drawPicViewerWnd>
    	draw_picture(context, pic, (context.width-pic.width) >> 1, TOPBAR_HEIGHT + ((context.height-pic.height) >> 1));
     d7e:	8b 55 10             	mov    0x10(%ebp),%edx
     d81:	a1 08 1a 01 00       	mov    0x11a08,%eax
     d86:	29 c2                	sub    %eax,%edx
     d88:	89 d0                	mov    %edx,%eax
     d8a:	d1 f8                	sar    %eax
     d8c:	8d 50 14             	lea    0x14(%eax),%edx
     d8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     d92:	a1 04 1a 01 00       	mov    0x11a04,%eax
     d97:	29 c1                	sub    %eax,%ecx
     d99:	89 c8                	mov    %ecx,%eax
     d9b:	d1 f8                	sar    %eax
     d9d:	89 54 24 1c          	mov    %edx,0x1c(%esp)
     da1:	89 44 24 18          	mov    %eax,0x18(%esp)
     da5:	a1 00 1a 01 00       	mov    0x11a00,%eax
     daa:	89 44 24 0c          	mov    %eax,0xc(%esp)
     dae:	a1 04 1a 01 00       	mov    0x11a04,%eax
     db3:	89 44 24 10          	mov    %eax,0x10(%esp)
     db7:	a1 08 1a 01 00       	mov    0x11a08,%eax
     dbc:	89 44 24 14          	mov    %eax,0x14(%esp)
     dc0:	8b 45 08             	mov    0x8(%ebp),%eax
     dc3:	89 04 24             	mov    %eax,(%esp)
     dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
     dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
     dcd:	8b 45 10             	mov    0x10(%ebp),%eax
     dd0:	89 44 24 08          	mov    %eax,0x8(%esp)
     dd4:	e8 7f 1c 00 00       	call   2a58 <draw_picture>
	startXsave = (context.width-pic.width) >> 1;
     dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
     ddc:	a1 04 1a 01 00       	mov    0x11a04,%eax
     de1:	29 c2                	sub    %eax,%edx
     de3:	89 d0                	mov    %edx,%eax
     de5:	d1 f8                	sar    %eax
     de7:	a3 04 ec 00 00       	mov    %eax,0xec04
        startYsave = TOPBAR_HEIGHT + ((context.height-pic.height) >> 1);
     dec:	8b 55 10             	mov    0x10(%ebp),%edx
     def:	a1 08 1a 01 00       	mov    0x11a08,%eax
     df4:	29 c2                	sub    %eax,%edx
     df6:	89 d0                	mov    %edx,%eax
     df8:	d1 f8                	sar    %eax
     dfa:	83 c0 14             	add    $0x14,%eax
     dfd:	a3 08 ec 00 00       	mov    %eax,0xec08
	updateWindowWithoutBlank(context);
     e02:	8b 45 08             	mov    0x8(%ebp),%eax
     e05:	89 04 24             	mov    %eax,(%esp)
     e08:	8b 45 0c             	mov    0xc(%ebp),%eax
     e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
     e0f:	8b 45 10             	mov    0x10(%ebp),%eax
     e12:	89 44 24 08          	mov    %eax,0x8(%esp)
     e16:	e8 fc 03 00 00       	call   1217 <updateWindowWithoutBlank>
	
}
     e1b:	83 c4 34             	add    $0x34,%esp
     e1e:	5b                   	pop    %ebx
     e1f:	5d                   	pop    %ebp
     e20:	c3                   	ret    

00000e21 <nextPic>:

//Picture next
void nextPic(Context context)
{
     e21:	55                   	push   %ebp
     e22:	89 e5                	mov    %esp,%ebp
     e24:	83 ec 18             	sub    $0x18,%esp
	X_shift = 0;
     e27:	c7 05 0c ec 00 00 00 	movl   $0x0,0xec0c
     e2e:	00 00 00 
	Y_shift = 0;
     e31:	c7 05 10 ec 00 00 00 	movl   $0x0,0xec10
     e38:	00 00 00 
	isZooming = 1;
     e3b:	c7 05 fc e6 00 00 01 	movl   $0x1,0xe6fc
     e42:	00 00 00 
	pos = (pos+1) % len;	
     e45:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
     e4a:	83 c0 01             	add    $0x1,%eax
     e4d:	8b 0d b0 1b 01 00    	mov    0x11bb0,%ecx
     e53:	99                   	cltd   
     e54:	f7 f9                	idiv   %ecx
     e56:	89 d0                	mov    %edx,%eax
     e58:	a3 0c 1a 01 00       	mov    %eax,0x11a0c
	if(pos==0)pos++;
     e5d:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
     e62:	85 c0                	test   %eax,%eax
     e64:	75 0d                	jne    e73 <nextPic+0x52>
     e66:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
     e6b:	83 c0 01             	add    $0x1,%eax
     e6e:	a3 0c 1a 01 00       	mov    %eax,0x11a0c
	printf(0,"%d\n",pos);
     e73:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
     e78:	89 44 24 08          	mov    %eax,0x8(%esp)
     e7c:	c7 44 24 04 5f aa 00 	movl   $0xaa5f,0x4(%esp)
     e83:	00 
     e84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e8b:	e8 b2 34 00 00       	call   4342 <printf>
	loadBitmap(&pic, file[pos]);
     e90:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
     e95:	8b 04 85 20 1a 01 00 	mov    0x11a20(,%eax,4),%eax
     e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
     ea0:	c7 04 24 00 1a 01 00 	movl   $0x11a00,(%esp)
     ea7:	e8 dc 20 00 00       	call   2f88 <loadBitmap>
	drawPicViewerWnd(context);
     eac:	8b 45 08             	mov    0x8(%ebp),%eax
     eaf:	89 04 24             	mov    %eax,(%esp)
     eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb5:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb9:	8b 45 10             	mov    0x10(%ebp),%eax
     ebc:	89 44 24 08          	mov    %eax,0x8(%esp)
     ec0:	e8 58 00 00 00       	call   f1d <drawPicViewerWnd>
	drawPicViewerContent(context, file[pos]);
     ec5:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
     eca:	8b 04 85 20 1a 01 00 	mov    0x11a20(,%eax,4),%eax
     ed1:	89 44 24 0c          	mov    %eax,0xc(%esp)
     ed5:	8b 45 08             	mov    0x8(%ebp),%eax
     ed8:	89 04 24             	mov    %eax,(%esp)
     edb:	8b 45 0c             	mov    0xc(%ebp),%eax
     ede:	89 44 24 04          	mov    %eax,0x4(%esp)
     ee2:	8b 45 10             	mov    0x10(%ebp),%eax
     ee5:	89 44 24 08          	mov    %eax,0x8(%esp)
     ee9:	e8 0b 06 00 00       	call   14f9 <drawPicViewerContent>
	updateWindowWithoutBlank(context);
     eee:	8b 45 08             	mov    0x8(%ebp),%eax
     ef1:	89 04 24             	mov    %eax,(%esp)
     ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
     ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
     efb:	8b 45 10             	mov    0x10(%ebp),%eax
     efe:	89 44 24 08          	mov    %eax,0x8(%esp)
     f02:	e8 10 03 00 00       	call   1217 <updateWindowWithoutBlank>
	


	printf(0,"NEXT!\n");
     f07:	c7 44 24 04 63 aa 00 	movl   $0xaa63,0x4(%esp)
     f0e:	00 
     f0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     f16:	e8 27 34 00 00       	call   4342 <printf>
	
}
     f1b:	c9                   	leave  
     f1c:	c3                   	ret    

00000f1d <drawPicViewerWnd>:


// 绘制窗口
void drawPicViewerWnd(Context context) {
     f1d:	55                   	push   %ebp
     f1e:	89 e5                	mov    %esp,%ebp
     f20:	83 ec 48             	sub    $0x48,%esp
    int width, height;

    width = context.width;
     f23:	8b 45 0c             	mov    0xc(%ebp),%eax
     f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    height = context.height;
     f29:	8b 45 10             	mov    0x10(%ebp),%eax
     f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)

    fill_rect(context, 0, 0, width, height, 0xFFFF);
     f2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
     f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f35:	c7 44 24 1c ff ff 00 	movl   $0xffff,0x1c(%esp)
     f3c:	00 
     f3d:	89 54 24 18          	mov    %edx,0x18(%esp)
     f41:	89 44 24 14          	mov    %eax,0x14(%esp)
     f45:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     f4c:	00 
     f4d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     f54:	00 
     f55:	8b 45 08             	mov    0x8(%ebp),%eax
     f58:	89 04 24             	mov    %eax,(%esp)
     f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f5e:	89 44 24 04          	mov    %eax,0x4(%esp)
     f62:	8b 45 10             	mov    0x10(%ebp),%eax
     f65:	89 44 24 08          	mov    %eax,0x8(%esp)
     f69:	e8 4b 14 00 00       	call   23b9 <fill_rect>

    draw_line(context, 0, 0, width-1, 0, BORDERLINE_COLOR);
     f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f71:	83 e8 01             	sub    $0x1,%eax
     f74:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     f7b:	00 
     f7c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
     f83:	00 
     f84:	89 44 24 14          	mov    %eax,0x14(%esp)
     f88:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     f8f:	00 
     f90:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     f97:	00 
     f98:	8b 45 08             	mov    0x8(%ebp),%eax
     f9b:	89 04 24             	mov    %eax,(%esp)
     f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
     fa1:	89 44 24 04          	mov    %eax,0x4(%esp)
     fa5:	8b 45 10             	mov    0x10(%ebp),%eax
     fa8:	89 44 24 08          	mov    %eax,0x8(%esp)
     fac:	e8 7d 1b 00 00       	call   2b2e <draw_line>
    draw_line(context, width-1, 0, width-1, height-1, BORDERLINE_COLOR);
     fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fb4:	8d 48 ff             	lea    -0x1(%eax),%ecx
     fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fba:	8d 50 ff             	lea    -0x1(%eax),%edx
     fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc0:	83 e8 01             	sub    $0x1,%eax
     fc3:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     fca:	00 
     fcb:	89 4c 24 18          	mov    %ecx,0x18(%esp)
     fcf:	89 54 24 14          	mov    %edx,0x14(%esp)
     fd3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     fda:	00 
     fdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
     fdf:	8b 45 08             	mov    0x8(%ebp),%eax
     fe2:	89 04 24             	mov    %eax,(%esp)
     fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
     fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
     fec:	8b 45 10             	mov    0x10(%ebp),%eax
     fef:	89 44 24 08          	mov    %eax,0x8(%esp)
     ff3:	e8 36 1b 00 00       	call   2b2e <draw_line>
    draw_line(context, 0, height-1, width-1, height-1, BORDERLINE_COLOR);
     ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ffb:	8d 48 ff             	lea    -0x1(%eax),%ecx
     ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1001:	8d 50 ff             	lea    -0x1(%eax),%edx
    1004:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1007:	83 e8 01             	sub    $0x1,%eax
    100a:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    1011:	00 
    1012:	89 4c 24 18          	mov    %ecx,0x18(%esp)
    1016:	89 54 24 14          	mov    %edx,0x14(%esp)
    101a:	89 44 24 10          	mov    %eax,0x10(%esp)
    101e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1025:	00 
    1026:	8b 45 08             	mov    0x8(%ebp),%eax
    1029:	89 04 24             	mov    %eax,(%esp)
    102c:	8b 45 0c             	mov    0xc(%ebp),%eax
    102f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1033:	8b 45 10             	mov    0x10(%ebp),%eax
    1036:	89 44 24 08          	mov    %eax,0x8(%esp)
    103a:	e8 ef 1a 00 00       	call   2b2e <draw_line>
    draw_line(context, 0, height-1, 0, 0, BORDERLINE_COLOR);
    103f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1042:	83 e8 01             	sub    $0x1,%eax
    1045:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    104c:	00 
    104d:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
    1054:	00 
    1055:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
    105c:	00 
    105d:	89 44 24 10          	mov    %eax,0x10(%esp)
    1061:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1068:	00 
    1069:	8b 45 08             	mov    0x8(%ebp),%eax
    106c:	89 04 24             	mov    %eax,(%esp)
    106f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1072:	89 44 24 04          	mov    %eax,0x4(%esp)
    1076:	8b 45 10             	mov    0x10(%ebp),%eax
    1079:	89 44 24 08          	mov    %eax,0x8(%esp)
    107d:	e8 ac 1a 00 00       	call   2b2e <draw_line>

    fill_rect(context, 1, 1, width-2, TOPBAR_HEIGHT, TOPBAR_COLOR);
    1082:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1085:	83 e8 02             	sub    $0x2,%eax
    1088:	c7 44 24 1c cb 5a 00 	movl   $0x5acb,0x1c(%esp)
    108f:	00 
    1090:	c7 44 24 18 14 00 00 	movl   $0x14,0x18(%esp)
    1097:	00 
    1098:	89 44 24 14          	mov    %eax,0x14(%esp)
    109c:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
    10a3:	00 
    10a4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    10ab:	00 
    10ac:	8b 45 08             	mov    0x8(%ebp),%eax
    10af:	89 04 24             	mov    %eax,(%esp)
    10b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b5:	89 44 24 04          	mov    %eax,0x4(%esp)
    10b9:	8b 45 10             	mov    0x10(%ebp),%eax
    10bc:	89 44 24 08          	mov    %eax,0x8(%esp)
    10c0:	e8 f4 12 00 00       	call   23b9 <fill_rect>
    puts_str(context, "PictureViewer", 0, WINDOW_WIDTH/2 - 53, 3);
    10c5:	c7 44 24 18 03 00 00 	movl   $0x3,0x18(%esp)
    10cc:	00 
    10cd:	c7 44 24 14 c5 00 00 	movl   $0xc5,0x14(%esp)
    10d4:	00 
    10d5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    10dc:	00 
    10dd:	c7 44 24 0c 6a aa 00 	movl   $0xaa6a,0xc(%esp)
    10e4:	00 
    10e5:	8b 45 08             	mov    0x8(%ebp),%eax
    10e8:	89 04 24             	mov    %eax,(%esp)
    10eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ee:	89 44 24 04          	mov    %eax,0x4(%esp)
    10f2:	8b 45 10             	mov    0x10(%ebp),%eax
    10f5:	89 44 24 08          	mov    %eax,0x8(%esp)
    10f9:	e8 9a 18 00 00       	call   2998 <puts_str>

    draw_iconlist(context, wndRes, sizeof(wndRes) / sizeof(ICON));
    10fe:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
    1105:	00 
    1106:	c7 44 24 0c c0 e6 00 	movl   $0xe6c0,0xc(%esp)
    110d:	00 
    110e:	8b 45 08             	mov    0x8(%ebp),%eax
    1111:	89 04 24             	mov    %eax,(%esp)
    1114:	8b 45 0c             	mov    0xc(%ebp),%eax
    1117:	89 44 24 04          	mov    %eax,0x4(%esp)
    111b:	8b 45 10             	mov    0x10(%ebp),%eax
    111e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1122:	e8 e2 1d 00 00       	call   2f09 <draw_iconlist>
    PICNODE rolling;
    loadBitmap(&rolling, "rolling.bmp");
    1127:	c7 44 24 04 78 aa 00 	movl   $0xaa78,0x4(%esp)
    112e:	00 
    112f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1132:	89 04 24             	mov    %eax,(%esp)
    1135:	e8 4e 1e 00 00       	call   2f88 <loadBitmap>
    compressAnyPic(&rolling,16,16);
    113a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1141:	00 
    1142:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
    1149:	00 
    114a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    114d:	89 04 24             	mov    %eax,(%esp)
    1150:	e8 98 f2 ff ff       	call   3ed <compressAnyPic>
    draw_picture(context, rolling, 40, 3);
    1155:	c7 44 24 1c 03 00 00 	movl   $0x3,0x1c(%esp)
    115c:	00 
    115d:	c7 44 24 18 28 00 00 	movl   $0x28,0x18(%esp)
    1164:	00 
    1165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1168:	89 44 24 0c          	mov    %eax,0xc(%esp)
    116c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    116f:	89 44 24 10          	mov    %eax,0x10(%esp)
    1173:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1176:	89 44 24 14          	mov    %eax,0x14(%esp)
    117a:	8b 45 08             	mov    0x8(%ebp),%eax
    117d:	89 04 24             	mov    %eax,(%esp)
    1180:	8b 45 0c             	mov    0xc(%ebp),%eax
    1183:	89 44 24 04          	mov    %eax,0x4(%esp)
    1187:	8b 45 10             	mov    0x10(%ebp),%eax
    118a:	89 44 24 08          	mov    %eax,0x8(%esp)
    118e:	e8 c5 18 00 00       	call   2a58 <draw_picture>
    freepic(&rolling);
    1193:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1196:	89 04 24             	mov    %eax,(%esp)
    1199:	e8 96 23 00 00       	call   3534 <freepic>

    PICNODE next;
    loadBitmap(&next, "next.bmp");
    119e:	c7 44 24 04 84 aa 00 	movl   $0xaa84,0x4(%esp)
    11a5:	00 
    11a6:	8d 45 d8             	lea    -0x28(%ebp),%eax
    11a9:	89 04 24             	mov    %eax,(%esp)
    11ac:	e8 d7 1d 00 00       	call   2f88 <loadBitmap>
    compressAnyPic(&next,16,16);
    11b1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    11b8:	00 
    11b9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
    11c0:	00 
    11c1:	8d 45 d8             	lea    -0x28(%ebp),%eax
    11c4:	89 04 24             	mov    %eax,(%esp)
    11c7:	e8 21 f2 ff ff       	call   3ed <compressAnyPic>
    draw_picture(context, next, 60, 3);
    11cc:	c7 44 24 1c 03 00 00 	movl   $0x3,0x1c(%esp)
    11d3:	00 
    11d4:	c7 44 24 18 3c 00 00 	movl   $0x3c,0x18(%esp)
    11db:	00 
    11dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
    11df:	89 44 24 0c          	mov    %eax,0xc(%esp)
    11e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
    11e6:	89 44 24 10          	mov    %eax,0x10(%esp)
    11ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11ed:	89 44 24 14          	mov    %eax,0x14(%esp)
    11f1:	8b 45 08             	mov    0x8(%ebp),%eax
    11f4:	89 04 24             	mov    %eax,(%esp)
    11f7:	8b 45 0c             	mov    0xc(%ebp),%eax
    11fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    11fe:	8b 45 10             	mov    0x10(%ebp),%eax
    1201:	89 44 24 08          	mov    %eax,0x8(%esp)
    1205:	e8 4e 18 00 00       	call   2a58 <draw_picture>
    freepic(&next);
    120a:	8d 45 d8             	lea    -0x28(%ebp),%eax
    120d:	89 04 24             	mov    %eax,(%esp)
    1210:	e8 1f 23 00 00       	call   3534 <freepic>
}
    1215:	c9                   	leave  
    1216:	c3                   	ret    

00001217 <updateWindowWithoutBlank>:

//Update Something
void updateWindowWithoutBlank(Context context)
{
    1217:	55                   	push   %ebp
    1218:	89 e5                	mov    %esp,%ebp
    121a:	83 ec 58             	sub    $0x58,%esp
	PICNODE picCha;
  	draw_line(context, 0, 0, context.width - 1, 0, BORDERLINE_COLOR);
    121d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1220:	83 e8 01             	sub    $0x1,%eax
    1223:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    122a:	00 
    122b:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
    1232:	00 
    1233:	89 44 24 14          	mov    %eax,0x14(%esp)
    1237:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    123e:	00 
    123f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1246:	00 
    1247:	8b 45 08             	mov    0x8(%ebp),%eax
    124a:	89 04 24             	mov    %eax,(%esp)
    124d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1250:	89 44 24 04          	mov    %eax,0x4(%esp)
    1254:	8b 45 10             	mov    0x10(%ebp),%eax
    1257:	89 44 24 08          	mov    %eax,0x8(%esp)
    125b:	e8 ce 18 00 00       	call   2b2e <draw_line>
  	draw_line(context, context.width - 1, 0, context.width - 1, context.height - 1, BORDERLINE_COLOR);
    1260:	8b 45 10             	mov    0x10(%ebp),%eax
    1263:	8d 48 ff             	lea    -0x1(%eax),%ecx
    1266:	8b 45 0c             	mov    0xc(%ebp),%eax
    1269:	8d 50 ff             	lea    -0x1(%eax),%edx
    126c:	8b 45 0c             	mov    0xc(%ebp),%eax
    126f:	83 e8 01             	sub    $0x1,%eax
    1272:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    1279:	00 
    127a:	89 4c 24 18          	mov    %ecx,0x18(%esp)
    127e:	89 54 24 14          	mov    %edx,0x14(%esp)
    1282:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    1289:	00 
    128a:	89 44 24 0c          	mov    %eax,0xc(%esp)
    128e:	8b 45 08             	mov    0x8(%ebp),%eax
    1291:	89 04 24             	mov    %eax,(%esp)
    1294:	8b 45 0c             	mov    0xc(%ebp),%eax
    1297:	89 44 24 04          	mov    %eax,0x4(%esp)
    129b:	8b 45 10             	mov    0x10(%ebp),%eax
    129e:	89 44 24 08          	mov    %eax,0x8(%esp)
    12a2:	e8 87 18 00 00       	call   2b2e <draw_line>
  	draw_line(context, context.width - 1, context.height - 1, 0, context.height - 1, BORDERLINE_COLOR);
    12a7:	8b 45 10             	mov    0x10(%ebp),%eax
    12aa:	8d 48 ff             	lea    -0x1(%eax),%ecx
    12ad:	8b 45 10             	mov    0x10(%ebp),%eax
    12b0:	8d 50 ff             	lea    -0x1(%eax),%edx
    12b3:	8b 45 0c             	mov    0xc(%ebp),%eax
    12b6:	83 e8 01             	sub    $0x1,%eax
    12b9:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    12c0:	00 
    12c1:	89 4c 24 18          	mov    %ecx,0x18(%esp)
    12c5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
    12cc:	00 
    12cd:	89 54 24 10          	mov    %edx,0x10(%esp)
    12d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
    12d5:	8b 45 08             	mov    0x8(%ebp),%eax
    12d8:	89 04 24             	mov    %eax,(%esp)
    12db:	8b 45 0c             	mov    0xc(%ebp),%eax
    12de:	89 44 24 04          	mov    %eax,0x4(%esp)
    12e2:	8b 45 10             	mov    0x10(%ebp),%eax
    12e5:	89 44 24 08          	mov    %eax,0x8(%esp)
    12e9:	e8 40 18 00 00       	call   2b2e <draw_line>
  	draw_line(context, 0, context.height - 1, 0, 0, BORDERLINE_COLOR);
    12ee:	8b 45 10             	mov    0x10(%ebp),%eax
    12f1:	83 e8 01             	sub    $0x1,%eax
    12f4:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    12fb:	00 
    12fc:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
    1303:	00 
    1304:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
    130b:	00 
    130c:	89 44 24 10          	mov    %eax,0x10(%esp)
    1310:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1317:	00 
    1318:	8b 45 08             	mov    0x8(%ebp),%eax
    131b:	89 04 24             	mov    %eax,(%esp)
    131e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1321:	89 44 24 04          	mov    %eax,0x4(%esp)
    1325:	8b 45 10             	mov    0x10(%ebp),%eax
    1328:	89 44 24 08          	mov    %eax,0x8(%esp)
    132c:	e8 fd 17 00 00       	call   2b2e <draw_line>
  	fill_rect(context, 1, 1, context.width - 2, BOTTOMBAR_HEIGHT, TOPBAR_COLOR);
    1331:	8b 45 0c             	mov    0xc(%ebp),%eax
    1334:	83 e8 02             	sub    $0x2,%eax
    1337:	c7 44 24 1c cb 5a 00 	movl   $0x5acb,0x1c(%esp)
    133e:	00 
    133f:	c7 44 24 18 14 00 00 	movl   $0x14,0x18(%esp)
    1346:	00 
    1347:	89 44 24 14          	mov    %eax,0x14(%esp)
    134b:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
    1352:	00 
    1353:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    135a:	00 
    135b:	8b 45 08             	mov    0x8(%ebp),%eax
    135e:	89 04 24             	mov    %eax,(%esp)
    1361:	8b 45 0c             	mov    0xc(%ebp),%eax
    1364:	89 44 24 04          	mov    %eax,0x4(%esp)
    1368:	8b 45 10             	mov    0x10(%ebp),%eax
    136b:	89 44 24 08          	mov    %eax,0x8(%esp)
    136f:	e8 45 10 00 00       	call   23b9 <fill_rect>
  	loadBitmap(&picCha, "close.bmp");
    1374:	c7 44 24 04 8d aa 00 	movl   $0xaa8d,0x4(%esp)
    137b:	00 
    137c:	8d 45 ec             	lea    -0x14(%ebp),%eax
    137f:	89 04 24             	mov    %eax,(%esp)
    1382:	e8 01 1c 00 00       	call   2f88 <loadBitmap>
  	draw_picture(context, picCha, 3, 3);
    1387:	c7 44 24 1c 03 00 00 	movl   $0x3,0x1c(%esp)
    138e:	00 
    138f:	c7 44 24 18 03 00 00 	movl   $0x3,0x18(%esp)
    1396:	00 
    1397:	8b 45 ec             	mov    -0x14(%ebp),%eax
    139a:	89 44 24 0c          	mov    %eax,0xc(%esp)
    139e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13a1:	89 44 24 10          	mov    %eax,0x10(%esp)
    13a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a8:	89 44 24 14          	mov    %eax,0x14(%esp)
    13ac:	8b 45 08             	mov    0x8(%ebp),%eax
    13af:	89 04 24             	mov    %eax,(%esp)
    13b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    13b5:	89 44 24 04          	mov    %eax,0x4(%esp)
    13b9:	8b 45 10             	mov    0x10(%ebp),%eax
    13bc:	89 44 24 08          	mov    %eax,0x8(%esp)
    13c0:	e8 93 16 00 00       	call   2a58 <draw_picture>
  	puts_str(context, "PictureViewer", 0, WINDOW_WIDTH/2 - 53, 3);
    13c5:	c7 44 24 18 03 00 00 	movl   $0x3,0x18(%esp)
    13cc:	00 
    13cd:	c7 44 24 14 c5 00 00 	movl   $0xc5,0x14(%esp)
    13d4:	00 
    13d5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    13dc:	00 
    13dd:	c7 44 24 0c 6a aa 00 	movl   $0xaa6a,0xc(%esp)
    13e4:	00 
    13e5:	8b 45 08             	mov    0x8(%ebp),%eax
    13e8:	89 04 24             	mov    %eax,(%esp)
    13eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ee:	89 44 24 04          	mov    %eax,0x4(%esp)
    13f2:	8b 45 10             	mov    0x10(%ebp),%eax
    13f5:	89 44 24 08          	mov    %eax,0x8(%esp)
    13f9:	e8 9a 15 00 00       	call   2998 <puts_str>
  	freepic(&picCha);
    13fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
    1401:	89 04 24             	mov    %eax,(%esp)
    1404:	e8 2b 21 00 00       	call   3534 <freepic>
	PICNODE rolling;
    	loadBitmap(&rolling, "rolling.bmp");
    1409:	c7 44 24 04 78 aa 00 	movl   $0xaa78,0x4(%esp)
    1410:	00 
    1411:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1414:	89 04 24             	mov    %eax,(%esp)
    1417:	e8 6c 1b 00 00       	call   2f88 <loadBitmap>
    	compressAnyPic(&rolling,16,16);
    141c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1423:	00 
    1424:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
    142b:	00 
    142c:	8d 45 e0             	lea    -0x20(%ebp),%eax
    142f:	89 04 24             	mov    %eax,(%esp)
    1432:	e8 b6 ef ff ff       	call   3ed <compressAnyPic>
    	draw_picture(context, rolling, 40, 3);
    1437:	c7 44 24 1c 03 00 00 	movl   $0x3,0x1c(%esp)
    143e:	00 
    143f:	c7 44 24 18 28 00 00 	movl   $0x28,0x18(%esp)
    1446:	00 
    1447:	8b 45 e0             	mov    -0x20(%ebp),%eax
    144a:	89 44 24 0c          	mov    %eax,0xc(%esp)
    144e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1451:	89 44 24 10          	mov    %eax,0x10(%esp)
    1455:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1458:	89 44 24 14          	mov    %eax,0x14(%esp)
    145c:	8b 45 08             	mov    0x8(%ebp),%eax
    145f:	89 04 24             	mov    %eax,(%esp)
    1462:	8b 45 0c             	mov    0xc(%ebp),%eax
    1465:	89 44 24 04          	mov    %eax,0x4(%esp)
    1469:	8b 45 10             	mov    0x10(%ebp),%eax
    146c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1470:	e8 e3 15 00 00       	call   2a58 <draw_picture>
    	freepic(&rolling);
    1475:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1478:	89 04 24             	mov    %eax,(%esp)
    147b:	e8 b4 20 00 00       	call   3534 <freepic>

	PICNODE next;
        loadBitmap(&next, "next.bmp");
    1480:	c7 44 24 04 84 aa 00 	movl   $0xaa84,0x4(%esp)
    1487:	00 
    1488:	8d 45 d4             	lea    -0x2c(%ebp),%eax
    148b:	89 04 24             	mov    %eax,(%esp)
    148e:	e8 f5 1a 00 00       	call   2f88 <loadBitmap>
        compressAnyPic(&next,16,16);
    1493:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    149a:	00 
    149b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
    14a2:	00 
    14a3:	8d 45 d4             	lea    -0x2c(%ebp),%eax
    14a6:	89 04 24             	mov    %eax,(%esp)
    14a9:	e8 3f ef ff ff       	call   3ed <compressAnyPic>
        draw_picture(context, next, 60, 3);
    14ae:	c7 44 24 1c 03 00 00 	movl   $0x3,0x1c(%esp)
    14b5:	00 
    14b6:	c7 44 24 18 3c 00 00 	movl   $0x3c,0x18(%esp)
    14bd:	00 
    14be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    14c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
    14c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
    14c8:	89 44 24 10          	mov    %eax,0x10(%esp)
    14cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
    14cf:	89 44 24 14          	mov    %eax,0x14(%esp)
    14d3:	8b 45 08             	mov    0x8(%ebp),%eax
    14d6:	89 04 24             	mov    %eax,(%esp)
    14d9:	8b 45 0c             	mov    0xc(%ebp),%eax
    14dc:	89 44 24 04          	mov    %eax,0x4(%esp)
    14e0:	8b 45 10             	mov    0x10(%ebp),%eax
    14e3:	89 44 24 08          	mov    %eax,0x8(%esp)
    14e7:	e8 6c 15 00 00       	call   2a58 <draw_picture>
        freepic(&next);
    14ec:	8d 45 d4             	lea    -0x2c(%ebp),%eax
    14ef:	89 04 24             	mov    %eax,(%esp)
    14f2:	e8 3d 20 00 00       	call   3534 <freepic>
	
}
    14f7:	c9                   	leave  
    14f8:	c3                   	ret    

000014f9 <drawPicViewerContent>:

void drawPicViewerContent(Context context, char* fileName) {
    14f9:	55                   	push   %ebp
    14fa:	89 e5                	mov    %esp,%ebp
    14fc:	83 ec 38             	sub    $0x38,%esp
    int c_width, c_height;
    int pic_width, pic_height;

    c_width = context.width;
    14ff:	8b 45 0c             	mov    0xc(%ebp),%eax
    1502:	89 45 f4             	mov    %eax,-0xc(%ebp)
    c_height = context.height;
    1505:	8b 45 10             	mov    0x10(%ebp),%eax
    1508:	89 45 f0             	mov    %eax,-0x10(%ebp)
    pic_width = pic.width;
    150b:	a1 04 1a 01 00       	mov    0x11a04,%eax
    1510:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pic_height = pic.height;
    1513:	a1 08 1a 01 00       	mov    0x11a08,%eax
    1518:	89 45 e8             	mov    %eax,-0x18(%ebp)

    printf(0, "drawPicViewerContent: pic_width: %d, pic_height: %d\n", pic_width, pic_height);
    151b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    151e:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1522:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1525:	89 44 24 08          	mov    %eax,0x8(%esp)
    1529:	c7 44 24 04 98 aa 00 	movl   $0xaa98,0x4(%esp)
    1530:	00 
    1531:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1538:	e8 05 2e 00 00       	call   4342 <printf>
    draw_picture(context, pic, ((c_width-pic_width) >> 1) + X_shift, TOPBAR_HEIGHT + ((c_height-pic_height) >> 1) + Y_shift);
    153d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1540:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1543:	29 c2                	sub    %eax,%edx
    1545:	89 d0                	mov    %edx,%eax
    1547:	d1 f8                	sar    %eax
    1549:	8d 50 14             	lea    0x14(%eax),%edx
    154c:	a1 10 ec 00 00       	mov    0xec10,%eax
    1551:	01 c2                	add    %eax,%edx
    1553:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1556:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1559:	29 c1                	sub    %eax,%ecx
    155b:	89 c8                	mov    %ecx,%eax
    155d:	d1 f8                	sar    %eax
    155f:	89 c1                	mov    %eax,%ecx
    1561:	a1 0c ec 00 00       	mov    0xec0c,%eax
    1566:	01 c8                	add    %ecx,%eax
    1568:	89 54 24 1c          	mov    %edx,0x1c(%esp)
    156c:	89 44 24 18          	mov    %eax,0x18(%esp)
    1570:	a1 00 1a 01 00       	mov    0x11a00,%eax
    1575:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1579:	a1 04 1a 01 00       	mov    0x11a04,%eax
    157e:	89 44 24 10          	mov    %eax,0x10(%esp)
    1582:	a1 08 1a 01 00       	mov    0x11a08,%eax
    1587:	89 44 24 14          	mov    %eax,0x14(%esp)
    158b:	8b 45 08             	mov    0x8(%ebp),%eax
    158e:	89 04 24             	mov    %eax,(%esp)
    1591:	8b 45 0c             	mov    0xc(%ebp),%eax
    1594:	89 44 24 04          	mov    %eax,0x4(%esp)
    1598:	8b 45 10             	mov    0x10(%ebp),%eax
    159b:	89 44 24 08          	mov    %eax,0x8(%esp)
    159f:	e8 b4 14 00 00       	call   2a58 <draw_picture>
    startXsave = ((c_width-pic_width) >> 1) + X_shift;
    15a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    15a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    15aa:	29 c2                	sub    %eax,%edx
    15ac:	89 d0                	mov    %edx,%eax
    15ae:	d1 f8                	sar    %eax
    15b0:	89 c2                	mov    %eax,%edx
    15b2:	a1 0c ec 00 00       	mov    0xec0c,%eax
    15b7:	01 d0                	add    %edx,%eax
    15b9:	a3 04 ec 00 00       	mov    %eax,0xec04
    startYsave = TOPBAR_HEIGHT + ((c_height-pic_height) >> 1) + Y_shift;
    15be:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    15c4:	29 c2                	sub    %eax,%edx
    15c6:	89 d0                	mov    %edx,%eax
    15c8:	d1 f8                	sar    %eax
    15ca:	8d 50 14             	lea    0x14(%eax),%edx
    15cd:	a1 10 ec 00 00       	mov    0xec10,%eax
    15d2:	01 d0                	add    %edx,%eax
    15d4:	a3 08 ec 00 00       	mov    %eax,0xec08
}
    15d9:	c9                   	leave  
    15da:	c3                   	ret    

000015db <drawPicViewerContentForProper>:

void drawPicViewerContentForProper(Context context, char* fileName) {
    15db:	55                   	push   %ebp
    15dc:	89 e5                	mov    %esp,%ebp
    15de:	83 ec 28             	sub    $0x28,%esp
    
    draw_picture(context, pic, startXsave, startYsave);
    15e1:	8b 15 08 ec 00 00    	mov    0xec08,%edx
    15e7:	a1 04 ec 00 00       	mov    0xec04,%eax
    15ec:	89 54 24 1c          	mov    %edx,0x1c(%esp)
    15f0:	89 44 24 18          	mov    %eax,0x18(%esp)
    15f4:	a1 00 1a 01 00       	mov    0x11a00,%eax
    15f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
    15fd:	a1 04 1a 01 00       	mov    0x11a04,%eax
    1602:	89 44 24 10          	mov    %eax,0x10(%esp)
    1606:	a1 08 1a 01 00       	mov    0x11a08,%eax
    160b:	89 44 24 14          	mov    %eax,0x14(%esp)
    160f:	8b 45 08             	mov    0x8(%ebp),%eax
    1612:	89 04 24             	mov    %eax,(%esp)
    1615:	8b 45 0c             	mov    0xc(%ebp),%eax
    1618:	89 44 24 04          	mov    %eax,0x4(%esp)
    161c:	8b 45 10             	mov    0x10(%ebp),%eax
    161f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1623:	e8 30 14 00 00       	call   2a58 <draw_picture>
}
    1628:	c9                   	leave  
    1629:	c3                   	ret    

0000162a <h_closeWnd>:

void h_closeWnd(Point p) {
    162a:	55                   	push   %ebp
    162b:	89 e5                	mov    %esp,%ebp
    isRun = 0;
    162d:	c7 05 f8 e6 00 00 00 	movl   $0x0,0xe6f8
    1634:	00 00 00 
}
    1637:	5d                   	pop    %ebp
    1638:	c3                   	ret    

00001639 <addWndEvent>:

void addWndEvent(ClickableManager *cm) {
    1639:	55                   	push   %ebp
    163a:	89 e5                	mov    %esp,%ebp
    163c:	57                   	push   %edi
    163d:	56                   	push   %esi
    163e:	53                   	push   %ebx
    163f:	83 ec 4c             	sub    $0x4c,%esp
    int i;
	int n = sizeof(wndEvents) / sizeof(Handler);
    1642:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

	for (i = 0; i < n; i++) {
    1649:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    1650:	e9 96 00 00 00       	jmp    16eb <addWndEvent+0xb2>
		createClickable(cm,
    1655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1658:	8b 1c 85 f4 e6 00 00 	mov    0xe6f4(,%eax,4),%ebx
    165f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1662:	6b c0 34             	imul   $0x34,%eax,%eax
    1665:	05 e0 e6 00 00       	add    $0xe6e0,%eax
    166a:	8b 78 10             	mov    0x10(%eax),%edi
    166d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1670:	6b c0 34             	imul   $0x34,%eax,%eax
    1673:	05 e0 e6 00 00       	add    $0xe6e0,%eax
    1678:	8b 70 0c             	mov    0xc(%eax),%esi
    167b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    167e:	6b c0 34             	imul   $0x34,%eax,%eax
    1681:	05 e0 e6 00 00       	add    $0xe6e0,%eax
    1686:	8b 48 04             	mov    0x4(%eax),%ecx
    1689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    168c:	6b c0 34             	imul   $0x34,%eax,%eax
    168f:	05 e0 e6 00 00       	add    $0xe6e0,%eax
    1694:	8b 10                	mov    (%eax),%edx
    1696:	8d 45 d0             	lea    -0x30(%ebp),%eax
    1699:	89 7c 24 10          	mov    %edi,0x10(%esp)
    169d:	89 74 24 0c          	mov    %esi,0xc(%esp)
    16a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    16a5:	89 54 24 04          	mov    %edx,0x4(%esp)
    16a9:	89 04 24             	mov    %eax,(%esp)
    16ac:	e8 52 21 00 00       	call   3803 <initRect>
    16b1:	83 ec 04             	sub    $0x4,%esp
    16b4:	89 5c 24 18          	mov    %ebx,0x18(%esp)
    16b8:	c7 44 24 14 02 00 00 	movl   $0x2,0x14(%esp)
    16bf:	00 
    16c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
    16c3:	89 44 24 04          	mov    %eax,0x4(%esp)
    16c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    16ca:	89 44 24 08          	mov    %eax,0x8(%esp)
    16ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
    16d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
    16d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
    16d8:	89 44 24 10          	mov    %eax,0x10(%esp)
    16dc:	8b 45 08             	mov    0x8(%ebp),%eax
    16df:	89 04 24             	mov    %eax,(%esp)
    16e2:	e8 08 22 00 00       	call   38ef <createClickable>

void addWndEvent(ClickableManager *cm) {
    int i;
	int n = sizeof(wndEvents) / sizeof(Handler);

	for (i = 0; i < n; i++) {
    16e7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    16eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16ee:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    16f1:	0f 8c 5e ff ff ff    	jl     1655 <addWndEvent+0x1c>
		createClickable(cm,
				initRect(wndRes[i].position_x, wndRes[i].position_y,
						wndRes[i].pic.width, wndRes[i].pic.height), MSG_LPRESS,
				wndEvents[i]);
	}
}
    16f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    16fa:	5b                   	pop    %ebx
    16fb:	5e                   	pop    %esi
    16fc:	5f                   	pop    %edi
    16fd:	5d                   	pop    %ebp
    16fe:	c3                   	ret    

000016ff <propertyShow>:


void propertyShow(Context context, int startX, int startY)
{
    16ff:	55                   	push   %ebp
    1700:	89 e5                	mov    %esp,%ebp
    1702:	53                   	push   %ebx
    1703:	83 ec 64             	sub    $0x64,%esp
	printf(0, "Right Clicked: p.x:%d, p.y:%d\n",startX,startY);
    1706:	8b 45 18             	mov    0x18(%ebp),%eax
    1709:	89 44 24 0c          	mov    %eax,0xc(%esp)
    170d:	8b 45 14             	mov    0x14(%ebp),%eax
    1710:	89 44 24 08          	mov    %eax,0x8(%esp)
    1714:	c7 44 24 04 d0 aa 00 	movl   $0xaad0,0x4(%esp)
    171b:	00 
    171c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1723:	e8 1a 2c 00 00       	call   4342 <printf>
	printf(0, "Right Clicked: pic.width:%d, pic.height:%d\n",pic.width,pic.height);
    1728:	8b 15 08 1a 01 00    	mov    0x11a08,%edx
    172e:	a1 04 1a 01 00       	mov    0x11a04,%eax
    1733:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1737:	89 44 24 08          	mov    %eax,0x8(%esp)
    173b:	c7 44 24 04 f0 aa 00 	movl   $0xaaf0,0x4(%esp)
    1742:	00 
    1743:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    174a:	e8 f3 2b 00 00       	call   4342 <printf>
	//int lengthX = 100;
	//int lengthY = 200;
	int width = pic.width;
    174f:	a1 04 1a 01 00       	mov    0x11a04,%eax
    1754:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int height = pic.height;
    1757:	a1 08 1a 01 00       	mov    0x11a08,%eax
    175c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	
	char*strw = (char*)malloc(10*sizeof(char));
    175f:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
    1766:	e8 c3 2e 00 00       	call   462e <malloc>
    176b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	char*strh = (char*)malloc(10*sizeof(char));
    176e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
    1775:	e8 b4 2e 00 00       	call   462e <malloc>
    177a:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int i = 0;
    177d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int lengthwt; 
	while(width>0)
    1784:	eb 52                	jmp    17d8 <propertyShow+0xd9>
	{
		strw[i] = width%10 + '0';
    1786:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1789:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    178c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    178f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1792:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1797:	89 c8                	mov    %ecx,%eax
    1799:	f7 ea                	imul   %edx
    179b:	c1 fa 02             	sar    $0x2,%edx
    179e:	89 c8                	mov    %ecx,%eax
    17a0:	c1 f8 1f             	sar    $0x1f,%eax
    17a3:	29 c2                	sub    %eax,%edx
    17a5:	89 d0                	mov    %edx,%eax
    17a7:	c1 e0 02             	shl    $0x2,%eax
    17aa:	01 d0                	add    %edx,%eax
    17ac:	01 c0                	add    %eax,%eax
    17ae:	29 c1                	sub    %eax,%ecx
    17b0:	89 ca                	mov    %ecx,%edx
    17b2:	89 d0                	mov    %edx,%eax
    17b4:	83 c0 30             	add    $0x30,%eax
    17b7:	88 03                	mov    %al,(%ebx)
		width/=10;
    17b9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    17bc:	ba 67 66 66 66       	mov    $0x66666667,%edx
    17c1:	89 c8                	mov    %ecx,%eax
    17c3:	f7 ea                	imul   %edx
    17c5:	c1 fa 02             	sar    $0x2,%edx
    17c8:	89 c8                	mov    %ecx,%eax
    17ca:	c1 f8 1f             	sar    $0x1f,%eax
    17cd:	29 c2                	sub    %eax,%edx
    17cf:	89 d0                	mov    %edx,%eax
    17d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		i++;	
    17d4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
	
	char*strw = (char*)malloc(10*sizeof(char));
	char*strh = (char*)malloc(10*sizeof(char));
	int i = 0;
	int lengthwt; 
	while(width>0)
    17d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17dc:	7f a8                	jg     1786 <propertyShow+0x87>
		strw[i] = width%10 + '0';
		width/=10;
		i++;	
	}
	
	lengthwt = i;
    17de:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17e1:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for(;i<=10;i++)
    17e4:	eb 0f                	jmp    17f5 <propertyShow+0xf6>
	{
		strw[i] = '\0';
    17e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    17ec:	01 d0                	add    %edx,%eax
    17ee:	c6 00 00             	movb   $0x0,(%eax)
		width/=10;
		i++;	
	}
	
	lengthwt = i;
	for(;i<=10;i++)
    17f1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    17f5:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
    17f9:	7e eb                	jle    17e6 <propertyShow+0xe7>
	{
		strw[i] = '\0';
	}
	char* strwt = (char*)malloc((lengthwt+1)*sizeof(char));
    17fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
    17fe:	83 c0 01             	add    $0x1,%eax
    1801:	89 04 24             	mov    %eax,(%esp)
    1804:	e8 25 2e 00 00       	call   462e <malloc>
    1809:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//printf(0,"%d",lengthwt);
	int k0 = 0;
    180c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int k = lengthwt - 1;
    1813:	8b 45 cc             	mov    -0x34(%ebp),%eax
    1816:	83 e8 01             	sub    $0x1,%eax
    1819:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for(;k >= 0;k--)
    181c:	eb 30                	jmp    184e <propertyShow+0x14f>
	{
		if(strw[k0] != '\0')strwt[k] = strw[k0];
    181e:	8b 55 e8             	mov    -0x18(%ebp),%edx
    1821:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1824:	01 d0                	add    %edx,%eax
    1826:	0f b6 00             	movzbl (%eax),%eax
    1829:	84 c0                	test   %al,%al
    182b:	74 1f                	je     184c <propertyShow+0x14d>
    182d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    1830:	8b 45 c8             	mov    -0x38(%ebp),%eax
    1833:	01 c2                	add    %eax,%edx
    1835:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    1838:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    183b:	01 c8                	add    %ecx,%eax
    183d:	0f b6 00             	movzbl (%eax),%eax
    1840:	88 02                	mov    %al,(%edx)
		else break;
		k0++;
    1842:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
	}
	char* strwt = (char*)malloc((lengthwt+1)*sizeof(char));
	//printf(0,"%d",lengthwt);
	int k0 = 0;
	int k = lengthwt - 1;
	for(;k >= 0;k--)
    1846:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
    184a:	eb 02                	jmp    184e <propertyShow+0x14f>
	{
		if(strw[k0] != '\0')strwt[k] = strw[k0];
		else break;
    184c:	eb 06                	jmp    1854 <propertyShow+0x155>
	}
	char* strwt = (char*)malloc((lengthwt+1)*sizeof(char));
	//printf(0,"%d",lengthwt);
	int k0 = 0;
	int k = lengthwt - 1;
	for(;k >= 0;k--)
    184e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1852:	79 ca                	jns    181e <propertyShow+0x11f>
		if(strw[k0] != '\0')strwt[k] = strw[k0];
		else break;
		k0++;
		
	}
	strwt[lengthwt] = '\0';
    1854:	8b 55 cc             	mov    -0x34(%ebp),%edx
    1857:	8b 45 c8             	mov    -0x38(%ebp),%eax
    185a:	01 d0                	add    %edx,%eax
    185c:	c6 00 00             	movb   $0x0,(%eax)
	free(strw);
    185f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1862:	89 04 24             	mov    %eax,(%esp)
    1865:	e8 8b 2c 00 00       	call   44f5 <free>
	
	printf(0,"In itoa w:");
    186a:	c7 44 24 04 1c ab 00 	movl   $0xab1c,0x4(%esp)
    1871:	00 
    1872:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1879:	e8 c4 2a 00 00       	call   4342 <printf>
	printf(0,strwt);
    187e:	8b 45 c8             	mov    -0x38(%ebp),%eax
    1881:	89 44 24 04          	mov    %eax,0x4(%esp)
    1885:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    188c:	e8 b1 2a 00 00       	call   4342 <printf>
	printf(0,"\n");
    1891:	c7 44 24 04 27 ab 00 	movl   $0xab27,0x4(%esp)
    1898:	00 
    1899:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    18a0:	e8 9d 2a 00 00       	call   4342 <printf>

	int j = 0;
    18a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	int lengthht; 
	while(height>0)
    18ac:	eb 52                	jmp    1900 <propertyShow+0x201>
	{
		strh[j] = height%10 + '0';
    18ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
    18b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
    18b4:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    18b7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    18ba:	ba 67 66 66 66       	mov    $0x66666667,%edx
    18bf:	89 c8                	mov    %ecx,%eax
    18c1:	f7 ea                	imul   %edx
    18c3:	c1 fa 02             	sar    $0x2,%edx
    18c6:	89 c8                	mov    %ecx,%eax
    18c8:	c1 f8 1f             	sar    $0x1f,%eax
    18cb:	29 c2                	sub    %eax,%edx
    18cd:	89 d0                	mov    %edx,%eax
    18cf:	c1 e0 02             	shl    $0x2,%eax
    18d2:	01 d0                	add    %edx,%eax
    18d4:	01 c0                	add    %eax,%eax
    18d6:	29 c1                	sub    %eax,%ecx
    18d8:	89 ca                	mov    %ecx,%edx
    18da:	89 d0                	mov    %edx,%eax
    18dc:	83 c0 30             	add    $0x30,%eax
    18df:	88 03                	mov    %al,(%ebx)
		height/=10;
    18e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    18e4:	ba 67 66 66 66       	mov    $0x66666667,%edx
    18e9:	89 c8                	mov    %ecx,%eax
    18eb:	f7 ea                	imul   %edx
    18ed:	c1 fa 02             	sar    $0x2,%edx
    18f0:	89 c8                	mov    %ecx,%eax
    18f2:	c1 f8 1f             	sar    $0x1f,%eax
    18f5:	29 c2                	sub    %eax,%edx
    18f7:	89 d0                	mov    %edx,%eax
    18f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		j++;	
    18fc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
	printf(0,strwt);
	printf(0,"\n");

	int j = 0;
	int lengthht; 
	while(height>0)
    1900:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1904:	7f a8                	jg     18ae <propertyShow+0x1af>
		strh[j] = height%10 + '0';
		height/=10;
		j++;	
	}
	
	lengthht = j;
    1906:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1909:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(;j<=10;j++)
    190c:	eb 0f                	jmp    191d <propertyShow+0x21e>
	{
		strh[j] = '\0';
    190e:	8b 55 e0             	mov    -0x20(%ebp),%edx
    1911:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1914:	01 d0                	add    %edx,%eax
    1916:	c6 00 00             	movb   $0x0,(%eax)
		height/=10;
		j++;	
	}
	
	lengthht = j;
	for(;j<=10;j++)
    1919:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    191d:	83 7d e0 0a          	cmpl   $0xa,-0x20(%ebp)
    1921:	7e eb                	jle    190e <propertyShow+0x20f>
	{
		strh[j] = '\0';
	}
	char* strht = (char*)malloc((lengthht+1)*sizeof(char));
    1923:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    1926:	83 c0 01             	add    $0x1,%eax
    1929:	89 04 24             	mov    %eax,(%esp)
    192c:	e8 fd 2c 00 00       	call   462e <malloc>
    1931:	89 45 c0             	mov    %eax,-0x40(%ebp)
	//printf(0,"%d",lengthht);
	int t0 = 0;
    1934:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	int t = lengthht - 1;
    193b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    193e:	83 e8 01             	sub    $0x1,%eax
    1941:	89 45 d8             	mov    %eax,-0x28(%ebp)
	for(;t >= 0;t--)
    1944:	eb 30                	jmp    1976 <propertyShow+0x277>
	{
		if(strh[t0] != '\0')strht[t] = strh[t0];
    1946:	8b 55 dc             	mov    -0x24(%ebp),%edx
    1949:	8b 45 d0             	mov    -0x30(%ebp),%eax
    194c:	01 d0                	add    %edx,%eax
    194e:	0f b6 00             	movzbl (%eax),%eax
    1951:	84 c0                	test   %al,%al
    1953:	74 1f                	je     1974 <propertyShow+0x275>
    1955:	8b 55 d8             	mov    -0x28(%ebp),%edx
    1958:	8b 45 c0             	mov    -0x40(%ebp),%eax
    195b:	01 c2                	add    %eax,%edx
    195d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
    1960:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1963:	01 c8                	add    %ecx,%eax
    1965:	0f b6 00             	movzbl (%eax),%eax
    1968:	88 02                	mov    %al,(%edx)
		else break;
		t0++;
    196a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
	}
	char* strht = (char*)malloc((lengthht+1)*sizeof(char));
	//printf(0,"%d",lengthht);
	int t0 = 0;
	int t = lengthht - 1;
	for(;t >= 0;t--)
    196e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
    1972:	eb 02                	jmp    1976 <propertyShow+0x277>
	{
		if(strh[t0] != '\0')strht[t] = strh[t0];
		else break;
    1974:	eb 06                	jmp    197c <propertyShow+0x27d>
	}
	char* strht = (char*)malloc((lengthht+1)*sizeof(char));
	//printf(0,"%d",lengthht);
	int t0 = 0;
	int t = lengthht - 1;
	for(;t >= 0;t--)
    1976:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    197a:	79 ca                	jns    1946 <propertyShow+0x247>
		if(strh[t0] != '\0')strht[t] = strh[t0];
		else break;
		t0++;
		
	}
	strht[lengthht] = '\0';
    197c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    197f:	8b 45 c0             	mov    -0x40(%ebp),%eax
    1982:	01 d0                	add    %edx,%eax
    1984:	c6 00 00             	movb   $0x0,(%eax)
	free(strh);
    1987:	8b 45 d0             	mov    -0x30(%ebp),%eax
    198a:	89 04 24             	mov    %eax,(%esp)
    198d:	e8 63 2b 00 00       	call   44f5 <free>
	
	printf(0,"In itoa h:");
    1992:	c7 44 24 04 29 ab 00 	movl   $0xab29,0x4(%esp)
    1999:	00 
    199a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    19a1:	e8 9c 29 00 00       	call   4342 <printf>
	printf(0,strht);
    19a6:	8b 45 c0             	mov    -0x40(%ebp),%eax
    19a9:	89 44 24 04          	mov    %eax,0x4(%esp)
    19ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    19b4:	e8 89 29 00 00       	call   4342 <printf>
	printf(0,"\n");
    19b9:	c7 44 24 04 27 ab 00 	movl   $0xab27,0x4(%esp)
    19c0:	00 
    19c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    19c8:	e8 75 29 00 00       	call   4342 <printf>

	
	puts_str(context, "Width:", 0, startX+10, startY+10);
    19cd:	8b 45 18             	mov    0x18(%ebp),%eax
    19d0:	8d 50 0a             	lea    0xa(%eax),%edx
    19d3:	8b 45 14             	mov    0x14(%ebp),%eax
    19d6:	83 c0 0a             	add    $0xa,%eax
    19d9:	89 54 24 18          	mov    %edx,0x18(%esp)
    19dd:	89 44 24 14          	mov    %eax,0x14(%esp)
    19e1:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    19e8:	00 
    19e9:	c7 44 24 0c 34 ab 00 	movl   $0xab34,0xc(%esp)
    19f0:	00 
    19f1:	8b 45 08             	mov    0x8(%ebp),%eax
    19f4:	89 04 24             	mov    %eax,(%esp)
    19f7:	8b 45 0c             	mov    0xc(%ebp),%eax
    19fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    19fe:	8b 45 10             	mov    0x10(%ebp),%eax
    1a01:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a05:	e8 8e 0f 00 00       	call   2998 <puts_str>
	puts_str(context, strwt, 0, startX+70, startY+10);
    1a0a:	8b 45 18             	mov    0x18(%ebp),%eax
    1a0d:	8d 50 0a             	lea    0xa(%eax),%edx
    1a10:	8b 45 14             	mov    0x14(%ebp),%eax
    1a13:	83 c0 46             	add    $0x46,%eax
    1a16:	89 54 24 18          	mov    %edx,0x18(%esp)
    1a1a:	89 44 24 14          	mov    %eax,0x14(%esp)
    1a1e:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    1a25:	00 
    1a26:	8b 45 c8             	mov    -0x38(%ebp),%eax
    1a29:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1a2d:	8b 45 08             	mov    0x8(%ebp),%eax
    1a30:	89 04 24             	mov    %eax,(%esp)
    1a33:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a36:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a3a:	8b 45 10             	mov    0x10(%ebp),%eax
    1a3d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a41:	e8 52 0f 00 00       	call   2998 <puts_str>
	puts_str(context, "Height:", 0, startX+10, startY+30);
    1a46:	8b 45 18             	mov    0x18(%ebp),%eax
    1a49:	8d 50 1e             	lea    0x1e(%eax),%edx
    1a4c:	8b 45 14             	mov    0x14(%ebp),%eax
    1a4f:	83 c0 0a             	add    $0xa,%eax
    1a52:	89 54 24 18          	mov    %edx,0x18(%esp)
    1a56:	89 44 24 14          	mov    %eax,0x14(%esp)
    1a5a:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    1a61:	00 
    1a62:	c7 44 24 0c 3b ab 00 	movl   $0xab3b,0xc(%esp)
    1a69:	00 
    1a6a:	8b 45 08             	mov    0x8(%ebp),%eax
    1a6d:	89 04 24             	mov    %eax,(%esp)
    1a70:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a73:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a77:	8b 45 10             	mov    0x10(%ebp),%eax
    1a7a:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a7e:	e8 15 0f 00 00       	call   2998 <puts_str>
	puts_str(context, strht, 0, startX+70, startY+30);
    1a83:	8b 45 18             	mov    0x18(%ebp),%eax
    1a86:	8d 50 1e             	lea    0x1e(%eax),%edx
    1a89:	8b 45 14             	mov    0x14(%ebp),%eax
    1a8c:	83 c0 46             	add    $0x46,%eax
    1a8f:	89 54 24 18          	mov    %edx,0x18(%esp)
    1a93:	89 44 24 14          	mov    %eax,0x14(%esp)
    1a97:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    1a9e:	00 
    1a9f:	8b 45 c0             	mov    -0x40(%ebp),%eax
    1aa2:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1aa6:	8b 45 08             	mov    0x8(%ebp),%eax
    1aa9:	89 04 24             	mov    %eax,(%esp)
    1aac:	8b 45 0c             	mov    0xc(%ebp),%eax
    1aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ab3:	8b 45 10             	mov    0x10(%ebp),%eax
    1ab6:	89 44 24 08          	mov    %eax,0x8(%esp)
    1aba:	e8 d9 0e 00 00       	call   2998 <puts_str>
	
	//lengthX = 0;
	//lengthY = 0;
	updateWindowWithoutBlank(context);
    1abf:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac2:	89 04 24             	mov    %eax,(%esp)
    1ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
    1ac8:	89 44 24 04          	mov    %eax,0x4(%esp)
    1acc:	8b 45 10             	mov    0x10(%ebp),%eax
    1acf:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ad3:	e8 3f f7 ff ff       	call   1217 <updateWindowWithoutBlank>

}
    1ad8:	83 c4 64             	add    $0x64,%esp
    1adb:	5b                   	pop    %ebx
    1adc:	5d                   	pop    %ebp
    1add:	c3                   	ret    

00001ade <main>:



int main(int argc, char *argv[]) {
    1ade:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1ae2:	83 e4 f0             	and    $0xfffffff0,%esp
    1ae5:	ff 71 fc             	pushl  -0x4(%ecx)
    1ae8:	55                   	push   %ebp
    1ae9:	89 e5                	mov    %esp,%ebp
    1aeb:	56                   	push   %esi
    1aec:	53                   	push   %ebx
    1aed:	51                   	push   %ecx
    1aee:	81 ec dc 00 00 00    	sub    $0xdc,%esp
    1af4:	89 cb                	mov    %ecx,%ebx
    struct Context context;
    ClickableManager cm;//（这个东西是干吗用的？）
    int winid;
    struct Msg msg;
    Point p;
    len = atoi(argv[2]);
    1af6:	8b 43 04             	mov    0x4(%ebx),%eax
    1af9:	83 c0 08             	add    $0x8,%eax
    1afc:	8b 00                	mov    (%eax),%eax
    1afe:	89 04 24             	mov    %eax,(%esp)
    1b01:	e8 c2 25 00 00       	call   40c8 <atoi>
    1b06:	a3 b0 1b 01 00       	mov    %eax,0x11bb0
    pos = atoi(argv[3]) - 1;
    1b0b:	8b 43 04             	mov    0x4(%ebx),%eax
    1b0e:	83 c0 0c             	add    $0xc,%eax
    1b11:	8b 00                	mov    (%eax),%eax
    1b13:	89 04 24             	mov    %eax,(%esp)
    1b16:	e8 ad 25 00 00       	call   40c8 <atoi>
    1b1b:	83 e8 01             	sub    $0x1,%eax
    1b1e:	a3 0c 1a 01 00       	mov    %eax,0x11a0c
printf(0,"%d",pos);
    1b23:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
    1b28:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b2c:	c7 44 24 04 43 ab 00 	movl   $0xab43,0x4(%esp)
    1b33:	00 
    1b34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1b3b:	e8 02 28 00 00       	call   4342 <printf>
printf(0,"   %d   ",len);
    1b40:	a1 b0 1b 01 00       	mov    0x11bb0,%eax
    1b45:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b49:	c7 44 24 04 46 ab 00 	movl   $0xab46,0x4(%esp)
    1b50:	00 
    1b51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1b58:	e8 e5 27 00 00       	call   4342 <printf>
    int i = 0;
    1b5d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    int j = 0;
    1b64:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    int k = 0;
    1b6b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    int end = -1;
    1b72:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
    while(i <= len + 3){
    1b79:	e9 9c 00 00 00       	jmp    1c1a <main+0x13c>
	if (argv[2][i]=='\1'){
    1b7e:	8b 43 04             	mov    0x4(%ebx),%eax
    1b81:	83 c0 08             	add    $0x8,%eax
    1b84:	8b 10                	mov    (%eax),%edx
    1b86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1b89:	01 d0                	add    %edx,%eax
    1b8b:	0f b6 00             	movzbl (%eax),%eax
    1b8e:	3c 01                	cmp    $0x1,%al
    1b90:	0f 85 80 00 00 00    	jne    1c16 <main+0x138>
	    file[j] = (char*)malloc((i-end)*sizeof(char));
    1b96:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1b99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    1b9c:	29 c2                	sub    %eax,%edx
    1b9e:	89 d0                	mov    %edx,%eax
    1ba0:	89 04 24             	mov    %eax,(%esp)
    1ba3:	e8 86 2a 00 00       	call   462e <malloc>
    1ba8:	8b 55 e0             	mov    -0x20(%ebp),%edx
    1bab:	89 04 95 20 1a 01 00 	mov    %eax,0x11a20(,%edx,4)
	    for(k = 0;k < (i-end);k++)
    1bb2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    1bb9:	eb 2d                	jmp    1be8 <main+0x10a>
		file[j][k] = argv[2][end+1+k];
    1bbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1bbe:	8b 14 85 20 1a 01 00 	mov    0x11a20(,%eax,4),%edx
    1bc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1bc8:	01 c2                	add    %eax,%edx
    1bca:	8b 43 04             	mov    0x4(%ebx),%eax
    1bcd:	83 c0 08             	add    $0x8,%eax
    1bd0:	8b 08                	mov    (%eax),%ecx
    1bd2:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1bd5:	8d 70 01             	lea    0x1(%eax),%esi
    1bd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1bdb:	01 f0                	add    %esi,%eax
    1bdd:	01 c8                	add    %ecx,%eax
    1bdf:	0f b6 00             	movzbl (%eax),%eax
    1be2:	88 02                	mov    %al,(%edx)
    int k = 0;
    int end = -1;
    while(i <= len + 3){
	if (argv[2][i]=='\1'){
	    file[j] = (char*)malloc((i-end)*sizeof(char));
	    for(k = 0;k < (i-end);k++)
    1be4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
    1be8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1beb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    1bee:	29 c2                	sub    %eax,%edx
    1bf0:	89 d0                	mov    %edx,%eax
    1bf2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    1bf5:	7f c4                	jg     1bbb <main+0xdd>
		file[j][k] = argv[2][end+1+k];
	    file[j][k-1] = '\0';
    1bf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1bfa:	8b 04 85 20 1a 01 00 	mov    0x11a20(,%eax,4),%eax
    1c01:	8b 55 dc             	mov    -0x24(%ebp),%edx
    1c04:	83 ea 01             	sub    $0x1,%edx
    1c07:	01 d0                	add    %edx,%eax
    1c09:	c6 00 00             	movb   $0x0,(%eax)
	    end = i;
    1c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1c0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	    j++;
    1c12:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
	    
	}
	i++;
    1c16:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
printf(0,"   %d   ",len);
    int i = 0;
    int j = 0;
    int k = 0;
    int end = -1;
    while(i <= len + 3){
    1c1a:	a1 b0 1b 01 00       	mov    0x11bb0,%eax
    1c1f:	83 c0 03             	add    $0x3,%eax
    1c22:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
    1c25:	0f 8d 53 ff ff ff    	jge    1b7e <main+0xa0>
	    
	}
	i++;
    }

	len = j;
    1c2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1c2e:	a3 b0 1b 01 00       	mov    %eax,0x11bb0
	
	



    winid = init_context(&context, WINDOW_WIDTH, WINDOW_HEIGHT);//根据窗口大小初始化背景
    1c33:	c7 44 24 08 36 01 00 	movl   $0x136,0x8(%esp)
    1c3a:	00 
    1c3b:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
    1c42:	00 
    1c43:	8d 45 98             	lea    -0x68(%ebp),%eax
    1c46:	89 04 24             	mov    %eax,(%esp)
    1c49:	e8 7f 06 00 00       	call   22cd <init_context>
    1c4e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    cm = initClickManager(context);//根据背景初始化ClickableManager
    1c51:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
    1c57:	8b 55 98             	mov    -0x68(%ebp),%edx
    1c5a:	89 54 24 04          	mov    %edx,0x4(%esp)
    1c5e:	8b 55 9c             	mov    -0x64(%ebp),%edx
    1c61:	89 54 24 08          	mov    %edx,0x8(%esp)
    1c65:	8b 55 a0             	mov    -0x60(%ebp),%edx
    1c68:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1c6c:	89 04 24             	mov    %eax,(%esp)
    1c6f:	e8 2d 1c 00 00       	call   38a1 <initClickManager>
    1c74:	83 ec 04             	sub    $0x4,%esp
    1c77:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
    1c7d:	89 45 84             	mov    %eax,-0x7c(%ebp)
    1c80:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
    1c86:	89 45 88             	mov    %eax,-0x78(%ebp)
    1c89:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
    1c8f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    1c92:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
    1c98:	89 45 90             	mov    %eax,-0x70(%ebp)
    1c9b:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
    1ca1:	89 45 94             	mov    %eax,-0x6c(%ebp)

    loadBitmap(&pic, file[pos]);//载入bmp
    1ca4:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
    1ca9:	8b 04 85 20 1a 01 00 	mov    0x11a20(,%eax,4),%eax
    1cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
    1cb4:	c7 04 24 00 1a 01 00 	movl   $0x11a00,(%esp)
    1cbb:	e8 c8 12 00 00       	call   2f88 <loadBitmap>
    load_iconlist(wndRes, sizeof(wndRes) / sizeof(ICON));//载入图标数组
    1cc0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1cc7:	00 
    1cc8:	c7 04 24 c0 e6 00 00 	movl   $0xe6c0,(%esp)
    1ccf:	e8 f3 11 00 00       	call   2ec7 <load_iconlist>

    modifyPic(context);//按照背景修改图片
    1cd4:	8b 45 98             	mov    -0x68(%ebp),%eax
    1cd7:	89 04 24             	mov    %eax,(%esp)
    1cda:	8b 45 9c             	mov    -0x64(%ebp),%eax
    1cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ce1:	8b 45 a0             	mov    -0x60(%ebp),%eax
    1ce4:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ce8:	e8 be ea ff ff       	call   7ab <modifyPic>
    deleteClickable(&cm.left_click, initRect(0, 0, 800, 600));
    1ced:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    1cf0:	c7 44 24 10 58 02 00 	movl   $0x258,0x10(%esp)
    1cf7:	00 
    1cf8:	c7 44 24 0c 20 03 00 	movl   $0x320,0xc(%esp)
    1cff:	00 
    1d00:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1d07:	00 
    1d08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1d0f:	00 
    1d10:	89 04 24             	mov    %eax,(%esp)
    1d13:	e8 eb 1a 00 00       	call   3803 <initRect>
    1d18:	83 ec 04             	sub    $0x4,%esp
    1d1b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    1d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1d22:	8b 45 a8             	mov    -0x58(%ebp),%eax
    1d25:	89 44 24 08          	mov    %eax,0x8(%esp)
    1d29:	8b 45 ac             	mov    -0x54(%ebp),%eax
    1d2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1d30:	8b 45 b0             	mov    -0x50(%ebp),%eax
    1d33:	89 44 24 10          	mov    %eax,0x10(%esp)
    1d37:	8d 45 84             	lea    -0x7c(%ebp),%eax
    1d3a:	89 04 24             	mov    %eax,(%esp)
    1d3d:	e8 c4 1c 00 00       	call   3a06 <deleteClickable>
    addWndEvent(&cm);//添加cm到窗口事件
    1d42:	8d 45 84             	lea    -0x7c(%ebp),%eax
    1d45:	89 04 24             	mov    %eax,(%esp)
    1d48:	e8 ec f8 ff ff       	call   1639 <addWndEvent>

    Initialize(context);
    1d4d:	8b 45 98             	mov    -0x68(%ebp),%eax
    1d50:	89 04 24             	mov    %eax,(%esp)
    1d53:	8b 45 9c             	mov    -0x64(%ebp),%eax
    1d56:	89 44 24 04          	mov    %eax,0x4(%esp)
    1d5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
    1d5d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1d61:	e8 9a e2 ff ff       	call   0 <Initialize>

    while (isRun) {
    1d66:	e9 3e 05 00 00       	jmp    22a9 <main+0x7cb>
        getMsg(&msg);//获取消息
    1d6b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
    1d71:	89 04 24             	mov    %eax,(%esp)
    1d74:	e8 81 24 00 00       	call   41fa <getMsg>
        switch (msg.msg_type) {//判断消息类型
    1d79:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
    1d7f:	83 f8 08             	cmp    $0x8,%eax
    1d82:	0f 87 20 05 00 00    	ja     22a8 <main+0x7ca>
    1d88:	8b 04 85 ac ab 00 00 	mov    0xabac(,%eax,4),%eax
    1d8f:	ff e0                	jmp    *%eax
		case MSG_DOUBLECLICK://双击消息
			p = initPoint(msg.concrete_msg.msg_mouse.x,msg.concrete_msg.msg_mouse.y);//获取到鼠标现在的点
    1d91:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
    1d97:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
    1d9d:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
    1da3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    1da7:	89 54 24 04          	mov    %edx,0x4(%esp)
    1dab:	89 04 24             	mov    %eax,(%esp)
    1dae:	e8 29 1a 00 00       	call   37dc <initPoint>
    1db3:	83 ec 04             	sub    $0x4,%esp
			if (executeHandler(cm.double_click, p))//（暂时不懂）
    1db6:	8b 4d 88             	mov    -0x78(%ebp),%ecx
    1db9:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
    1dbf:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
    1dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
    1dc9:	89 54 24 08          	mov    %edx,0x8(%esp)
    1dcd:	89 0c 24             	mov    %ecx,(%esp)
    1dd0:	e8 11 1d 00 00       	call   3ae6 <executeHandler>
    1dd5:	85 c0                	test   %eax,%eax
    1dd7:	74 1c                	je     1df5 <main+0x317>
            		{
				updateWindow(winid, context.addr, msg.msg_detail);//更新窗口
    1dd9:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
    1ddf:	8b 45 98             	mov    -0x68(%ebp),%eax
    1de2:	89 54 24 08          	mov    %edx,0x8(%esp)
    1de6:	89 44 24 04          	mov    %eax,0x4(%esp)
    1dea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1ded:	89 04 24             	mov    %eax,(%esp)
    1df0:	e8 1d 24 00 00       	call   4212 <updateWindow>
			}
            		printf(0,"DoubleClick: context_width: %d, context_height: %d\n", context.width, context.height);
    1df5:	8b 55 a0             	mov    -0x60(%ebp),%edx
    1df8:	8b 45 9c             	mov    -0x64(%ebp),%eax
    1dfb:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1dff:	89 44 24 08          	mov    %eax,0x8(%esp)
    1e03:	c7 44 24 04 50 ab 00 	movl   $0xab50,0x4(%esp)
    1e0a:	00 
    1e0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1e12:	e8 2b 25 00 00       	call   4342 <printf>
			printf(0,"DoubleClick: mouseX: %d, mouseY: %d\n", p.x, p.y);
    1e17:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
    1e1d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
    1e23:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1e27:	89 44 24 08          	mov    %eax,0x8(%esp)
    1e2b:	c7 44 24 04 84 ab 00 	movl   $0xab84,0x4(%esp)
    1e32:	00 
    1e33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1e3a:	e8 03 25 00 00       	call   4342 <printf>
            		zoomingPic(context,p.x,p.y);
    1e3f:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
    1e45:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
    1e4b:	89 54 24 10          	mov    %edx,0x10(%esp)
    1e4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1e53:	8b 45 98             	mov    -0x68(%ebp),%eax
    1e56:	89 04 24             	mov    %eax,(%esp)
    1e59:	8b 45 9c             	mov    -0x64(%ebp),%eax
    1e5c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e60:	8b 45 a0             	mov    -0x60(%ebp),%eax
    1e63:	89 44 24 08          	mov    %eax,0x8(%esp)
    1e67:	e8 80 ed ff ff       	call   bec <zoomingPic>
            		updateWindow(winid, context.addr, msg.msg_detail);
    1e6c:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
    1e72:	8b 45 98             	mov    -0x68(%ebp),%eax
    1e75:	89 54 24 08          	mov    %edx,0x8(%esp)
    1e79:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1e80:	89 04 24             	mov    %eax,(%esp)
    1e83:	e8 8a 23 00 00       	call   4212 <updateWindow>
                
			break;
    1e88:	e9 1c 04 00 00       	jmp    22a9 <main+0x7cb>
		case MSG_UPDATE://更新消息（太好了貌似可以直接调重绘了）
			drawPicViewerWnd(context);//绘制窗口
    1e8d:	8b 45 98             	mov    -0x68(%ebp),%eax
    1e90:	89 04 24             	mov    %eax,(%esp)
    1e93:	8b 45 9c             	mov    -0x64(%ebp),%eax
    1e96:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e9a:	8b 45 a0             	mov    -0x60(%ebp),%eax
    1e9d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ea1:	e8 77 f0 ff ff       	call   f1d <drawPicViewerWnd>
			drawPicViewerContent(context, file[pos]);//背景里绘制图片
    1ea6:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
    1eab:	8b 04 85 20 1a 01 00 	mov    0x11a20(,%eax,4),%eax
    1eb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1eb6:	8b 45 98             	mov    -0x68(%ebp),%eax
    1eb9:	89 04 24             	mov    %eax,(%esp)
    1ebc:	8b 45 9c             	mov    -0x64(%ebp),%eax
    1ebf:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ec3:	8b 45 a0             	mov    -0x60(%ebp),%eax
    1ec6:	89 44 24 08          	mov    %eax,0x8(%esp)
    1eca:	e8 2a f6 ff ff       	call   14f9 <drawPicViewerContent>
			updateWindow(winid, context.addr, msg.msg_detail);//更新窗口
    1ecf:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
    1ed5:	8b 45 98             	mov    -0x68(%ebp),%eax
    1ed8:	89 54 24 08          	mov    %edx,0x8(%esp)
    1edc:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ee0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1ee3:	89 04 24             	mov    %eax,(%esp)
    1ee6:	e8 27 23 00 00       	call   4212 <updateWindow>
			break;
    1eeb:	e9 b9 03 00 00       	jmp    22a9 <main+0x7cb>
		case MSG_PARTIAL_UPDATE://部分更新消息
			updatePartialWindow(winid, context.addr,
    1ef0:	8b b5 7c ff ff ff    	mov    -0x84(%ebp),%esi
    1ef6:	8b 9d 78 ff ff ff    	mov    -0x88(%ebp),%ebx
    1efc:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
    1f02:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
    1f08:	8b 45 98             	mov    -0x68(%ebp),%eax
    1f0b:	89 74 24 14          	mov    %esi,0x14(%esp)
    1f0f:	89 5c 24 10          	mov    %ebx,0x10(%esp)
    1f13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1f17:	89 54 24 08          	mov    %edx,0x8(%esp)
    1f1b:	89 44 24 04          	mov    %eax,0x4(%esp)
    1f1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1f22:	89 04 24             	mov    %eax,(%esp)
    1f25:	e8 f0 22 00 00       	call   421a <updatePartialWindow>
					msg.concrete_msg.msg_partial_update.x1,
					msg.concrete_msg.msg_partial_update.y1,
					msg.concrete_msg.msg_partial_update.x2,
					msg.concrete_msg.msg_partial_update.y2);//还能部分更新窗口？以一个矩形区域更新
			break;
    1f2a:	e9 7a 03 00 00       	jmp    22a9 <main+0x7cb>
		case MSG_LPRESS://鼠标左键按下
			p = initPoint(msg.concrete_msg.msg_mouse.x,
    1f2f:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
    1f35:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
    1f3b:	8d 85 30 ff ff ff    	lea    -0xd0(%ebp),%eax
    1f41:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    1f45:	89 54 24 04          	mov    %edx,0x4(%esp)
    1f49:	89 04 24             	mov    %eax,(%esp)
    1f4c:	e8 8b 18 00 00       	call   37dc <initPoint>
    1f51:	83 ec 04             	sub    $0x4,%esp
    1f54:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
    1f5a:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
    1f60:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
    1f66:	89 95 64 ff ff ff    	mov    %edx,-0x9c(%ebp)
					msg.concrete_msg.msg_mouse.y);//获取到鼠标现在的点

			//Rolling Button Area:(40,3),(56,18)
			int RBlowX = 40;
    1f6c:	c7 45 d0 28 00 00 00 	movl   $0x28,-0x30(%ebp)
			int RBlowY = 3;
    1f73:	c7 45 cc 03 00 00 00 	movl   $0x3,-0x34(%ebp)
			int RBhighX = 56;
    1f7a:	c7 45 c8 38 00 00 00 	movl   $0x38,-0x38(%ebp)
			int RBhighY = 18;
    1f81:	c7 45 c4 12 00 00 00 	movl   $0x12,-0x3c(%ebp)
			if(p.x >= RBlowX && p.x <= RBhighX && p.y >= RBlowY && p.y <= RBhighY)
    1f88:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
    1f8e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
    1f91:	7c 3a                	jl     1fcd <main+0x4ef>
    1f93:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
    1f99:	3b 45 c8             	cmp    -0x38(%ebp),%eax
    1f9c:	7f 2f                	jg     1fcd <main+0x4ef>
    1f9e:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
    1fa4:	3b 45 cc             	cmp    -0x34(%ebp),%eax
    1fa7:	7c 24                	jl     1fcd <main+0x4ef>
    1fa9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
    1faf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
    1fb2:	7f 19                	jg     1fcd <main+0x4ef>
			{
				rollingPic(context);
    1fb4:	8b 45 98             	mov    -0x68(%ebp),%eax
    1fb7:	89 04 24             	mov    %eax,(%esp)
    1fba:	8b 45 9c             	mov    -0x64(%ebp),%eax
    1fbd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1fc1:	8b 45 a0             	mov    -0x60(%ebp),%eax
    1fc4:	89 44 24 08          	mov    %eax,0x8(%esp)
    1fc8:	e8 d3 ec ff ff       	call   ca0 <rollingPic>
				
			}

			int NElowX = 60;
    1fcd:	c7 45 c0 3c 00 00 00 	movl   $0x3c,-0x40(%ebp)
			int NElowY = 3;
    1fd4:	c7 45 bc 03 00 00 00 	movl   $0x3,-0x44(%ebp)
			int NEhighX = 76;
    1fdb:	c7 45 b8 4c 00 00 00 	movl   $0x4c,-0x48(%ebp)
			int NEhighY = 18;
    1fe2:	c7 45 b4 12 00 00 00 	movl   $0x12,-0x4c(%ebp)
			if(p.x >= NElowX && p.x <= NEhighX && p.y >= NElowY && p.y <= NEhighY)
    1fe9:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
    1fef:	3b 45 c0             	cmp    -0x40(%ebp),%eax
    1ff2:	7c 3a                	jl     202e <main+0x550>
    1ff4:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
    1ffa:	3b 45 b8             	cmp    -0x48(%ebp),%eax
    1ffd:	7f 2f                	jg     202e <main+0x550>
    1fff:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
    2005:	3b 45 bc             	cmp    -0x44(%ebp),%eax
    2008:	7c 24                	jl     202e <main+0x550>
    200a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
    2010:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
    2013:	7f 19                	jg     202e <main+0x550>
			{
				nextPic(context);
    2015:	8b 45 98             	mov    -0x68(%ebp),%eax
    2018:	89 04 24             	mov    %eax,(%esp)
    201b:	8b 45 9c             	mov    -0x64(%ebp),%eax
    201e:	89 44 24 04          	mov    %eax,0x4(%esp)
    2022:	8b 45 a0             	mov    -0x60(%ebp),%eax
    2025:	89 44 24 08          	mov    %eax,0x8(%esp)
    2029:	e8 f3 ed ff ff       	call   e21 <nextPic>
			}

			updateWindow(winid, context.addr, msg.msg_detail);//更新窗口
    202e:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
    2034:	8b 45 98             	mov    -0x68(%ebp),%eax
    2037:	89 54 24 08          	mov    %edx,0x8(%esp)
    203b:	89 44 24 04          	mov    %eax,0x4(%esp)
    203f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2042:	89 04 24             	mov    %eax,(%esp)
    2045:	e8 c8 21 00 00       	call   4212 <updateWindow>

			if (executeHandler(cm.left_click, p)) {//（暂时不懂）
    204a:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
    204d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
    2053:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
    2059:	89 44 24 04          	mov    %eax,0x4(%esp)
    205d:	89 54 24 08          	mov    %edx,0x8(%esp)
    2061:	89 0c 24             	mov    %ecx,(%esp)
    2064:	e8 7d 1a 00 00       	call   3ae6 <executeHandler>
    2069:	85 c0                	test   %eax,%eax
    206b:	74 21                	je     208e <main+0x5b0>

				updateWindow(winid, context.addr, msg.msg_detail);
    206d:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
    2073:	8b 45 98             	mov    -0x68(%ebp),%eax
    2076:	89 54 24 08          	mov    %edx,0x8(%esp)
    207a:	89 44 24 04          	mov    %eax,0x4(%esp)
    207e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2081:	89 04 24             	mov    %eax,(%esp)
    2084:	e8 89 21 00 00       	call   4212 <updateWindow>
			}
			break;
    2089:	e9 1b 02 00 00       	jmp    22a9 <main+0x7cb>
    208e:	e9 16 02 00 00       	jmp    22a9 <main+0x7cb>
		case MSG_RPRESS://鼠标右键按下
			p = initPoint(msg.concrete_msg.msg_mouse.x,
    2093:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
    2099:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
    209f:	8d 85 30 ff ff ff    	lea    -0xd0(%ebp),%eax
    20a5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    20a9:	89 54 24 04          	mov    %edx,0x4(%esp)
    20ad:	89 04 24             	mov    %eax,(%esp)
    20b0:	e8 27 17 00 00       	call   37dc <initPoint>
    20b5:	83 ec 04             	sub    $0x4,%esp
    20b8:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
    20be:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
    20c4:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
    20ca:	89 95 64 ff ff ff    	mov    %edx,-0x9c(%ebp)
					msg.concrete_msg.msg_mouse.y);
			if(isShowing == 0)
    20d0:	a1 00 ec 00 00       	mov    0xec00,%eax
    20d5:	85 c0                	test   %eax,%eax
    20d7:	75 39                	jne    2112 <main+0x634>
			{
				propertyShow(context, p.x, p.y);
    20d9:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
    20df:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
    20e5:	89 54 24 10          	mov    %edx,0x10(%esp)
    20e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
    20ed:	8b 45 98             	mov    -0x68(%ebp),%eax
    20f0:	89 04 24             	mov    %eax,(%esp)
    20f3:	8b 45 9c             	mov    -0x64(%ebp),%eax
    20f6:	89 44 24 04          	mov    %eax,0x4(%esp)
    20fa:	8b 45 a0             	mov    -0x60(%ebp),%eax
    20fd:	89 44 24 08          	mov    %eax,0x8(%esp)
    2101:	e8 f9 f5 ff ff       	call   16ff <propertyShow>
				isShowing = 1;
    2106:	c7 05 00 ec 00 00 01 	movl   $0x1,0xec00
    210d:	00 00 00 
    2110:	eb 56                	jmp    2168 <main+0x68a>
			}
			else if(isShowing == 1)
    2112:	a1 00 ec 00 00       	mov    0xec00,%eax
    2117:	83 f8 01             	cmp    $0x1,%eax
    211a:	75 4c                	jne    2168 <main+0x68a>
			{
				drawPicViewerWnd(context);
    211c:	8b 45 98             	mov    -0x68(%ebp),%eax
    211f:	89 04 24             	mov    %eax,(%esp)
    2122:	8b 45 9c             	mov    -0x64(%ebp),%eax
    2125:	89 44 24 04          	mov    %eax,0x4(%esp)
    2129:	8b 45 a0             	mov    -0x60(%ebp),%eax
    212c:	89 44 24 08          	mov    %eax,0x8(%esp)
    2130:	e8 e8 ed ff ff       	call   f1d <drawPicViewerWnd>
				drawPicViewerContentForProper(context, file[pos]);//背景里绘制图片
    2135:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
    213a:	8b 04 85 20 1a 01 00 	mov    0x11a20(,%eax,4),%eax
    2141:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2145:	8b 45 98             	mov    -0x68(%ebp),%eax
    2148:	89 04 24             	mov    %eax,(%esp)
    214b:	8b 45 9c             	mov    -0x64(%ebp),%eax
    214e:	89 44 24 04          	mov    %eax,0x4(%esp)
    2152:	8b 45 a0             	mov    -0x60(%ebp),%eax
    2155:	89 44 24 08          	mov    %eax,0x8(%esp)
    2159:	e8 7d f4 ff ff       	call   15db <drawPicViewerContentForProper>
				isShowing = 0;
    215e:	c7 05 00 ec 00 00 00 	movl   $0x0,0xec00
    2165:	00 00 00 
			}
			updateWindow(winid, context.addr, msg.msg_detail);//更新窗口
    2168:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
    216e:	8b 45 98             	mov    -0x68(%ebp),%eax
    2171:	89 54 24 08          	mov    %edx,0x8(%esp)
    2175:	89 44 24 04          	mov    %eax,0x4(%esp)
    2179:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    217c:	89 04 24             	mov    %eax,(%esp)
    217f:	e8 8e 20 00 00       	call   4212 <updateWindow>
			if (executeHandler(cm.right_click, p)) {
    2184:	8b 4d 8c             	mov    -0x74(%ebp),%ecx
    2187:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
    218d:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
    2193:	89 44 24 04          	mov    %eax,0x4(%esp)
    2197:	89 54 24 08          	mov    %edx,0x8(%esp)
    219b:	89 0c 24             	mov    %ecx,(%esp)
    219e:	e8 43 19 00 00       	call   3ae6 <executeHandler>
    21a3:	85 c0                	test   %eax,%eax
    21a5:	74 21                	je     21c8 <main+0x6ea>
				updateWindow(winid, context.addr, msg.msg_detail);
    21a7:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
    21ad:	8b 45 98             	mov    -0x68(%ebp),%eax
    21b0:	89 54 24 08          	mov    %edx,0x8(%esp)
    21b4:	89 44 24 04          	mov    %eax,0x4(%esp)
    21b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    21bb:	89 04 24             	mov    %eax,(%esp)
    21be:	e8 4f 20 00 00       	call   4212 <updateWindow>
			}
			break;
    21c3:	e9 e1 00 00 00       	jmp    22a9 <main+0x7cb>
    21c8:	e9 dc 00 00 00       	jmp    22a9 <main+0x7cb>
		case MSG_KEYDOWN:
			switch(msg.concrete_msg.msg_key.key) {
    21cd:	0f b6 85 70 ff ff ff 	movzbl -0x90(%ebp),%eax
    21d4:	0f be c0             	movsbl %al,%eax
    21d7:	83 f8 34             	cmp    $0x34,%eax
    21da:	74 18                	je     21f4 <main+0x716>
    21dc:	83 f8 34             	cmp    $0x34,%eax
    21df:	7f 07                	jg     21e8 <main+0x70a>
    21e1:	83 f8 32             	cmp    $0x32,%eax
    21e4:	74 3b                	je     2221 <main+0x743>
					break;
				case 50:
					Y_shift += shift_at_once;
					break;
				default:
					break;
    21e6:	eb 47                	jmp    222f <main+0x751>
			if (executeHandler(cm.right_click, p)) {
				updateWindow(winid, context.addr, msg.msg_detail);
			}
			break;
		case MSG_KEYDOWN:
			switch(msg.concrete_msg.msg_key.key) {
    21e8:	83 f8 36             	cmp    $0x36,%eax
    21eb:	74 16                	je     2203 <main+0x725>
    21ed:	83 f8 38             	cmp    $0x38,%eax
    21f0:	74 20                	je     2212 <main+0x734>
					break;
				case 50:
					Y_shift += shift_at_once;
					break;
				default:
					break;
    21f2:	eb 3b                	jmp    222f <main+0x751>
			}
			break;
		case MSG_KEYDOWN:
			switch(msg.concrete_msg.msg_key.key) {
				case 52:
					X_shift -= shift_at_once;
    21f4:	a1 0c ec 00 00       	mov    0xec0c,%eax
    21f9:	83 e8 05             	sub    $0x5,%eax
    21fc:	a3 0c ec 00 00       	mov    %eax,0xec0c
					break;
    2201:	eb 2c                	jmp    222f <main+0x751>
				case 54:
					X_shift += shift_at_once;
    2203:	a1 0c ec 00 00       	mov    0xec0c,%eax
    2208:	83 c0 05             	add    $0x5,%eax
    220b:	a3 0c ec 00 00       	mov    %eax,0xec0c
					break;
    2210:	eb 1d                	jmp    222f <main+0x751>
				case 56:
					Y_shift -= shift_at_once;
    2212:	a1 10 ec 00 00       	mov    0xec10,%eax
    2217:	83 e8 05             	sub    $0x5,%eax
    221a:	a3 10 ec 00 00       	mov    %eax,0xec10
					break;
    221f:	eb 0e                	jmp    222f <main+0x751>
				case 50:
					Y_shift += shift_at_once;
    2221:	a1 10 ec 00 00       	mov    0xec10,%eax
    2226:	83 c0 05             	add    $0x5,%eax
    2229:	a3 10 ec 00 00       	mov    %eax,0xec10
					break;
    222e:	90                   	nop
				default:
					break;
			}
			drawPicViewerWnd(context);
    222f:	8b 45 98             	mov    -0x68(%ebp),%eax
    2232:	89 04 24             	mov    %eax,(%esp)
    2235:	8b 45 9c             	mov    -0x64(%ebp),%eax
    2238:	89 44 24 04          	mov    %eax,0x4(%esp)
    223c:	8b 45 a0             	mov    -0x60(%ebp),%eax
    223f:	89 44 24 08          	mov    %eax,0x8(%esp)
    2243:	e8 d5 ec ff ff       	call   f1d <drawPicViewerWnd>
			drawPicViewerContent(context, file[pos]);
    2248:	a1 0c 1a 01 00       	mov    0x11a0c,%eax
    224d:	8b 04 85 20 1a 01 00 	mov    0x11a20(,%eax,4),%eax
    2254:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2258:	8b 45 98             	mov    -0x68(%ebp),%eax
    225b:	89 04 24             	mov    %eax,(%esp)
    225e:	8b 45 9c             	mov    -0x64(%ebp),%eax
    2261:	89 44 24 04          	mov    %eax,0x4(%esp)
    2265:	8b 45 a0             	mov    -0x60(%ebp),%eax
    2268:	89 44 24 08          	mov    %eax,0x8(%esp)
    226c:	e8 88 f2 ff ff       	call   14f9 <drawPicViewerContent>
			updateWindowWithoutBlank(context);
    2271:	8b 45 98             	mov    -0x68(%ebp),%eax
    2274:	89 04 24             	mov    %eax,(%esp)
    2277:	8b 45 9c             	mov    -0x64(%ebp),%eax
    227a:	89 44 24 04          	mov    %eax,0x4(%esp)
    227e:	8b 45 a0             	mov    -0x60(%ebp),%eax
    2281:	89 44 24 08          	mov    %eax,0x8(%esp)
    2285:	e8 8d ef ff ff       	call   1217 <updateWindowWithoutBlank>
			updateWindow(winid, context.addr, msg.msg_detail);
    228a:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
    2290:	8b 45 98             	mov    -0x68(%ebp),%eax
    2293:	89 54 24 08          	mov    %edx,0x8(%esp)
    2297:	89 44 24 04          	mov    %eax,0x4(%esp)
    229b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    229e:	89 04 24             	mov    %eax,(%esp)
    22a1:	e8 6c 1f 00 00       	call   4212 <updateWindow>
			break;
    22a6:	eb 01                	jmp    22a9 <main+0x7cb>
		default:
			break;
    22a8:	90                   	nop
    deleteClickable(&cm.left_click, initRect(0, 0, 800, 600));
    addWndEvent(&cm);//添加cm到窗口事件

    Initialize(context);

    while (isRun) {
    22a9:	a1 f8 e6 00 00       	mov    0xe6f8,%eax
    22ae:	85 c0                	test   %eax,%eax
    22b0:	0f 85 b5 fa ff ff    	jne    1d6b <main+0x28d>
			break;
		default:
			break;
		}
    }
    free_context(&context, winid);
    22b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    22b9:	89 44 24 04          	mov    %eax,0x4(%esp)
    22bd:	8d 45 98             	lea    -0x68(%ebp),%eax
    22c0:	89 04 24             	mov    %eax,(%esp)
    22c3:	e8 88 00 00 00       	call   2350 <free_context>
    exit();
    22c8:	e8 8d 1e 00 00       	call   415a <exit>

000022cd <init_context>:
#include "stat.h"
#include "user.h"
#include "drawingAPI.h"

int init_context(struct Context* context_ptr, int width, int height)
{
    22cd:	55                   	push   %ebp
    22ce:	89 e5                	mov    %esp,%ebp
    22d0:	83 ec 18             	sub    $0x18,%esp
    context_ptr->width = width;
    22d3:	8b 45 08             	mov    0x8(%ebp),%eax
    22d6:	8b 55 0c             	mov    0xc(%ebp),%edx
    22d9:	89 50 04             	mov    %edx,0x4(%eax)
    context_ptr->height = height;
    22dc:	8b 45 08             	mov    0x8(%ebp),%eax
    22df:	8b 55 10             	mov    0x10(%ebp),%edx
    22e2:	89 50 08             	mov    %edx,0x8(%eax)
    context_ptr->addr = (unsigned short*)malloc(sizeof(unsigned short) * width * height);
    22e5:	8b 55 0c             	mov    0xc(%ebp),%edx
    22e8:	8b 45 10             	mov    0x10(%ebp),%eax
    22eb:	0f af c2             	imul   %edx,%eax
    22ee:	01 c0                	add    %eax,%eax
    22f0:	89 04 24             	mov    %eax,(%esp)
    22f3:	e8 36 23 00 00       	call   462e <malloc>
    22f8:	8b 55 08             	mov    0x8(%ebp),%edx
    22fb:	89 02                	mov    %eax,(%edx)
    memset(context_ptr->addr, 0, sizeof(unsigned short) * width * height);
    22fd:	8b 55 0c             	mov    0xc(%ebp),%edx
    2300:	8b 45 10             	mov    0x10(%ebp),%eax
    2303:	0f af c2             	imul   %edx,%eax
    2306:	8d 14 00             	lea    (%eax,%eax,1),%edx
    2309:	8b 45 08             	mov    0x8(%ebp),%eax
    230c:	8b 00                	mov    (%eax),%eax
    230e:	89 54 24 08          	mov    %edx,0x8(%esp)
    2312:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2319:	00 
    231a:	89 04 24             	mov    %eax,(%esp)
    231d:	e8 8b 1c 00 00       	call   3fad <memset>
    initializeASCII();
    2322:	e8 93 01 00 00       	call   24ba <initializeASCII>
    initializeGBK();
    2327:	e8 17 03 00 00       	call   2643 <initializeGBK>
    return createWindow(0, 0, width, height);
    232c:	8b 45 10             	mov    0x10(%ebp),%eax
    232f:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2333:	8b 45 0c             	mov    0xc(%ebp),%eax
    2336:	89 44 24 08          	mov    %eax,0x8(%esp)
    233a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2341:	00 
    2342:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2349:	e8 b4 1e 00 00       	call   4202 <createWindow>
}
    234e:	c9                   	leave  
    234f:	c3                   	ret    

00002350 <free_context>:

void free_context(struct Context* context_ptr, int winid)
{
    2350:	55                   	push   %ebp
    2351:	89 e5                	mov    %esp,%ebp
    2353:	83 ec 18             	sub    $0x18,%esp
    free(context_ptr->addr);
    2356:	8b 45 08             	mov    0x8(%ebp),%eax
    2359:	8b 00                	mov    (%eax),%eax
    235b:	89 04 24             	mov    %eax,(%esp)
    235e:	e8 92 21 00 00       	call   44f5 <free>
    freeASCII();
    2363:	e8 c6 02 00 00       	call   262e <freeASCII>
    freeGBK();
    2368:	e8 7e 03 00 00       	call   26eb <freeGBK>
    destroyWindow(winid);
    236d:	8b 45 0c             	mov    0xc(%ebp),%eax
    2370:	89 04 24             	mov    %eax,(%esp)
    2373:	e8 92 1e 00 00       	call   420a <destroyWindow>
}
    2378:	c9                   	leave  
    2379:	c3                   	ret    

0000237a <draw_point>:
*             then do nothing!
*/

void
draw_point(struct Context c, unsigned int x, unsigned int y, unsigned short color)
{
    237a:	55                   	push   %ebp
    237b:	89 e5                	mov    %esp,%ebp
    237d:	83 ec 04             	sub    $0x4,%esp
    2380:	8b 45 1c             	mov    0x1c(%ebp),%eax
    2383:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  if(x >= c.width)
    2387:	8b 45 0c             	mov    0xc(%ebp),%eax
    238a:	3b 45 14             	cmp    0x14(%ebp),%eax
    238d:	77 02                	ja     2391 <draw_point+0x17>
    return;
    238f:	eb 26                	jmp    23b7 <draw_point+0x3d>
  if(y >= c.height)
    2391:	8b 45 10             	mov    0x10(%ebp),%eax
    2394:	3b 45 18             	cmp    0x18(%ebp),%eax
    2397:	77 02                	ja     239b <draw_point+0x21>
    return;
    2399:	eb 1c                	jmp    23b7 <draw_point+0x3d>
  c.addr[y*c.width+x] = color;
    239b:	8b 55 08             	mov    0x8(%ebp),%edx
    239e:	8b 45 0c             	mov    0xc(%ebp),%eax
    23a1:	0f af 45 18          	imul   0x18(%ebp),%eax
    23a5:	89 c1                	mov    %eax,%ecx
    23a7:	8b 45 14             	mov    0x14(%ebp),%eax
    23aa:	01 c8                	add    %ecx,%eax
    23ac:	01 c0                	add    %eax,%eax
    23ae:	01 c2                	add    %eax,%edx
    23b0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    23b4:	66 89 02             	mov    %ax,(%edx)
}
    23b7:	c9                   	leave  
    23b8:	c3                   	ret    

000023b9 <fill_rect>:
/*
*fill_rect: set a rect area with a certain color
*/
void
fill_rect(struct Context c, unsigned int bx, unsigned int by, unsigned int width, unsigned int height, unsigned short color)
{
    23b9:	55                   	push   %ebp
    23ba:	89 e5                	mov    %esp,%ebp
    23bc:	83 ec 2c             	sub    $0x2c,%esp
    23bf:	8b 45 24             	mov    0x24(%ebp),%eax
    23c2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
	int x, y;
	int mx = c.width < bx + width ? c.width : bx + width;
    23c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
    23c9:	8b 55 14             	mov    0x14(%ebp),%edx
    23cc:	01 c2                	add    %eax,%edx
    23ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    23d1:	39 c2                	cmp    %eax,%edx
    23d3:	0f 46 c2             	cmovbe %edx,%eax
    23d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int my = c.height < by + height ? c.height : by + height;
    23d9:	8b 45 20             	mov    0x20(%ebp),%eax
    23dc:	8b 55 18             	mov    0x18(%ebp),%edx
    23df:	01 c2                	add    %eax,%edx
    23e1:	8b 45 10             	mov    0x10(%ebp),%eax
    23e4:	39 c2                	cmp    %eax,%edx
    23e6:	0f 46 c2             	cmovbe %edx,%eax
    23e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (y = by; y < my; y++)
    23ec:	8b 45 18             	mov    0x18(%ebp),%eax
    23ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
    23f2:	eb 47                	jmp    243b <fill_rect+0x82>
	{
		for (x = bx; x < mx; x++)
    23f4:	8b 45 14             	mov    0x14(%ebp),%eax
    23f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    23fa:	eb 33                	jmp    242f <fill_rect+0x76>
		{
			draw_point(c, x, y, color);
    23fc:	0f b7 4d ec          	movzwl -0x14(%ebp),%ecx
    2400:	8b 55 f8             	mov    -0x8(%ebp),%edx
    2403:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2406:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    240a:	89 54 24 10          	mov    %edx,0x10(%esp)
    240e:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2412:	8b 45 08             	mov    0x8(%ebp),%eax
    2415:	89 04 24             	mov    %eax,(%esp)
    2418:	8b 45 0c             	mov    0xc(%ebp),%eax
    241b:	89 44 24 04          	mov    %eax,0x4(%esp)
    241f:	8b 45 10             	mov    0x10(%ebp),%eax
    2422:	89 44 24 08          	mov    %eax,0x8(%esp)
    2426:	e8 4f ff ff ff       	call   237a <draw_point>
	int x, y;
	int mx = c.width < bx + width ? c.width : bx + width;
	int my = c.height < by + height ? c.height : by + height;
	for (y = by; y < my; y++)
	{
		for (x = bx; x < mx; x++)
    242b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    242f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2432:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2435:	7c c5                	jl     23fc <fill_rect+0x43>
fill_rect(struct Context c, unsigned int bx, unsigned int by, unsigned int width, unsigned int height, unsigned short color)
{
	int x, y;
	int mx = c.width < bx + width ? c.width : bx + width;
	int my = c.height < by + height ? c.height : by + height;
	for (y = by; y < my; y++)
    2437:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    243b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    243e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    2441:	7c b1                	jl     23f4 <fill_rect+0x3b>
		for (x = bx; x < mx; x++)
		{
			draw_point(c, x, y, color);
		}
	}
}
    2443:	c9                   	leave  
    2444:	c3                   	ret    

00002445 <printBinary>:

void printBinary(char c)
{
    2445:	55                   	push   %ebp
    2446:	89 e5                	mov    %esp,%ebp
    2448:	83 ec 28             	sub    $0x28,%esp
    244b:	8b 45 08             	mov    0x8(%ebp),%eax
    244e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	int i;
	for (i = 0; i < 8; i++)
    2451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2458:	eb 44                	jmp    249e <printBinary+0x59>
	{
		if(((c << i) & 0x80) != 0)
    245a:	0f be 55 e4          	movsbl -0x1c(%ebp),%edx
    245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2461:	89 c1                	mov    %eax,%ecx
    2463:	d3 e2                	shl    %cl,%edx
    2465:	89 d0                	mov    %edx,%eax
    2467:	25 80 00 00 00       	and    $0x80,%eax
    246c:	85 c0                	test   %eax,%eax
    246e:	74 16                	je     2486 <printBinary+0x41>
		{
			printf(0, "1");
    2470:	c7 44 24 04 d0 ab 00 	movl   $0xabd0,0x4(%esp)
    2477:	00 
    2478:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    247f:	e8 be 1e 00 00       	call   4342 <printf>
    2484:	eb 14                	jmp    249a <printBinary+0x55>
		}
		else
		{
			printf(0, "0");
    2486:	c7 44 24 04 d2 ab 00 	movl   $0xabd2,0x4(%esp)
    248d:	00 
    248e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2495:	e8 a8 1e 00 00       	call   4342 <printf>
}

void printBinary(char c)
{
	int i;
	for (i = 0; i < 8; i++)
    249a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    249e:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
    24a2:	7e b6                	jle    245a <printBinary+0x15>
		{
			printf(0, "0");
		}
	}

	printf(0, "\n");
    24a4:	c7 44 24 04 d4 ab 00 	movl   $0xabd4,0x4(%esp)
    24ab:	00 
    24ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24b3:	e8 8a 1e 00 00       	call   4342 <printf>
}
    24b8:	c9                   	leave  
    24b9:	c3                   	ret    

000024ba <initializeASCII>:
char buf[512];
//hankaku是一个数组，将hankaku.txt文件中的每一行转化成一个8位整数（unsigned short）
//每16个整数可以代表一个字符
unsigned char *hankaku;
void initializeASCII()
{
    24ba:	55                   	push   %ebp
    24bb:	89 e5                	mov    %esp,%ebp
    24bd:	56                   	push   %esi
    24be:	53                   	push   %ebx
    24bf:	83 ec 30             	sub    $0x30,%esp

	int fd, n, i;
	int x, y;
	printf(0,"initialzing ASCII\n");
    24c2:	c7 44 24 04 d6 ab 00 	movl   $0xabd6,0x4(%esp)
    24c9:	00 
    24ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24d1:	e8 6c 1e 00 00       	call   4342 <printf>
	//打开hankaku.txt文件
	if((fd = open(HANKAKU, 0)) < 0){
    24d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    24dd:	00 
    24de:	c7 04 24 e9 ab 00 00 	movl   $0xabe9,(%esp)
    24e5:	e8 b0 1c 00 00       	call   419a <open>
    24ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
    24ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    24f1:	79 21                	jns    2514 <initializeASCII+0x5a>
	  printf(0,"cannot open %s\n", HANKAKU);
    24f3:	c7 44 24 08 e9 ab 00 	movl   $0xabe9,0x8(%esp)
    24fa:	00 
    24fb:	c7 44 24 04 f5 ab 00 	movl   $0xabf5,0x4(%esp)
    2502:	00 
    2503:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    250a:	e8 33 1e 00 00       	call   4342 <printf>
	  return;
    250f:	e9 13 01 00 00       	jmp    2627 <initializeASCII+0x16d>
	}
	//申请hankaku数组
	hankaku = malloc(ASCII_NUM*ASCII_HEIGHT);
    2514:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    251b:	e8 0e 21 00 00       	call   462e <malloc>
    2520:	a3 c0 1b 01 00       	mov    %eax,0x11bc0
	for (i = 0; i < ASCII_NUM; i++)
    2525:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    252c:	eb 12                	jmp    2540 <initializeASCII+0x86>
	{
		hankaku[i] = 0;
    252e:	8b 15 c0 1b 01 00    	mov    0x11bc0,%edx
    2534:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2537:	01 d0                	add    %edx,%eax
    2539:	c6 00 00             	movb   $0x0,(%eax)
	  printf(0,"cannot open %s\n", HANKAKU);
	  return;
	}
	//申请hankaku数组
	hankaku = malloc(ASCII_NUM*ASCII_HEIGHT);
	for (i = 0; i < ASCII_NUM; i++)
    253c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2540:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
    2547:	7e e5                	jle    252e <initializeASCII+0x74>

	//不断读取文件，如果读到的字符是“*/."，就按顺序记录到hankaku数组中
	//y表示当前记录到第几行（对应于hankaku数组里的第几个数），x表示当前记录到第几列
	//如果当前字符是"*",则对应第y个数第x位置为1
	//每当x == ASCII_WIDTH，x重新置为0, y++
	x = 0;
    2549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	y = 0;
    2550:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	while((n = read(fd, buf, sizeof(buf))) > 0)
    2557:	e9 84 00 00 00       	jmp    25e0 <initializeASCII+0x126>
	{
		for (i = 0; i < n; i++){
    255c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2563:	eb 73                	jmp    25d8 <initializeASCII+0x11e>
			//printf(0,"%c, %d", buf[i], i);
			if (buf[i] == '*' || buf[i] == '.')
    2565:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2568:	05 e0 1b 01 00       	add    $0x11be0,%eax
    256d:	0f b6 00             	movzbl (%eax),%eax
    2570:	3c 2a                	cmp    $0x2a,%al
    2572:	74 0f                	je     2583 <initializeASCII+0xc9>
    2574:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2577:	05 e0 1b 01 00       	add    $0x11be0,%eax
    257c:	0f b6 00             	movzbl (%eax),%eax
    257f:	3c 2e                	cmp    $0x2e,%al
    2581:	75 51                	jne    25d4 <initializeASCII+0x11a>
			{
				if (buf[i] == '*')
    2583:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2586:	05 e0 1b 01 00       	add    $0x11be0,%eax
    258b:	0f b6 00             	movzbl (%eax),%eax
    258e:	3c 2a                	cmp    $0x2a,%al
    2590:	75 2d                	jne    25bf <initializeASCII+0x105>
				{
					hankaku[y] |= (0x80 >> x);
    2592:	8b 15 c0 1b 01 00    	mov    0x11bc0,%edx
    2598:	8b 45 ec             	mov    -0x14(%ebp),%eax
    259b:	01 c2                	add    %eax,%edx
    259d:	8b 0d c0 1b 01 00    	mov    0x11bc0,%ecx
    25a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    25a6:	01 c8                	add    %ecx,%eax
    25a8:	0f b6 00             	movzbl (%eax),%eax
    25ab:	89 c3                	mov    %eax,%ebx
    25ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
    25b0:	be 80 00 00 00       	mov    $0x80,%esi
    25b5:	89 c1                	mov    %eax,%ecx
    25b7:	d3 fe                	sar    %cl,%esi
    25b9:	89 f0                	mov    %esi,%eax
    25bb:	09 d8                	or     %ebx,%eax
    25bd:	88 02                	mov    %al,(%edx)
				}
				x ++;
    25bf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
				if (x >= ASCII_WIDTH)
    25c3:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
    25c7:	7e 0b                	jle    25d4 <initializeASCII+0x11a>
				{
					x = 0;
    25c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
					y ++;
    25d0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
	//每当x == ASCII_WIDTH，x重新置为0, y++
	x = 0;
	y = 0;
	while((n = read(fd, buf, sizeof(buf))) > 0)
	{
		for (i = 0; i < n; i++){
    25d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    25d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25db:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
    25de:	7c 85                	jl     2565 <initializeASCII+0xab>
	//y表示当前记录到第几行（对应于hankaku数组里的第几个数），x表示当前记录到第几列
	//如果当前字符是"*",则对应第y个数第x位置为1
	//每当x == ASCII_WIDTH，x重新置为0, y++
	x = 0;
	y = 0;
	while((n = read(fd, buf, sizeof(buf))) > 0)
    25e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    25e7:	00 
    25e8:	c7 44 24 04 e0 1b 01 	movl   $0x11be0,0x4(%esp)
    25ef:	00 
    25f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    25f3:	89 04 24             	mov    %eax,(%esp)
    25f6:	e8 77 1b 00 00       	call   4172 <read>
    25fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    25fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    2602:	0f 8f 54 ff ff ff    	jg     255c <initializeASCII+0xa2>

//	for (i = 0; i < ASCII_NUM * ASCII_HEIGHT; i++)
//	{
//		printBinary(hankaku[i]);
//	}
	printf(0,"initialzing ASCII complete!\n");
    2608:	c7 44 24 04 05 ac 00 	movl   $0xac05,0x4(%esp)
    260f:	00 
    2610:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2617:	e8 26 1d 00 00       	call   4342 <printf>
	close(fd);
    261c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    261f:	89 04 24             	mov    %eax,(%esp)
    2622:	e8 5b 1b 00 00       	call   4182 <close>
}
    2627:	83 c4 30             	add    $0x30,%esp
    262a:	5b                   	pop    %ebx
    262b:	5e                   	pop    %esi
    262c:	5d                   	pop    %ebp
    262d:	c3                   	ret    

0000262e <freeASCII>:

void freeASCII(){
    262e:	55                   	push   %ebp
    262f:	89 e5                	mov    %esp,%ebp
    2631:	83 ec 18             	sub    $0x18,%esp
	free(hankaku);
    2634:	a1 c0 1b 01 00       	mov    0x11bc0,%eax
    2639:	89 04 24             	mov    %eax,(%esp)
    263c:	e8 b4 1e 00 00       	call   44f5 <free>
}
    2641:	c9                   	leave  
    2642:	c3                   	ret    

00002643 <initializeGBK>:

struct File_Node fontFile;
void initializeGBK(){
    2643:	55                   	push   %ebp
    2644:	89 e5                	mov    %esp,%ebp
    2646:	83 ec 28             	sub    $0x28,%esp
	int fd;
	printf(0,"initialzing gbk\n");
    2649:	c7 44 24 04 22 ac 00 	movl   $0xac22,0x4(%esp)
    2650:	00 
    2651:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2658:	e8 e5 1c 00 00       	call   4342 <printf>
	if((fd = open(HZK16, 0)) < 0){
    265d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2664:	00 
    2665:	c7 04 24 33 ac 00 00 	movl   $0xac33,(%esp)
    266c:	e8 29 1b 00 00       	call   419a <open>
    2671:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2678:	79 1e                	jns    2698 <initializeGBK+0x55>
		printf(0,"cannot open %s\n", HZK16);
    267a:	c7 44 24 08 33 ac 00 	movl   $0xac33,0x8(%esp)
    2681:	00 
    2682:	c7 44 24 04 f5 ab 00 	movl   $0xabf5,0x4(%esp)
    2689:	00 
    268a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2691:	e8 ac 1c 00 00       	call   4342 <printf>
		return;
    2696:	eb 51                	jmp    26e9 <initializeGBK+0xa6>
	}
	fontFile.buf = malloc(27000*sizeof(unsigned char));
    2698:	c7 04 24 78 69 00 00 	movl   $0x6978,(%esp)
    269f:	e8 8a 1f 00 00       	call   462e <malloc>
    26a4:	a3 c4 1b 01 00       	mov    %eax,0x11bc4
	fontFile.size = read(fd, fontFile.buf, 27000);
    26a9:	a1 c4 1b 01 00       	mov    0x11bc4,%eax
    26ae:	c7 44 24 08 78 69 00 	movl   $0x6978,0x8(%esp)
    26b5:	00 
    26b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    26ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26bd:	89 04 24             	mov    %eax,(%esp)
    26c0:	e8 ad 1a 00 00       	call   4172 <read>
    26c5:	a3 c8 1b 01 00       	mov    %eax,0x11bc8
	printf(0,"initialzing gbk complete!\n");
    26ca:	c7 44 24 04 3d ac 00 	movl   $0xac3d,0x4(%esp)
    26d1:	00 
    26d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    26d9:	e8 64 1c 00 00       	call   4342 <printf>
	close(fd);
    26de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26e1:	89 04 24             	mov    %eax,(%esp)
    26e4:	e8 99 1a 00 00       	call   4182 <close>
}
    26e9:	c9                   	leave  
    26ea:	c3                   	ret    

000026eb <freeGBK>:

void freeGBK(){
    26eb:	55                   	push   %ebp
    26ec:	89 e5                	mov    %esp,%ebp
    26ee:	83 ec 18             	sub    $0x18,%esp
	free(fontFile.buf);
    26f1:	a1 c4 1b 01 00       	mov    0x11bc4,%eax
    26f6:	89 04 24             	mov    %eax,(%esp)
    26f9:	e8 f7 1d 00 00       	call   44f5 <free>
}
    26fe:	c9                   	leave  
    26ff:	c3                   	ret    

00002700 <put_ascii>:

void put_ascii(struct Context c, unsigned char ascii, unsigned short colorNum, int x, int y)
{
    2700:	55                   	push   %ebp
    2701:	89 e5                	mov    %esp,%ebp
    2703:	53                   	push   %ebx
    2704:	83 ec 30             	sub    $0x30,%esp
    2707:	8b 55 14             	mov    0x14(%ebp),%edx
    270a:	8b 45 18             	mov    0x18(%ebp),%eax
    270d:	88 55 e8             	mov    %dl,-0x18(%ebp)
    2710:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
	int tmpX, tmpY;
	//printf(0, "put ascii: %c, color: %d\n", ascii, colorNum);
	for(tmpY = y; tmpY < y + 16; tmpY++) {
    2714:	8b 45 20             	mov    0x20(%ebp),%eax
    2717:	89 45 f4             	mov    %eax,-0xc(%ebp)
    271a:	eb 7f                	jmp    279b <put_ascii+0x9b>
		for(tmpX = 0; tmpX < 8; tmpX++) {
    271c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    2723:	eb 6c                	jmp    2791 <put_ascii+0x91>
			if((((hankaku + (ascii * 16))[tmpY - y] << tmpX) & 0x80) == 0x80) {
    2725:	a1 c0 1b 01 00       	mov    0x11bc0,%eax
    272a:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    272e:	c1 e2 04             	shl    $0x4,%edx
    2731:	89 d1                	mov    %edx,%ecx
    2733:	8b 55 20             	mov    0x20(%ebp),%edx
    2736:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    2739:	29 d3                	sub    %edx,%ebx
    273b:	89 da                	mov    %ebx,%edx
    273d:	01 ca                	add    %ecx,%edx
    273f:	01 d0                	add    %edx,%eax
    2741:	0f b6 00             	movzbl (%eax),%eax
    2744:	0f b6 d0             	movzbl %al,%edx
    2747:	8b 45 f8             	mov    -0x8(%ebp),%eax
    274a:	89 c1                	mov    %eax,%ecx
    274c:	d3 e2                	shl    %cl,%edx
    274e:	89 d0                	mov    %edx,%eax
    2750:	25 80 00 00 00       	and    $0x80,%eax
    2755:	85 c0                	test   %eax,%eax
    2757:	74 34                	je     278d <put_ascii+0x8d>
				//printf(0, "x: %d, y: %d\n", x + tmpX, tmpY);
				draw_point(c, x + tmpX, tmpY, colorNum);
    2759:	0f b7 4d e4          	movzwl -0x1c(%ebp),%ecx
    275d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2760:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2763:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
    2766:	01 d8                	add    %ebx,%eax
    2768:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    276c:	89 54 24 10          	mov    %edx,0x10(%esp)
    2770:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2774:	8b 45 08             	mov    0x8(%ebp),%eax
    2777:	89 04 24             	mov    %eax,(%esp)
    277a:	8b 45 0c             	mov    0xc(%ebp),%eax
    277d:	89 44 24 04          	mov    %eax,0x4(%esp)
    2781:	8b 45 10             	mov    0x10(%ebp),%eax
    2784:	89 44 24 08          	mov    %eax,0x8(%esp)
    2788:	e8 ed fb ff ff       	call   237a <draw_point>
void put_ascii(struct Context c, unsigned char ascii, unsigned short colorNum, int x, int y)
{
	int tmpX, tmpY;
	//printf(0, "put ascii: %c, color: %d\n", ascii, colorNum);
	for(tmpY = y; tmpY < y + 16; tmpY++) {
		for(tmpX = 0; tmpX < 8; tmpX++) {
    278d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    2791:	83 7d f8 07          	cmpl   $0x7,-0x8(%ebp)
    2795:	7e 8e                	jle    2725 <put_ascii+0x25>

void put_ascii(struct Context c, unsigned char ascii, unsigned short colorNum, int x, int y)
{
	int tmpX, tmpY;
	//printf(0, "put ascii: %c, color: %d\n", ascii, colorNum);
	for(tmpY = y; tmpY < y + 16; tmpY++) {
    2797:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    279b:	8b 45 20             	mov    0x20(%ebp),%eax
    279e:	83 c0 10             	add    $0x10,%eax
    27a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    27a4:	0f 8f 72 ff ff ff    	jg     271c <put_ascii+0x1c>
				draw_point(c, x + tmpX, tmpY, colorNum);
				//sheet->buf[tmpY * sheet->width + x + tmpX] = colorNum;
			}
		}
	}
}
    27aa:	83 c4 30             	add    $0x30,%esp
    27ad:	5b                   	pop    %ebx
    27ae:	5d                   	pop    %ebp
    27af:	c3                   	ret    

000027b0 <put_gbk>:

void put_gbk(struct Context c, short gbk, unsigned short colorNum, int x, int y)
{
    27b0:	55                   	push   %ebp
    27b1:	89 e5                	mov    %esp,%ebp
    27b3:	53                   	push   %ebx
    27b4:	83 ec 34             	sub    $0x34,%esp
    27b7:	8b 55 14             	mov    0x14(%ebp),%edx
    27ba:	8b 45 18             	mov    0x18(%ebp),%eax
    27bd:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
    27c1:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
	int tmpX, tmpY;
	unsigned int offset;
	unsigned char *hzk16Base;
	if((gbk & 0x00FF) >= 0xA1 && ((gbk >> 8) & 0x00FF) >= 0xA1) {
    27c5:	0f bf 45 e8          	movswl -0x18(%ebp),%eax
    27c9:	0f b6 c0             	movzbl %al,%eax
    27cc:	3d a0 00 00 00       	cmp    $0xa0,%eax
    27d1:	0f 8e 40 01 00 00    	jle    2917 <put_gbk+0x167>
    27d7:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
    27db:	66 c1 f8 08          	sar    $0x8,%ax
    27df:	98                   	cwtl   
    27e0:	0f b6 c0             	movzbl %al,%eax
    27e3:	3d a0 00 00 00       	cmp    $0xa0,%eax
    27e8:	0f 8e 29 01 00 00    	jle    2917 <put_gbk+0x167>
		hzk16Base = fontFile.buf;
    27ee:	a1 c4 1b 01 00       	mov    0x11bc4,%eax
    27f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		offset = (((gbk & 0x00FF) - 0xa1) * 94 + (((gbk >> 8) & 0x00FF) - 0xa1)) * 32;
    27f6:	0f bf 45 e8          	movswl -0x18(%ebp),%eax
    27fa:	0f b6 c0             	movzbl %al,%eax
    27fd:	2d a1 00 00 00       	sub    $0xa1,%eax
    2802:	6b c0 5e             	imul   $0x5e,%eax,%eax
    2805:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
    2809:	66 c1 fa 08          	sar    $0x8,%dx
    280d:	0f bf d2             	movswl %dx,%edx
    2810:	0f b6 d2             	movzbl %dl,%edx
    2813:	81 ea a1 00 00 00    	sub    $0xa1,%edx
    2819:	01 d0                	add    %edx,%eax
    281b:	c1 e0 05             	shl    $0x5,%eax
    281e:	89 45 f0             	mov    %eax,-0x10(%ebp)

		for(tmpY = y; tmpY < 16 + y; tmpY++) {
    2821:	8b 45 20             	mov    0x20(%ebp),%eax
    2824:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2827:	e9 da 00 00 00       	jmp    2906 <put_gbk+0x156>
			for(tmpX = 0; tmpX < 8; tmpX++) {
    282c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    2833:	eb 58                	jmp    288d <put_gbk+0xdd>
				if(((hzk16Base[offset] << tmpX) & 0x80) == 0x80) {
    2835:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2838:	8b 55 ec             	mov    -0x14(%ebp),%edx
    283b:	01 d0                	add    %edx,%eax
    283d:	0f b6 00             	movzbl (%eax),%eax
    2840:	0f b6 d0             	movzbl %al,%edx
    2843:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2846:	89 c1                	mov    %eax,%ecx
    2848:	d3 e2                	shl    %cl,%edx
    284a:	89 d0                	mov    %edx,%eax
    284c:	25 80 00 00 00       	and    $0x80,%eax
    2851:	85 c0                	test   %eax,%eax
    2853:	74 34                	je     2889 <put_gbk+0xd9>
					draw_point(c, x + tmpX, tmpY, colorNum);
    2855:	0f b7 4d e4          	movzwl -0x1c(%ebp),%ecx
    2859:	8b 55 f4             	mov    -0xc(%ebp),%edx
    285c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    285f:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
    2862:	01 d8                	add    %ebx,%eax
    2864:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    2868:	89 54 24 10          	mov    %edx,0x10(%esp)
    286c:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2870:	8b 45 08             	mov    0x8(%ebp),%eax
    2873:	89 04 24             	mov    %eax,(%esp)
    2876:	8b 45 0c             	mov    0xc(%ebp),%eax
    2879:	89 44 24 04          	mov    %eax,0x4(%esp)
    287d:	8b 45 10             	mov    0x10(%ebp),%eax
    2880:	89 44 24 08          	mov    %eax,0x8(%esp)
    2884:	e8 f1 fa ff ff       	call   237a <draw_point>
	if((gbk & 0x00FF) >= 0xA1 && ((gbk >> 8) & 0x00FF) >= 0xA1) {
		hzk16Base = fontFile.buf;
		offset = (((gbk & 0x00FF) - 0xa1) * 94 + (((gbk >> 8) & 0x00FF) - 0xa1)) * 32;

		for(tmpY = y; tmpY < 16 + y; tmpY++) {
			for(tmpX = 0; tmpX < 8; tmpX++) {
    2889:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    288d:	83 7d f8 07          	cmpl   $0x7,-0x8(%ebp)
    2891:	7e a2                	jle    2835 <put_gbk+0x85>
				if(((hzk16Base[offset] << tmpX) & 0x80) == 0x80) {
					draw_point(c, x + tmpX, tmpY, colorNum);
					//sheet->buf[tmpY * sheet->width + x + tmpX] = colorNum;
				}
			}
			offset++;
    2893:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			for(tmpX = 0; tmpX < 8; tmpX++) {
    2897:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    289e:	eb 58                	jmp    28f8 <put_gbk+0x148>
				if(((hzk16Base[offset] << tmpX) & 0x80) == 0x80) {
    28a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    28a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    28a6:	01 d0                	add    %edx,%eax
    28a8:	0f b6 00             	movzbl (%eax),%eax
    28ab:	0f b6 d0             	movzbl %al,%edx
    28ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
    28b1:	89 c1                	mov    %eax,%ecx
    28b3:	d3 e2                	shl    %cl,%edx
    28b5:	89 d0                	mov    %edx,%eax
    28b7:	25 80 00 00 00       	and    $0x80,%eax
    28bc:	85 c0                	test   %eax,%eax
    28be:	74 34                	je     28f4 <put_gbk+0x144>
					draw_point(c, x + tmpX, tmpY, colorNum);
    28c0:	0f b7 4d e4          	movzwl -0x1c(%ebp),%ecx
    28c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    28c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    28ca:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
    28cd:	01 d8                	add    %ebx,%eax
    28cf:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    28d3:	89 54 24 10          	mov    %edx,0x10(%esp)
    28d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
    28db:	8b 45 08             	mov    0x8(%ebp),%eax
    28de:	89 04 24             	mov    %eax,(%esp)
    28e1:	8b 45 0c             	mov    0xc(%ebp),%eax
    28e4:	89 44 24 04          	mov    %eax,0x4(%esp)
    28e8:	8b 45 10             	mov    0x10(%ebp),%eax
    28eb:	89 44 24 08          	mov    %eax,0x8(%esp)
    28ef:	e8 86 fa ff ff       	call   237a <draw_point>
					draw_point(c, x + tmpX, tmpY, colorNum);
					//sheet->buf[tmpY * sheet->width + x + tmpX] = colorNum;
				}
			}
			offset++;
			for(tmpX = 0; tmpX < 8; tmpX++) {
    28f4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    28f8:	83 7d f8 07          	cmpl   $0x7,-0x8(%ebp)
    28fc:	7e a2                	jle    28a0 <put_gbk+0xf0>
				if(((hzk16Base[offset] << tmpX) & 0x80) == 0x80) {
					draw_point(c, x + tmpX, tmpY, colorNum);
					//sheet->buf[tmpY * sheet->width + x + tmpX + 8] = colorNum;
				}
			}
			offset++;
    28fe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
	unsigned char *hzk16Base;
	if((gbk & 0x00FF) >= 0xA1 && ((gbk >> 8) & 0x00FF) >= 0xA1) {
		hzk16Base = fontFile.buf;
		offset = (((gbk & 0x00FF) - 0xa1) * 94 + (((gbk >> 8) & 0x00FF) - 0xa1)) * 32;

		for(tmpY = y; tmpY < 16 + y; tmpY++) {
    2902:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2906:	8b 45 20             	mov    0x20(%ebp),%eax
    2909:	83 c0 10             	add    $0x10,%eax
    290c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    290f:	0f 8f 17 ff ff ff    	jg     282c <put_gbk+0x7c>
void put_gbk(struct Context c, short gbk, unsigned short colorNum, int x, int y)
{
	int tmpX, tmpY;
	unsigned int offset;
	unsigned char *hzk16Base;
	if((gbk & 0x00FF) >= 0xA1 && ((gbk >> 8) & 0x00FF) >= 0xA1) {
    2915:	eb 7b                	jmp    2992 <put_gbk+0x1e2>
			}
			offset++;
		}
	}
	else {
		put_ascii(c, (gbk & 0x00FF), colorNum, x, y);
    2917:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
    291b:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
    291f:	0f b6 c0             	movzbl %al,%eax
    2922:	8b 4d 20             	mov    0x20(%ebp),%ecx
    2925:	89 4c 24 18          	mov    %ecx,0x18(%esp)
    2929:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
    292c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    2930:	89 54 24 10          	mov    %edx,0x10(%esp)
    2934:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2938:	8b 45 08             	mov    0x8(%ebp),%eax
    293b:	89 04 24             	mov    %eax,(%esp)
    293e:	8b 45 0c             	mov    0xc(%ebp),%eax
    2941:	89 44 24 04          	mov    %eax,0x4(%esp)
    2945:	8b 45 10             	mov    0x10(%ebp),%eax
    2948:	89 44 24 08          	mov    %eax,0x8(%esp)
    294c:	e8 af fd ff ff       	call   2700 <put_ascii>
		put_ascii(c, ((gbk >> 8) & 0x00FF), colorNum, x + 8, y);
    2951:	8b 45 1c             	mov    0x1c(%ebp),%eax
    2954:	8d 58 08             	lea    0x8(%eax),%ebx
    2957:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
    295b:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
    295f:	66 c1 f8 08          	sar    $0x8,%ax
    2963:	0f b6 c0             	movzbl %al,%eax
    2966:	8b 4d 20             	mov    0x20(%ebp),%ecx
    2969:	89 4c 24 18          	mov    %ecx,0x18(%esp)
    296d:	89 5c 24 14          	mov    %ebx,0x14(%esp)
    2971:	89 54 24 10          	mov    %edx,0x10(%esp)
    2975:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2979:	8b 45 08             	mov    0x8(%ebp),%eax
    297c:	89 04 24             	mov    %eax,(%esp)
    297f:	8b 45 0c             	mov    0xc(%ebp),%eax
    2982:	89 44 24 04          	mov    %eax,0x4(%esp)
    2986:	8b 45 10             	mov    0x10(%ebp),%eax
    2989:	89 44 24 08          	mov    %eax,0x8(%esp)
    298d:	e8 6e fd ff ff       	call   2700 <put_ascii>
	}
}
    2992:	83 c4 34             	add    $0x34,%esp
    2995:	5b                   	pop    %ebx
    2996:	5d                   	pop    %ebp
    2997:	c3                   	ret    

00002998 <puts_str>:

void puts_str(struct Context c, char *str, unsigned short colorNum, int x, int y)
{
    2998:	55                   	push   %ebp
    2999:	89 e5                	mov    %esp,%ebp
    299b:	83 ec 38             	sub    $0x38,%esp
    299e:	8b 45 18             	mov    0x18(%ebp),%eax
    29a1:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
	//printf(0,"puts string : %s\n", str);
	int i = 0, xTmp;
    29a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	short wStr;
	uint rowLetterCnt;

	rowLetterCnt = strlen(str);
    29ac:	8b 45 14             	mov    0x14(%ebp),%eax
    29af:	89 04 24             	mov    %eax,(%esp)
    29b2:	e8 cf 15 00 00       	call   3f86 <strlen>
    29b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for(i = 0, xTmp = x; i < rowLetterCnt;) {
    29ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    29c1:	8b 45 1c             	mov    0x1c(%ebp),%eax
    29c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    29c7:	eb 49                	jmp    2a12 <puts_str+0x7a>
		if(str[i] < 0xA1) {
			put_ascii(c, str[i], colorNum, xTmp, y);
    29c9:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
    29cd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    29d0:	8b 45 14             	mov    0x14(%ebp),%eax
    29d3:	01 c8                	add    %ecx,%eax
    29d5:	0f b6 00             	movzbl (%eax),%eax
    29d8:	0f b6 c0             	movzbl %al,%eax
    29db:	8b 4d 20             	mov    0x20(%ebp),%ecx
    29de:	89 4c 24 18          	mov    %ecx,0x18(%esp)
    29e2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    29e5:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    29e9:	89 54 24 10          	mov    %edx,0x10(%esp)
    29ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
    29f1:	8b 45 08             	mov    0x8(%ebp),%eax
    29f4:	89 04 24             	mov    %eax,(%esp)
    29f7:	8b 45 0c             	mov    0xc(%ebp),%eax
    29fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    29fe:	8b 45 10             	mov    0x10(%ebp),%eax
    2a01:	89 44 24 08          	mov    %eax,0x8(%esp)
    2a05:	e8 f6 fc ff ff       	call   2700 <put_ascii>
			xTmp += 8;
    2a0a:	83 45 f0 08          	addl   $0x8,-0x10(%ebp)
			i++;
    2a0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
	int i = 0, xTmp;
	short wStr;
	uint rowLetterCnt;

	rowLetterCnt = strlen(str);
	for(i = 0, xTmp = x; i < rowLetterCnt;) {
    2a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a15:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    2a18:	72 af                	jb     29c9 <puts_str+0x31>
			put_gbk(c, wStr, colorNum, xTmp, y);
			xTmp += 16;
			i += 2;
		}
	}
}
    2a1a:	c9                   	leave  
    2a1b:	c3                   	ret    

00002a1c <_RGB16BIT565>:

int _RGB16BIT565(int r,int g,int b){
    2a1c:	55                   	push   %ebp
    2a1d:	89 e5                	mov    %esp,%ebp
	return ((b / 8)+((g / 4)<<5)+((r / 8)<<11));
    2a1f:	8b 45 10             	mov    0x10(%ebp),%eax
    2a22:	8d 50 07             	lea    0x7(%eax),%edx
    2a25:	85 c0                	test   %eax,%eax
    2a27:	0f 48 c2             	cmovs  %edx,%eax
    2a2a:	c1 f8 03             	sar    $0x3,%eax
    2a2d:	89 c2                	mov    %eax,%edx
    2a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
    2a32:	8d 48 03             	lea    0x3(%eax),%ecx
    2a35:	85 c0                	test   %eax,%eax
    2a37:	0f 48 c1             	cmovs  %ecx,%eax
    2a3a:	c1 f8 02             	sar    $0x2,%eax
    2a3d:	c1 e0 05             	shl    $0x5,%eax
    2a40:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    2a43:	8b 45 08             	mov    0x8(%ebp),%eax
    2a46:	8d 50 07             	lea    0x7(%eax),%edx
    2a49:	85 c0                	test   %eax,%eax
    2a4b:	0f 48 c2             	cmovs  %edx,%eax
    2a4e:	c1 f8 03             	sar    $0x3,%eax
    2a51:	c1 e0 0b             	shl    $0xb,%eax
    2a54:	01 c8                	add    %ecx,%eax
}
    2a56:	5d                   	pop    %ebp
    2a57:	c3                   	ret    

00002a58 <draw_picture>:

void draw_picture(Context c, PICNODE pic, int x, int y)
{
    2a58:	55                   	push   %ebp
    2a59:	89 e5                	mov    %esp,%ebp
    2a5b:	53                   	push   %ebx
    2a5c:	83 ec 28             	sub    $0x28,%esp
	int i, j;
	unsigned short color;
	RGBQUAD rgb;
	for (i = 0; i < pic.height; i++)
    2a5f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    2a66:	e9 b1 00 00 00       	jmp    2b1c <draw_picture+0xc4>
	{
		for (j = 0; j < pic.width; j++)
    2a6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2a72:	e9 95 00 00 00       	jmp    2b0c <draw_picture+0xb4>
		{
			rgb = pic.data[i*pic.width+j];
    2a77:	8b 55 14             	mov    0x14(%ebp),%edx
    2a7a:	8b 45 18             	mov    0x18(%ebp),%eax
    2a7d:	0f af 45 f8          	imul   -0x8(%ebp),%eax
    2a81:	89 c1                	mov    %eax,%ecx
    2a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a86:	01 c8                	add    %ecx,%eax
    2a88:	c1 e0 02             	shl    $0x2,%eax
    2a8b:	01 d0                	add    %edx,%eax
    2a8d:	8b 00                	mov    (%eax),%eax
    2a8f:	89 45 ee             	mov    %eax,-0x12(%ebp)
			if (rgb.rgbReserved == 1) continue;
    2a92:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    2a96:	3c 01                	cmp    $0x1,%al
    2a98:	75 02                	jne    2a9c <draw_picture+0x44>
    2a9a:	eb 6c                	jmp    2b08 <draw_picture+0xb0>
			color = (unsigned short)_RGB16BIT565(rgb.rgbRed, rgb.rgbGreen, rgb.rgbBlue);
    2a9c:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
    2aa0:	0f b6 c8             	movzbl %al,%ecx
    2aa3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    2aa7:	0f b6 d0             	movzbl %al,%edx
    2aaa:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
    2aae:	0f b6 c0             	movzbl %al,%eax
    2ab1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    2ab5:	89 54 24 04          	mov    %edx,0x4(%esp)
    2ab9:	89 04 24             	mov    %eax,(%esp)
    2abc:	e8 5b ff ff ff       	call   2a1c <_RGB16BIT565>
    2ac1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
			draw_point(c, j + x, pic.height - 1 - i + y, color);
    2ac5:	0f b7 4d f2          	movzwl -0xe(%ebp),%ecx
    2ac9:	8b 45 1c             	mov    0x1c(%ebp),%eax
    2acc:	83 e8 01             	sub    $0x1,%eax
    2acf:	2b 45 f8             	sub    -0x8(%ebp),%eax
    2ad2:	89 c2                	mov    %eax,%edx
    2ad4:	8b 45 24             	mov    0x24(%ebp),%eax
    2ad7:	01 d0                	add    %edx,%eax
    2ad9:	89 c2                	mov    %eax,%edx
    2adb:	8b 45 20             	mov    0x20(%ebp),%eax
    2ade:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    2ae1:	01 d8                	add    %ebx,%eax
    2ae3:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    2ae7:	89 54 24 10          	mov    %edx,0x10(%esp)
    2aeb:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2aef:	8b 45 08             	mov    0x8(%ebp),%eax
    2af2:	89 04 24             	mov    %eax,(%esp)
    2af5:	8b 45 0c             	mov    0xc(%ebp),%eax
    2af8:	89 44 24 04          	mov    %eax,0x4(%esp)
    2afc:	8b 45 10             	mov    0x10(%ebp),%eax
    2aff:	89 44 24 08          	mov    %eax,0x8(%esp)
    2b03:	e8 72 f8 ff ff       	call   237a <draw_point>
	int i, j;
	unsigned short color;
	RGBQUAD rgb;
	for (i = 0; i < pic.height; i++)
	{
		for (j = 0; j < pic.width; j++)
    2b08:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2b0c:	8b 45 18             	mov    0x18(%ebp),%eax
    2b0f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2b12:	0f 8f 5f ff ff ff    	jg     2a77 <draw_picture+0x1f>
void draw_picture(Context c, PICNODE pic, int x, int y)
{
	int i, j;
	unsigned short color;
	RGBQUAD rgb;
	for (i = 0; i < pic.height; i++)
    2b18:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    2b1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
    2b1f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    2b22:	0f 8f 43 ff ff ff    	jg     2a6b <draw_picture+0x13>
			if (rgb.rgbReserved == 1) continue;
			color = (unsigned short)_RGB16BIT565(rgb.rgbRed, rgb.rgbGreen, rgb.rgbBlue);
			draw_point(c, j + x, pic.height - 1 - i + y, color);
		}
	}
}
    2b28:	83 c4 28             	add    $0x28,%esp
    2b2b:	5b                   	pop    %ebx
    2b2c:	5d                   	pop    %ebp
    2b2d:	c3                   	ret    

00002b2e <draw_line>:

void draw_line(Context c, int x0, int y0, int x1, int y1, unsigned short color)
{
    2b2e:	55                   	push   %ebp
    2b2f:	89 e5                	mov    %esp,%ebp
    2b31:	83 ec 3c             	sub    $0x3c,%esp
    2b34:	8b 45 24             	mov    0x24(%ebp),%eax
    2b37:	66 89 45 dc          	mov    %ax,-0x24(%ebp)
	int dx, dy, x, y, len, i;
	dx = x1 - x0;
    2b3b:	8b 45 14             	mov    0x14(%ebp),%eax
    2b3e:	8b 55 1c             	mov    0x1c(%ebp),%edx
    2b41:	29 c2                	sub    %eax,%edx
    2b43:	89 d0                	mov    %edx,%eax
    2b45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	dy = y1 - y0;
    2b48:	8b 45 18             	mov    0x18(%ebp),%eax
    2b4b:	8b 55 20             	mov    0x20(%ebp),%edx
    2b4e:	29 c2                	sub    %eax,%edx
    2b50:	89 d0                	mov    %edx,%eax
    2b52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	x = x0 << 10;
    2b55:	8b 45 14             	mov    0x14(%ebp),%eax
    2b58:	c1 e0 0a             	shl    $0xa,%eax
    2b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	y = y0 << 10;
    2b5e:	8b 45 18             	mov    0x18(%ebp),%eax
    2b61:	c1 e0 0a             	shl    $0xa,%eax
    2b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dx = (dx < 0) ? -dx : dx;
    2b67:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2b6a:	c1 f8 1f             	sar    $0x1f,%eax
    2b6d:	31 45 fc             	xor    %eax,-0x4(%ebp)
    2b70:	29 45 fc             	sub    %eax,-0x4(%ebp)
	dy = (dy < 0) ? -dy : dy;
    2b73:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2b76:	c1 f8 1f             	sar    $0x1f,%eax
    2b79:	31 45 f8             	xor    %eax,-0x8(%ebp)
    2b7c:	29 45 f8             	sub    %eax,-0x8(%ebp)
	if(dx >= dy) {
    2b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2b82:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    2b85:	7c 57                	jl     2bde <draw_line+0xb0>
		len = dx + 1;
    2b87:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2b8a:	83 c0 01             	add    $0x1,%eax
    2b8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		dx = (x1 > x0) ? 1024 : -1024;
    2b90:	8b 45 1c             	mov    0x1c(%ebp),%eax
    2b93:	3b 45 14             	cmp    0x14(%ebp),%eax
    2b96:	7e 07                	jle    2b9f <draw_line+0x71>
    2b98:	b8 00 04 00 00       	mov    $0x400,%eax
    2b9d:	eb 05                	jmp    2ba4 <draw_line+0x76>
    2b9f:	b8 00 fc ff ff       	mov    $0xfffffc00,%eax
    2ba4:	89 45 fc             	mov    %eax,-0x4(%ebp)
		dy = (y1 >= y0) ? (((y1 - y0 + 1) << 10) / len) : (((y1 - y0 - 1) << 10) / len);
    2ba7:	8b 45 20             	mov    0x20(%ebp),%eax
    2baa:	3b 45 18             	cmp    0x18(%ebp),%eax
    2bad:	7c 16                	jl     2bc5 <draw_line+0x97>
    2baf:	8b 45 18             	mov    0x18(%ebp),%eax
    2bb2:	8b 55 20             	mov    0x20(%ebp),%edx
    2bb5:	29 c2                	sub    %eax,%edx
    2bb7:	89 d0                	mov    %edx,%eax
    2bb9:	83 c0 01             	add    $0x1,%eax
    2bbc:	c1 e0 0a             	shl    $0xa,%eax
    2bbf:	99                   	cltd   
    2bc0:	f7 7d ec             	idivl  -0x14(%ebp)
    2bc3:	eb 14                	jmp    2bd9 <draw_line+0xab>
    2bc5:	8b 45 18             	mov    0x18(%ebp),%eax
    2bc8:	8b 55 20             	mov    0x20(%ebp),%edx
    2bcb:	29 c2                	sub    %eax,%edx
    2bcd:	89 d0                	mov    %edx,%eax
    2bcf:	83 e8 01             	sub    $0x1,%eax
    2bd2:	c1 e0 0a             	shl    $0xa,%eax
    2bd5:	99                   	cltd   
    2bd6:	f7 7d ec             	idivl  -0x14(%ebp)
    2bd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    2bdc:	eb 55                	jmp    2c33 <draw_line+0x105>
	}
	else {
		len = dy + 1;
    2bde:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2be1:	83 c0 01             	add    $0x1,%eax
    2be4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		dy = (y1 > y0) ? 1024 : -1024;
    2be7:	8b 45 20             	mov    0x20(%ebp),%eax
    2bea:	3b 45 18             	cmp    0x18(%ebp),%eax
    2bed:	7e 07                	jle    2bf6 <draw_line+0xc8>
    2bef:	b8 00 04 00 00       	mov    $0x400,%eax
    2bf4:	eb 05                	jmp    2bfb <draw_line+0xcd>
    2bf6:	b8 00 fc ff ff       	mov    $0xfffffc00,%eax
    2bfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		dx = (x1 >= x0) ? (((x1 - x0 + 1) << 10) / len) : (((x1 - x0 - 1) << 10) / len);
    2bfe:	8b 45 1c             	mov    0x1c(%ebp),%eax
    2c01:	3b 45 14             	cmp    0x14(%ebp),%eax
    2c04:	7c 16                	jl     2c1c <draw_line+0xee>
    2c06:	8b 45 14             	mov    0x14(%ebp),%eax
    2c09:	8b 55 1c             	mov    0x1c(%ebp),%edx
    2c0c:	29 c2                	sub    %eax,%edx
    2c0e:	89 d0                	mov    %edx,%eax
    2c10:	83 c0 01             	add    $0x1,%eax
    2c13:	c1 e0 0a             	shl    $0xa,%eax
    2c16:	99                   	cltd   
    2c17:	f7 7d ec             	idivl  -0x14(%ebp)
    2c1a:	eb 14                	jmp    2c30 <draw_line+0x102>
    2c1c:	8b 45 14             	mov    0x14(%ebp),%eax
    2c1f:	8b 55 1c             	mov    0x1c(%ebp),%edx
    2c22:	29 c2                	sub    %eax,%edx
    2c24:	89 d0                	mov    %edx,%eax
    2c26:	83 e8 01             	sub    $0x1,%eax
    2c29:	c1 e0 0a             	shl    $0xa,%eax
    2c2c:	99                   	cltd   
    2c2d:	f7 7d ec             	idivl  -0x14(%ebp)
    2c30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
	for(i = 0; i < len; i++) {
    2c33:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    2c3a:	eb 47                	jmp    2c83 <draw_line+0x155>
		//printf(0, "draw line point: x=%d, y=%d\n", (x >> 10), (y >> 10));
		draw_point(c, (x >> 10), (y >> 10), color);
    2c3c:	0f b7 4d dc          	movzwl -0x24(%ebp),%ecx
    2c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2c43:	c1 f8 0a             	sar    $0xa,%eax
    2c46:	89 c2                	mov    %eax,%edx
    2c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c4b:	c1 f8 0a             	sar    $0xa,%eax
    2c4e:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    2c52:	89 54 24 10          	mov    %edx,0x10(%esp)
    2c56:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2c5a:	8b 45 08             	mov    0x8(%ebp),%eax
    2c5d:	89 04 24             	mov    %eax,(%esp)
    2c60:	8b 45 0c             	mov    0xc(%ebp),%eax
    2c63:	89 44 24 04          	mov    %eax,0x4(%esp)
    2c67:	8b 45 10             	mov    0x10(%ebp),%eax
    2c6a:	89 44 24 08          	mov    %eax,0x8(%esp)
    2c6e:	e8 07 f7 ff ff       	call   237a <draw_point>
		y += dy;
    2c73:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2c76:	01 45 f0             	add    %eax,-0x10(%ebp)
		x += dx;
    2c79:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2c7c:	01 45 f4             	add    %eax,-0xc(%ebp)
	else {
		len = dy + 1;
		dy = (y1 > y0) ? 1024 : -1024;
		dx = (x1 >= x0) ? (((x1 - x0 + 1) << 10) / len) : (((x1 - x0 - 1) << 10) / len);
	}
	for(i = 0; i < len; i++) {
    2c7f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    2c83:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2c86:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    2c89:	7c b1                	jl     2c3c <draw_line+0x10e>
		//printf(0, "draw line point: x=%d, y=%d\n", (x >> 10), (y >> 10));
		draw_point(c, (x >> 10), (y >> 10), color);
		y += dy;
		x += dx;
	}
}
    2c8b:	c9                   	leave  
    2c8c:	c3                   	ret    

00002c8d <draw_window>:

void
draw_window(Context c, char *title)
{
    2c8d:	55                   	push   %ebp
    2c8e:	89 e5                	mov    %esp,%ebp
    2c90:	83 ec 38             	sub    $0x38,%esp
  PICNODE pic;
  draw_line(c, 0, 0, c.width - 1, 0, BORDERLINE_COLOR);
    2c93:	8b 45 0c             	mov    0xc(%ebp),%eax
    2c96:	83 e8 01             	sub    $0x1,%eax
    2c99:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    2ca0:	00 
    2ca1:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
    2ca8:	00 
    2ca9:	89 44 24 14          	mov    %eax,0x14(%esp)
    2cad:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    2cb4:	00 
    2cb5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    2cbc:	00 
    2cbd:	8b 45 08             	mov    0x8(%ebp),%eax
    2cc0:	89 04 24             	mov    %eax,(%esp)
    2cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
    2cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
    2cca:	8b 45 10             	mov    0x10(%ebp),%eax
    2ccd:	89 44 24 08          	mov    %eax,0x8(%esp)
    2cd1:	e8 58 fe ff ff       	call   2b2e <draw_line>
  draw_line(c, c.width - 1, 0, c.width - 1, c.height - 1, BORDERLINE_COLOR);
    2cd6:	8b 45 10             	mov    0x10(%ebp),%eax
    2cd9:	8d 48 ff             	lea    -0x1(%eax),%ecx
    2cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
    2cdf:	8d 50 ff             	lea    -0x1(%eax),%edx
    2ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
    2ce5:	83 e8 01             	sub    $0x1,%eax
    2ce8:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    2cef:	00 
    2cf0:	89 4c 24 18          	mov    %ecx,0x18(%esp)
    2cf4:	89 54 24 14          	mov    %edx,0x14(%esp)
    2cf8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    2cff:	00 
    2d00:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2d04:	8b 45 08             	mov    0x8(%ebp),%eax
    2d07:	89 04 24             	mov    %eax,(%esp)
    2d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
    2d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
    2d11:	8b 45 10             	mov    0x10(%ebp),%eax
    2d14:	89 44 24 08          	mov    %eax,0x8(%esp)
    2d18:	e8 11 fe ff ff       	call   2b2e <draw_line>
  draw_line(c, c.width - 1, c.height - 1, 0, c.height - 1, BORDERLINE_COLOR);
    2d1d:	8b 45 10             	mov    0x10(%ebp),%eax
    2d20:	8d 48 ff             	lea    -0x1(%eax),%ecx
    2d23:	8b 45 10             	mov    0x10(%ebp),%eax
    2d26:	8d 50 ff             	lea    -0x1(%eax),%edx
    2d29:	8b 45 0c             	mov    0xc(%ebp),%eax
    2d2c:	83 e8 01             	sub    $0x1,%eax
    2d2f:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    2d36:	00 
    2d37:	89 4c 24 18          	mov    %ecx,0x18(%esp)
    2d3b:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
    2d42:	00 
    2d43:	89 54 24 10          	mov    %edx,0x10(%esp)
    2d47:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2d4b:	8b 45 08             	mov    0x8(%ebp),%eax
    2d4e:	89 04 24             	mov    %eax,(%esp)
    2d51:	8b 45 0c             	mov    0xc(%ebp),%eax
    2d54:	89 44 24 04          	mov    %eax,0x4(%esp)
    2d58:	8b 45 10             	mov    0x10(%ebp),%eax
    2d5b:	89 44 24 08          	mov    %eax,0x8(%esp)
    2d5f:	e8 ca fd ff ff       	call   2b2e <draw_line>
  draw_line(c, 0, c.height - 1, 0, 0, BORDERLINE_COLOR);
    2d64:	8b 45 10             	mov    0x10(%ebp),%eax
    2d67:	83 e8 01             	sub    $0x1,%eax
    2d6a:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    2d71:	00 
    2d72:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
    2d79:	00 
    2d7a:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
    2d81:	00 
    2d82:	89 44 24 10          	mov    %eax,0x10(%esp)
    2d86:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    2d8d:	00 
    2d8e:	8b 45 08             	mov    0x8(%ebp),%eax
    2d91:	89 04 24             	mov    %eax,(%esp)
    2d94:	8b 45 0c             	mov    0xc(%ebp),%eax
    2d97:	89 44 24 04          	mov    %eax,0x4(%esp)
    2d9b:	8b 45 10             	mov    0x10(%ebp),%eax
    2d9e:	89 44 24 08          	mov    %eax,0x8(%esp)
    2da2:	e8 87 fd ff ff       	call   2b2e <draw_line>
  fill_rect(c, 1, 1, c.width - 2, BOTTOMBAR_HEIGHT, TOPBAR_COLOR);
    2da7:	8b 45 0c             	mov    0xc(%ebp),%eax
    2daa:	83 e8 02             	sub    $0x2,%eax
    2dad:	c7 44 24 1c cb 5a 00 	movl   $0x5acb,0x1c(%esp)
    2db4:	00 
    2db5:	c7 44 24 18 14 00 00 	movl   $0x14,0x18(%esp)
    2dbc:	00 
    2dbd:	89 44 24 14          	mov    %eax,0x14(%esp)
    2dc1:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
    2dc8:	00 
    2dc9:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    2dd0:	00 
    2dd1:	8b 45 08             	mov    0x8(%ebp),%eax
    2dd4:	89 04 24             	mov    %eax,(%esp)
    2dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
    2dda:	89 44 24 04          	mov    %eax,0x4(%esp)
    2dde:	8b 45 10             	mov    0x10(%ebp),%eax
    2de1:	89 44 24 08          	mov    %eax,0x8(%esp)
    2de5:	e8 cf f5 ff ff       	call   23b9 <fill_rect>
  fill_rect(c, 1, c.height - 1 - BOTTOMBAR_HEIGHT, c.width - 2, BOTTOMBAR_HEIGHT, BOTTOMBAR_COLOR);
    2dea:	8b 45 0c             	mov    0xc(%ebp),%eax
    2ded:	83 e8 02             	sub    $0x2,%eax
    2df0:	89 c2                	mov    %eax,%edx
    2df2:	8b 45 10             	mov    0x10(%ebp),%eax
    2df5:	83 e8 15             	sub    $0x15,%eax
    2df8:	c7 44 24 1c cb 5a 00 	movl   $0x5acb,0x1c(%esp)
    2dff:	00 
    2e00:	c7 44 24 18 14 00 00 	movl   $0x14,0x18(%esp)
    2e07:	00 
    2e08:	89 54 24 14          	mov    %edx,0x14(%esp)
    2e0c:	89 44 24 10          	mov    %eax,0x10(%esp)
    2e10:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    2e17:	00 
    2e18:	8b 45 08             	mov    0x8(%ebp),%eax
    2e1b:	89 04 24             	mov    %eax,(%esp)
    2e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
    2e21:	89 44 24 04          	mov    %eax,0x4(%esp)
    2e25:	8b 45 10             	mov    0x10(%ebp),%eax
    2e28:	89 44 24 08          	mov    %eax,0x8(%esp)
    2e2c:	e8 88 f5 ff ff       	call   23b9 <fill_rect>

  loadBitmap(&pic, "close.bmp");
    2e31:	c7 44 24 04 58 ac 00 	movl   $0xac58,0x4(%esp)
    2e38:	00 
    2e39:	8d 45 ec             	lea    -0x14(%ebp),%eax
    2e3c:	89 04 24             	mov    %eax,(%esp)
    2e3f:	e8 44 01 00 00       	call   2f88 <loadBitmap>
  draw_picture(c, pic, 3, 3);
    2e44:	c7 44 24 1c 03 00 00 	movl   $0x3,0x1c(%esp)
    2e4b:	00 
    2e4c:	c7 44 24 18 03 00 00 	movl   $0x3,0x18(%esp)
    2e53:	00 
    2e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2e57:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2e5e:	89 44 24 10          	mov    %eax,0x10(%esp)
    2e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e65:	89 44 24 14          	mov    %eax,0x14(%esp)
    2e69:	8b 45 08             	mov    0x8(%ebp),%eax
    2e6c:	89 04 24             	mov    %eax,(%esp)
    2e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
    2e72:	89 44 24 04          	mov    %eax,0x4(%esp)
    2e76:	8b 45 10             	mov    0x10(%ebp),%eax
    2e79:	89 44 24 08          	mov    %eax,0x8(%esp)
    2e7d:	e8 d6 fb ff ff       	call   2a58 <draw_picture>
  puts_str(c, title, TITLE_COLOR, TITLE_OFFSET_X, TITLE_OFFSET_Y);
    2e82:	c7 44 24 18 02 00 00 	movl   $0x2,0x18(%esp)
    2e89:	00 
    2e8a:	c7 44 24 14 19 00 00 	movl   $0x19,0x14(%esp)
    2e91:	00 
    2e92:	c7 44 24 10 ff ff 00 	movl   $0xffff,0x10(%esp)
    2e99:	00 
    2e9a:	8b 45 14             	mov    0x14(%ebp),%eax
    2e9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2ea1:	8b 45 08             	mov    0x8(%ebp),%eax
    2ea4:	89 04 24             	mov    %eax,(%esp)
    2ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
    2eaa:	89 44 24 04          	mov    %eax,0x4(%esp)
    2eae:	8b 45 10             	mov    0x10(%ebp),%eax
    2eb1:	89 44 24 08          	mov    %eax,0x8(%esp)
    2eb5:	e8 de fa ff ff       	call   2998 <puts_str>
  freepic(&pic);
    2eba:	8d 45 ec             	lea    -0x14(%ebp),%eax
    2ebd:	89 04 24             	mov    %eax,(%esp)
    2ec0:	e8 6f 06 00 00       	call   3534 <freepic>
}
    2ec5:	c9                   	leave  
    2ec6:	c3                   	ret    

00002ec7 <load_iconlist>:

void load_iconlist(ICON* iconlist, int len)
{
    2ec7:	55                   	push   %ebp
    2ec8:	89 e5                	mov    %esp,%ebp
    2eca:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < len; i++)
    2ecd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2ed4:	eb 29                	jmp    2eff <load_iconlist+0x38>
	{
	    loadBitmap(&(iconlist[i].pic), iconlist[i].name);
    2ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ed9:	6b d0 34             	imul   $0x34,%eax,%edx
    2edc:	8b 45 08             	mov    0x8(%ebp),%eax
    2edf:	01 d0                	add    %edx,%eax
    2ee1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2ee4:	6b ca 34             	imul   $0x34,%edx,%ecx
    2ee7:	8b 55 08             	mov    0x8(%ebp),%edx
    2eea:	01 ca                	add    %ecx,%edx
    2eec:	83 c2 28             	add    $0x28,%edx
    2eef:	89 44 24 04          	mov    %eax,0x4(%esp)
    2ef3:	89 14 24             	mov    %edx,(%esp)
    2ef6:	e8 8d 00 00 00       	call   2f88 <loadBitmap>
}

void load_iconlist(ICON* iconlist, int len)
{
	int i;
	for (i = 0; i < len; i++)
    2efb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f02:	3b 45 0c             	cmp    0xc(%ebp),%eax
    2f05:	7c cf                	jl     2ed6 <load_iconlist+0xf>
	{
	    loadBitmap(&(iconlist[i].pic), iconlist[i].name);
	}
}
    2f07:	c9                   	leave  
    2f08:	c3                   	ret    

00002f09 <draw_iconlist>:
void draw_iconlist(Context c, ICON* iconlist, int len)
{
    2f09:	55                   	push   %ebp
    2f0a:	89 e5                	mov    %esp,%ebp
    2f0c:	53                   	push   %ebx
    2f0d:	83 ec 30             	sub    $0x30,%esp
    int i;
    for (i = 0; i < len; i++)
    2f10:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    2f17:	eb 61                	jmp    2f7a <draw_iconlist+0x71>
    {
        draw_picture(c, iconlist[i].pic, iconlist[i].position_x, iconlist[i].position_y);
    2f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2f1c:	6b d0 34             	imul   $0x34,%eax,%edx
    2f1f:	8b 45 14             	mov    0x14(%ebp),%eax
    2f22:	01 d0                	add    %edx,%eax
    2f24:	8b 48 24             	mov    0x24(%eax),%ecx
    2f27:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2f2a:	6b d0 34             	imul   $0x34,%eax,%edx
    2f2d:	8b 45 14             	mov    0x14(%ebp),%eax
    2f30:	01 d0                	add    %edx,%eax
    2f32:	8b 50 20             	mov    0x20(%eax),%edx
    2f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2f38:	6b d8 34             	imul   $0x34,%eax,%ebx
    2f3b:	8b 45 14             	mov    0x14(%ebp),%eax
    2f3e:	01 d8                	add    %ebx,%eax
    2f40:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
    2f44:	89 54 24 18          	mov    %edx,0x18(%esp)
    2f48:	8b 50 28             	mov    0x28(%eax),%edx
    2f4b:	89 54 24 0c          	mov    %edx,0xc(%esp)
    2f4f:	8b 50 2c             	mov    0x2c(%eax),%edx
    2f52:	89 54 24 10          	mov    %edx,0x10(%esp)
    2f56:	8b 40 30             	mov    0x30(%eax),%eax
    2f59:	89 44 24 14          	mov    %eax,0x14(%esp)
    2f5d:	8b 45 08             	mov    0x8(%ebp),%eax
    2f60:	89 04 24             	mov    %eax,(%esp)
    2f63:	8b 45 0c             	mov    0xc(%ebp),%eax
    2f66:	89 44 24 04          	mov    %eax,0x4(%esp)
    2f6a:	8b 45 10             	mov    0x10(%ebp),%eax
    2f6d:	89 44 24 08          	mov    %eax,0x8(%esp)
    2f71:	e8 e2 fa ff ff       	call   2a58 <draw_picture>
	}
}
void draw_iconlist(Context c, ICON* iconlist, int len)
{
    int i;
    for (i = 0; i < len; i++)
    2f76:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    2f7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2f7d:	3b 45 18             	cmp    0x18(%ebp),%eax
    2f80:	7c 97                	jl     2f19 <draw_iconlist+0x10>
    {
        draw_picture(c, iconlist[i].pic, iconlist[i].position_x, iconlist[i].position_y);
    }
}
    2f82:	83 c4 30             	add    $0x30,%esp
    2f85:	5b                   	pop    %ebx
    2f86:	5d                   	pop    %ebp
    2f87:	c3                   	ret    

00002f88 <loadBitmap>:
void showRgbQuan(RGBQUAD* pRGB);
void showBmpHead(BITMAPFILEHEADER* pBmpHead);
void showBmpInforHead(BITMAPINFOHEADER* pBmpInforHead);

void loadBitmap(PICNODE *pic, char pic_name[])//加载bmp文件，pic为图片节点数组，pic_name为文件名字符串
{
    2f88:	55                   	push   %ebp
    2f89:	89 e5                	mov    %esp,%ebp
    2f8b:	81 ec a8 00 00 00    	sub    $0xa8,%esp
	BITMAPFILEHEADER bitHead;//定义文件头
	BITMAPINFOHEADER bitInfoHead;//定义信息头
	char *BmpFileHeader;//文件头字符串
	WORD *temp_WORD;
	DWORD *temp_DWORD;
	int fd, n, i, j, k, index = 0;//fd为文件描述符
    2f91:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int width;
	int height;
    
    //打开bmp文件
	if ((fd = open(pic_name, 0)) < 0) {//打开文件
    2f98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2f9f:	00 
    2fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
    2fa3:	89 04 24             	mov    %eax,(%esp)
    2fa6:	e8 ef 11 00 00       	call   419a <open>
    2fab:	89 45 e8             	mov    %eax,-0x18(%ebp)
    2fae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2fb2:	79 20                	jns    2fd4 <loadBitmap+0x4c>
		printf(0, "cannot open %s\n", pic_name);//打不开
    2fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
    2fb7:	89 44 24 08          	mov    %eax,0x8(%esp)
    2fbb:	c7 44 24 04 64 ac 00 	movl   $0xac64,0x4(%esp)
    2fc2:	00 
    2fc3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fca:	e8 73 13 00 00       	call   4342 <printf>
		return;
    2fcf:	e9 ef 02 00 00       	jmp    32c3 <loadBitmap+0x33b>
	}
	printf(0, "reading bitmap: %s\n", pic_name);//打得开
    2fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
    2fd7:	89 44 24 08          	mov    %eax,0x8(%esp)
    2fdb:	c7 44 24 04 74 ac 00 	movl   $0xac74,0x4(%esp)
    2fe2:	00 
    2fe3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fea:	e8 53 13 00 00       	call   4342 <printf>
    //打开bmp文件结束
    
    //读取文件头
	BmpFileHeader = (char *) malloc(14 * sizeof(char));//文件头字符串初始化，14个字符
    2fef:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
    2ff6:	e8 33 16 00 00       	call   462e <malloc>
    2ffb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    n = read(fd, BmpFileHeader, 14);//从文件中读取前14个字符到文件头字符串中
    2ffe:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
    3005:	00 
    3006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3009:	89 44 24 04          	mov    %eax,0x4(%esp)
    300d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3010:	89 04 24             	mov    %eax,(%esp)
    3013:	e8 5a 11 00 00       	call   4172 <read>
    3018:	89 45 e0             	mov    %eax,-0x20(%ebp)
	temp_WORD = (WORD*) (BmpFileHeader);
    301b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    301e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	bitHead.bfType = *temp_WORD;//取下文件头字符串里WORD类型的bfType
    3021:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3024:	0f b7 00             	movzwl (%eax),%eax
    3027:	66 89 45 ac          	mov    %ax,-0x54(%ebp)
	if (bitHead.bfType != 0x4d42) {//不是0x4d42的话就给跪
    302b:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    302f:	66 3d 42 4d          	cmp    $0x4d42,%ax
    3033:	74 19                	je     304e <loadBitmap+0xc6>
		printf(0, "file is not .bmp file!");
    3035:	c7 44 24 04 88 ac 00 	movl   $0xac88,0x4(%esp)
    303c:	00 
    303d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3044:	e8 f9 12 00 00       	call   4342 <printf>
		return;
    3049:	e9 75 02 00 00       	jmp    32c3 <loadBitmap+0x33b>
	}
	temp_DWORD = (DWORD *) (BmpFileHeader + sizeof(bitHead.bfType));
    304e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3051:	83 c0 02             	add    $0x2,%eax
    3054:	89 45 d8             	mov    %eax,-0x28(%ebp)
	bitHead.bfSize = *temp_DWORD;//取文件大小
    3057:	8b 45 d8             	mov    -0x28(%ebp),%eax
    305a:	8b 00                	mov    (%eax),%eax
    305c:	89 45 b0             	mov    %eax,-0x50(%ebp)
	temp_WORD = (WORD*) (BmpFileHeader + sizeof(bitHead.bfType)
    305f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3062:	83 c0 06             	add    $0x6,%eax
    3065:	89 45 dc             	mov    %eax,-0x24(%ebp)
			+ sizeof(bitHead.bfSize));
	bitHead.bfReserved1 = *temp_WORD;//取保留字1
    3068:	8b 45 dc             	mov    -0x24(%ebp),%eax
    306b:	0f b7 00             	movzwl (%eax),%eax
    306e:	66 89 45 b4          	mov    %ax,-0x4c(%ebp)
	temp_WORD = (WORD*) (BmpFileHeader + sizeof(bitHead.bfType)
    3072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3075:	83 c0 08             	add    $0x8,%eax
    3078:	89 45 dc             	mov    %eax,-0x24(%ebp)
			+ sizeof(bitHead.bfSize) + sizeof(bitHead.bfReserved1));
	bitHead.bfReserved2 = *temp_WORD;//取保留字2
    307b:	8b 45 dc             	mov    -0x24(%ebp),%eax
    307e:	0f b7 00             	movzwl (%eax),%eax
    3081:	66 89 45 b6          	mov    %ax,-0x4a(%ebp)
	temp_DWORD = (DWORD*) (BmpFileHeader + sizeof(bitHead.bfType)
    3085:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3088:	83 c0 0a             	add    $0xa,%eax
    308b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			+ sizeof(bitHead.bfSize) + sizeof(bitHead.bfReserved1)
			+ sizeof(bitHead.bfReserved2));
	bitHead.bfOffBits = *temp_DWORD;//取偏移字节数
    308e:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3091:	8b 00                	mov    (%eax),%eax
    3093:	89 45 b8             	mov    %eax,-0x48(%ebp)
    //读取文件头结束
	
    //读取位图信息头信息
	read(fd, &bitInfoHead, sizeof(BITMAPINFOHEADER));//读取信息头到信息头（这是把字符串一下子读给一个结构体吗？这么神奇吗？）
    3096:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    309d:	00 
    309e:	8d 45 84             	lea    -0x7c(%ebp),%eax
    30a1:	89 44 24 04          	mov    %eax,0x4(%esp)
    30a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    30a8:	89 04 24             	mov    %eax,(%esp)
    30ab:	e8 c2 10 00 00       	call   4172 <read>
	width = bitInfoHead.biWidth;//宽取下来
    30b0:	8b 45 88             	mov    -0x78(%ebp),%eax
    30b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	height = bitInfoHead.biHeight;//高取下来
    30b6:	8b 45 8c             	mov    -0x74(%ebp),%eax
    30b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	printf(0, "bmp width: %d, height: %d, size: %d\n", width, height,
			width * height * sizeof(RGBQUAD));//输出宽、高、大小
    30bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    30bf:	0f af 45 d0          	imul   -0x30(%ebp),%eax
	
    //读取位图信息头信息
	read(fd, &bitInfoHead, sizeof(BITMAPINFOHEADER));//读取信息头到信息头（这是把字符串一下子读给一个结构体吗？这么神奇吗？）
	width = bitInfoHead.biWidth;//宽取下来
	height = bitInfoHead.biHeight;//高取下来
	printf(0, "bmp width: %d, height: %d, size: %d\n", width, height,
    30c3:	c1 e0 02             	shl    $0x2,%eax
    30c6:	89 44 24 10          	mov    %eax,0x10(%esp)
    30ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
    30cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
    30d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    30d4:	89 44 24 08          	mov    %eax,0x8(%esp)
    30d8:	c7 44 24 04 a0 ac 00 	movl   $0xaca0,0x4(%esp)
    30df:	00 
    30e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30e7:	e8 56 12 00 00       	call   4342 <printf>
			width * height * sizeof(RGBQUAD));//输出宽、高、大小
    if (n == 0) {
    30ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    30f0:	75 14                	jne    3106 <loadBitmap+0x17e>
		printf(0, "0");
    30f2:	c7 44 24 04 c5 ac 00 	movl   $0xacc5,0x4(%esp)
    30f9:	00 
    30fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3101:	e8 3c 12 00 00       	call   4342 <printf>
	}
    //读取位图信息头信息结束

	//分配内存空间把源图存入内存
	int l_width = WIDTHBYTES(width * bitInfoHead.biBitCount);//计算位图的实际宽度并确保它为32的倍数
    3106:	0f b7 45 92          	movzwl -0x6e(%ebp),%eax
    310a:	0f b7 c0             	movzwl %ax,%eax
    310d:	0f af 45 d4          	imul   -0x2c(%ebp),%eax
    3111:	83 c0 1f             	add    $0x1f,%eax
    3114:	8d 50 1f             	lea    0x1f(%eax),%edx
    3117:	85 c0                	test   %eax,%eax
    3119:	0f 48 c2             	cmovs  %edx,%eax
    311c:	c1 f8 05             	sar    $0x5,%eax
    311f:	c1 e0 02             	shl    $0x2,%eax
    3122:	89 45 cc             	mov    %eax,-0x34(%ebp)
	BYTE *pColorData = (BYTE *) malloc(height * l_width);
    3125:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3128:	0f af 45 cc          	imul   -0x34(%ebp),%eax
    312c:	89 04 24             	mov    %eax,(%esp)
    312f:	e8 fa 14 00 00       	call   462e <malloc>
    3134:	89 45 c8             	mov    %eax,-0x38(%ebp)
	memset(pColorData, 0, (uint) height * l_width);
    3137:	8b 55 d0             	mov    -0x30(%ebp),%edx
    313a:	8b 45 cc             	mov    -0x34(%ebp),%eax
    313d:	0f af c2             	imul   %edx,%eax
    3140:	89 44 24 08          	mov    %eax,0x8(%esp)
    3144:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    314b:	00 
    314c:	8b 45 c8             	mov    -0x38(%ebp),%eax
    314f:	89 04 24             	mov    %eax,(%esp)
    3152:	e8 56 0e 00 00       	call   3fad <memset>
	long nData = height * l_width;
    3157:	8b 45 d0             	mov    -0x30(%ebp),%eax
    315a:	0f af 45 cc          	imul   -0x34(%ebp),%eax
    315e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	
    //把位图数据信息读到数组里
	read(fd, pColorData, nData);
    3161:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    3164:	89 44 24 08          	mov    %eax,0x8(%esp)
    3168:	8b 45 c8             	mov    -0x38(%ebp),%eax
    316b:	89 44 24 04          	mov    %eax,0x4(%esp)
    316f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3172:	89 04 24             	mov    %eax,(%esp)
    3175:	e8 f8 0f 00 00       	call   4172 <read>

    //将位图数据转化为RGB数据
	RGBQUAD* dataOfBmp;
	dataOfBmp = (RGBQUAD *) malloc(width * height * sizeof(RGBQUAD));//用于保存各像素对应的RGB数据
    317a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    317d:	0f af 45 d0          	imul   -0x30(%ebp),%eax
    3181:	c1 e0 02             	shl    $0x2,%eax
    3184:	89 04 24             	mov    %eax,(%esp)
    3187:	e8 a2 14 00 00       	call   462e <malloc>
    318c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	memset(dataOfBmp, 0, (uint) width * height * sizeof(RGBQUAD));
    318f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    3192:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3195:	0f af c2             	imul   %edx,%eax
    3198:	c1 e0 02             	shl    $0x2,%eax
    319b:	89 44 24 08          	mov    %eax,0x8(%esp)
    319f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    31a6:	00 
    31a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
    31aa:	89 04 24             	mov    %eax,(%esp)
    31ad:	e8 fb 0d 00 00       	call   3fad <memset>
	if (bitInfoHead.biBitCount < 24)//有调色板，即位图为非真彩色
    31b2:	0f b7 45 92          	movzwl -0x6e(%ebp),%eax
    31b6:	66 83 f8 17          	cmp    $0x17,%ax
    31ba:	77 19                	ja     31d5 <loadBitmap+0x24d>
    {
		printf(0, "%s is not a 24 bit bmp! return.");
    31bc:	c7 44 24 04 c8 ac 00 	movl   $0xacc8,0x4(%esp)
    31c3:	00 
    31c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    31cb:	e8 72 11 00 00       	call   4342 <printf>
		return;
    31d0:	e9 ee 00 00 00       	jmp    32c3 <loadBitmap+0x33b>
	} else	//位图为24位真彩色
	{
		index = 0;
    31d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (i = 0; i < height; i++)
    31dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    31e3:	e9 94 00 00 00       	jmp    327c <loadBitmap+0x2f4>
			for (j = 0; j < width; j++) {
    31e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    31ef:	eb 7b                	jmp    326c <loadBitmap+0x2e4>
				k = i * l_width + j * 3;
    31f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31f4:	0f af 45 cc          	imul   -0x34(%ebp),%eax
    31f8:	89 c1                	mov    %eax,%ecx
    31fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
    31fd:	89 d0                	mov    %edx,%eax
    31ff:	01 c0                	add    %eax,%eax
    3201:	01 d0                	add    %edx,%eax
    3203:	01 c8                	add    %ecx,%eax
    3205:	89 45 bc             	mov    %eax,-0x44(%ebp)
				dataOfBmp[index].rgbRed = pColorData[k + 2];
    3208:	8b 45 ec             	mov    -0x14(%ebp),%eax
    320b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3212:	8b 45 c0             	mov    -0x40(%ebp),%eax
    3215:	01 c2                	add    %eax,%edx
    3217:	8b 45 bc             	mov    -0x44(%ebp),%eax
    321a:	8d 48 02             	lea    0x2(%eax),%ecx
    321d:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3220:	01 c8                	add    %ecx,%eax
    3222:	0f b6 00             	movzbl (%eax),%eax
    3225:	88 42 02             	mov    %al,0x2(%edx)
				dataOfBmp[index].rgbGreen = pColorData[k + 1];
    3228:	8b 45 ec             	mov    -0x14(%ebp),%eax
    322b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3232:	8b 45 c0             	mov    -0x40(%ebp),%eax
    3235:	01 c2                	add    %eax,%edx
    3237:	8b 45 bc             	mov    -0x44(%ebp),%eax
    323a:	8d 48 01             	lea    0x1(%eax),%ecx
    323d:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3240:	01 c8                	add    %ecx,%eax
    3242:	0f b6 00             	movzbl (%eax),%eax
    3245:	88 42 01             	mov    %al,0x1(%edx)
				dataOfBmp[index].rgbBlue = pColorData[k];
    3248:	8b 45 ec             	mov    -0x14(%ebp),%eax
    324b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3252:	8b 45 c0             	mov    -0x40(%ebp),%eax
    3255:	01 c2                	add    %eax,%edx
    3257:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    325a:	8b 45 c8             	mov    -0x38(%ebp),%eax
    325d:	01 c8                	add    %ecx,%eax
    325f:	0f b6 00             	movzbl (%eax),%eax
    3262:	88 02                	mov    %al,(%edx)
				index++;
    3264:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
		return;
	} else	//位图为24位真彩色
	{
		index = 0;
		for (i = 0; i < height; i++)
			for (j = 0; j < width; j++) {
    3268:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    326c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    326f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
    3272:	0f 8c 79 ff ff ff    	jl     31f1 <loadBitmap+0x269>
		printf(0, "%s is not a 24 bit bmp! return.");
		return;
	} else	//位图为24位真彩色
	{
		index = 0;
		for (i = 0; i < height; i++)
    3278:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    327f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
    3282:	0f 8c 60 ff ff ff    	jl     31e8 <loadBitmap+0x260>
				index++;
			}
	}
    
    //关闭该文件
	close(fd);
    3288:	8b 45 e8             	mov    -0x18(%ebp),%eax
    328b:	89 04 24             	mov    %eax,(%esp)
    328e:	e8 ef 0e 00 00       	call   4182 <close>
    //存入pic指向的节点中
	pic->data = dataOfBmp;//存RGB数组
    3293:	8b 45 08             	mov    0x8(%ebp),%eax
    3296:	8b 55 c0             	mov    -0x40(%ebp),%edx
    3299:	89 10                	mov    %edx,(%eax)
	pic->width = width;//存宽
    329b:	8b 45 08             	mov    0x8(%ebp),%eax
    329e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    32a1:	89 50 04             	mov    %edx,0x4(%eax)
	pic->height = height;//存高
    32a4:	8b 45 08             	mov    0x8(%ebp),%eax
    32a7:	8b 55 d0             	mov    -0x30(%ebp),%edx
    32aa:	89 50 08             	mov    %edx,0x8(%eax)

	free(pColorData);
    32ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
    32b0:	89 04 24             	mov    %eax,(%esp)
    32b3:	e8 3d 12 00 00       	call   44f5 <free>
	free(BmpFileHeader);
    32b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    32bb:	89 04 24             	mov    %eax,(%esp)
    32be:	e8 32 12 00 00       	call   44f5 <free>
}
    32c3:	c9                   	leave  
    32c4:	c3                   	ret    

000032c5 <showBmpHead>:

void showBmpHead(BITMAPFILEHEADER* pBmpHead)//输出文件头
{
    32c5:	55                   	push   %ebp
    32c6:	89 e5                	mov    %esp,%ebp
    32c8:	83 ec 18             	sub    $0x18,%esp
    printf(0, "位图文件头:\n");
    32cb:	c7 44 24 04 e8 ac 00 	movl   $0xace8,0x4(%esp)
    32d2:	00 
    32d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32da:	e8 63 10 00 00       	call   4342 <printf>
	printf(0, "bmp格式标志bftype：0x%x\n", pBmpHead->bfType);
    32df:	8b 45 08             	mov    0x8(%ebp),%eax
    32e2:	0f b7 00             	movzwl (%eax),%eax
    32e5:	0f b7 c0             	movzwl %ax,%eax
    32e8:	89 44 24 08          	mov    %eax,0x8(%esp)
    32ec:	c7 44 24 04 fa ac 00 	movl   $0xacfa,0x4(%esp)
    32f3:	00 
    32f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32fb:	e8 42 10 00 00       	call   4342 <printf>
	printf(0, "文件大小:%d\n", pBmpHead->bfSize);
    3300:	8b 45 08             	mov    0x8(%ebp),%eax
    3303:	8b 40 04             	mov    0x4(%eax),%eax
    3306:	89 44 24 08          	mov    %eax,0x8(%esp)
    330a:	c7 44 24 04 18 ad 00 	movl   $0xad18,0x4(%esp)
    3311:	00 
    3312:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3319:	e8 24 10 00 00       	call   4342 <printf>
	printf(0, "保留字:%d\n", pBmpHead->bfReserved1);
    331e:	8b 45 08             	mov    0x8(%ebp),%eax
    3321:	0f b7 40 08          	movzwl 0x8(%eax),%eax
    3325:	0f b7 c0             	movzwl %ax,%eax
    3328:	89 44 24 08          	mov    %eax,0x8(%esp)
    332c:	c7 44 24 04 29 ad 00 	movl   $0xad29,0x4(%esp)
    3333:	00 
    3334:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    333b:	e8 02 10 00 00       	call   4342 <printf>
	printf(0, "保留字:%d\n", pBmpHead->bfReserved2);
    3340:	8b 45 08             	mov    0x8(%ebp),%eax
    3343:	0f b7 40 0a          	movzwl 0xa(%eax),%eax
    3347:	0f b7 c0             	movzwl %ax,%eax
    334a:	89 44 24 08          	mov    %eax,0x8(%esp)
    334e:	c7 44 24 04 29 ad 00 	movl   $0xad29,0x4(%esp)
    3355:	00 
    3356:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    335d:	e8 e0 0f 00 00       	call   4342 <printf>
	printf(0, "实际位图数据的偏移字节数:%d\n", pBmpHead->bfOffBits);
    3362:	8b 45 08             	mov    0x8(%ebp),%eax
    3365:	8b 40 0c             	mov    0xc(%eax),%eax
    3368:	89 44 24 08          	mov    %eax,0x8(%esp)
    336c:	c7 44 24 04 38 ad 00 	movl   $0xad38,0x4(%esp)
    3373:	00 
    3374:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    337b:	e8 c2 0f 00 00       	call   4342 <printf>
}
    3380:	c9                   	leave  
    3381:	c3                   	ret    

00003382 <showBmpInforHead>:

void showBmpInforHead(BITMAPINFOHEADER* pBmpInforHead)//输出信息头
{
    3382:	55                   	push   %ebp
    3383:	89 e5                	mov    %esp,%ebp
    3385:	83 ec 18             	sub    $0x18,%esp
	printf(0, "位图信息头:\n");
    3388:	c7 44 24 04 61 ad 00 	movl   $0xad61,0x4(%esp)
    338f:	00 
    3390:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3397:	e8 a6 0f 00 00       	call   4342 <printf>
	printf(0, "结构体的长度:%d\n", pBmpInforHead->biSize);
    339c:	8b 45 08             	mov    0x8(%ebp),%eax
    339f:	8b 00                	mov    (%eax),%eax
    33a1:	89 44 24 08          	mov    %eax,0x8(%esp)
    33a5:	c7 44 24 04 73 ad 00 	movl   $0xad73,0x4(%esp)
    33ac:	00 
    33ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33b4:	e8 89 0f 00 00       	call   4342 <printf>
	printf(0, "位图宽:%d\n", pBmpInforHead->biWidth);
    33b9:	8b 45 08             	mov    0x8(%ebp),%eax
    33bc:	8b 40 04             	mov    0x4(%eax),%eax
    33bf:	89 44 24 08          	mov    %eax,0x8(%esp)
    33c3:	c7 44 24 04 8a ad 00 	movl   $0xad8a,0x4(%esp)
    33ca:	00 
    33cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33d2:	e8 6b 0f 00 00       	call   4342 <printf>
	printf(0, "位图高:%d\n", pBmpInforHead->biHeight);
    33d7:	8b 45 08             	mov    0x8(%ebp),%eax
    33da:	8b 40 08             	mov    0x8(%eax),%eax
    33dd:	89 44 24 08          	mov    %eax,0x8(%esp)
    33e1:	c7 44 24 04 98 ad 00 	movl   $0xad98,0x4(%esp)
    33e8:	00 
    33e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33f0:	e8 4d 0f 00 00       	call   4342 <printf>
	printf(0, "biPlanes平面数:%d\n", pBmpInforHead->biPlanes);
    33f5:	8b 45 08             	mov    0x8(%ebp),%eax
    33f8:	0f b7 40 0c          	movzwl 0xc(%eax),%eax
    33fc:	0f b7 c0             	movzwl %ax,%eax
    33ff:	89 44 24 08          	mov    %eax,0x8(%esp)
    3403:	c7 44 24 04 a6 ad 00 	movl   $0xada6,0x4(%esp)
    340a:	00 
    340b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3412:	e8 2b 0f 00 00       	call   4342 <printf>
	printf(0, "biBitCount采用颜色位数:%d\n", pBmpInforHead->biBitCount);
    3417:	8b 45 08             	mov    0x8(%ebp),%eax
    341a:	0f b7 40 0e          	movzwl 0xe(%eax),%eax
    341e:	0f b7 c0             	movzwl %ax,%eax
    3421:	89 44 24 08          	mov    %eax,0x8(%esp)
    3425:	c7 44 24 04 bc ad 00 	movl   $0xadbc,0x4(%esp)
    342c:	00 
    342d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3434:	e8 09 0f 00 00       	call   4342 <printf>
	printf(0, "压缩方式:%d\n", pBmpInforHead->biCompression);
    3439:	8b 45 08             	mov    0x8(%ebp),%eax
    343c:	8b 40 10             	mov    0x10(%eax),%eax
    343f:	89 44 24 08          	mov    %eax,0x8(%esp)
    3443:	c7 44 24 04 dd ad 00 	movl   $0xaddd,0x4(%esp)
    344a:	00 
    344b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3452:	e8 eb 0e 00 00       	call   4342 <printf>
	printf(0, "biSizeImage实际位图数据占用的字节数:%d\n", pBmpInforHead->biSizeImage);
    3457:	8b 45 08             	mov    0x8(%ebp),%eax
    345a:	8b 40 14             	mov    0x14(%eax),%eax
    345d:	89 44 24 08          	mov    %eax,0x8(%esp)
    3461:	c7 44 24 04 f0 ad 00 	movl   $0xadf0,0x4(%esp)
    3468:	00 
    3469:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3470:	e8 cd 0e 00 00       	call   4342 <printf>
	printf(0, "X方向分辨率:%d\n", pBmpInforHead->biXPelsPerMeter);
    3475:	8b 45 08             	mov    0x8(%ebp),%eax
    3478:	8b 40 18             	mov    0x18(%eax),%eax
    347b:	89 44 24 08          	mov    %eax,0x8(%esp)
    347f:	c7 44 24 04 24 ae 00 	movl   $0xae24,0x4(%esp)
    3486:	00 
    3487:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    348e:	e8 af 0e 00 00       	call   4342 <printf>
	printf(0, "Y方向分辨率:%d\n", pBmpInforHead->biYPelsPerMeter);
    3493:	8b 45 08             	mov    0x8(%ebp),%eax
    3496:	8b 40 1c             	mov    0x1c(%eax),%eax
    3499:	89 44 24 08          	mov    %eax,0x8(%esp)
    349d:	c7 44 24 04 39 ae 00 	movl   $0xae39,0x4(%esp)
    34a4:	00 
    34a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    34ac:	e8 91 0e 00 00       	call   4342 <printf>
	printf(0, "使用的颜色数:%d\n", pBmpInforHead->biClrUsed);
    34b1:	8b 45 08             	mov    0x8(%ebp),%eax
    34b4:	8b 40 20             	mov    0x20(%eax),%eax
    34b7:	89 44 24 08          	mov    %eax,0x8(%esp)
    34bb:	c7 44 24 04 4e ae 00 	movl   $0xae4e,0x4(%esp)
    34c2:	00 
    34c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    34ca:	e8 73 0e 00 00       	call   4342 <printf>
	printf(0, "重要颜色数:%d\n", pBmpInforHead->biClrImportant);
    34cf:	8b 45 08             	mov    0x8(%ebp),%eax
    34d2:	8b 40 24             	mov    0x24(%eax),%eax
    34d5:	89 44 24 08          	mov    %eax,0x8(%esp)
    34d9:	c7 44 24 04 65 ae 00 	movl   $0xae65,0x4(%esp)
    34e0:	00 
    34e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    34e8:	e8 55 0e 00 00       	call   4342 <printf>
}
    34ed:	c9                   	leave  
    34ee:	c3                   	ret    

000034ef <showRgbQuan>:
void showRgbQuan(RGBQUAD* pRGB)//输出RGB
{
    34ef:	55                   	push   %ebp
    34f0:	89 e5                	mov    %esp,%ebp
    34f2:	83 ec 28             	sub    $0x28,%esp
	printf(0, "(%d,%d,%d) ", pRGB->rgbRed, pRGB->rgbGreen, pRGB->rgbBlue);
    34f5:	8b 45 08             	mov    0x8(%ebp),%eax
    34f8:	0f b6 00             	movzbl (%eax),%eax
    34fb:	0f b6 c8             	movzbl %al,%ecx
    34fe:	8b 45 08             	mov    0x8(%ebp),%eax
    3501:	0f b6 40 01          	movzbl 0x1(%eax),%eax
    3505:	0f b6 d0             	movzbl %al,%edx
    3508:	8b 45 08             	mov    0x8(%ebp),%eax
    350b:	0f b6 40 02          	movzbl 0x2(%eax),%eax
    350f:	0f b6 c0             	movzbl %al,%eax
    3512:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    3516:	89 54 24 0c          	mov    %edx,0xc(%esp)
    351a:	89 44 24 08          	mov    %eax,0x8(%esp)
    351e:	c7 44 24 04 79 ae 00 	movl   $0xae79,0x4(%esp)
    3525:	00 
    3526:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    352d:	e8 10 0e 00 00       	call   4342 <printf>
}
    3532:	c9                   	leave  
    3533:	c3                   	ret    

00003534 <freepic>:

void freepic(PICNODE *pic)//释放pic
{
    3534:	55                   	push   %ebp
    3535:	89 e5                	mov    %esp,%ebp
    3537:	83 ec 18             	sub    $0x18,%esp
	free(pic->data);
    353a:	8b 45 08             	mov    0x8(%ebp),%eax
    353d:	8b 00                	mov    (%eax),%eax
    353f:	89 04 24             	mov    %eax,(%esp)
    3542:	e8 ae 0f 00 00       	call   44f5 <free>
}
    3547:	c9                   	leave  
    3548:	c3                   	ret    

00003549 <set_icon_alpha>:

void set_icon_alpha(PICNODE *pic)//图标透明度,rgb保留值用于Alpha通道
{
    3549:	55                   	push   %ebp
    354a:	89 e5                	mov    %esp,%ebp
    354c:	53                   	push   %ebx
    354d:	81 ec 84 00 00 00    	sub    $0x84,%esp
	int W = 15;
    3553:	c7 45 ec 0f 00 00 00 	movl   $0xf,-0x14(%ebp)
	Rect r1 = initRect(0, 0, W, W);
    355a:	8d 45 dc             	lea    -0x24(%ebp),%eax
    355d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    3560:	89 54 24 10          	mov    %edx,0x10(%esp)
    3564:	8b 55 ec             	mov    -0x14(%ebp),%edx
    3567:	89 54 24 0c          	mov    %edx,0xc(%esp)
    356b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    3572:	00 
    3573:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    357a:	00 
    357b:	89 04 24             	mov    %eax,(%esp)
    357e:	e8 80 02 00 00       	call   3803 <initRect>
    3583:	83 ec 04             	sub    $0x4,%esp
	Rect r2 = initRect(pic->width - W, 0, W, W);
    3586:	8b 45 08             	mov    0x8(%ebp),%eax
    3589:	8b 40 04             	mov    0x4(%eax),%eax
    358c:	2b 45 ec             	sub    -0x14(%ebp),%eax
    358f:	89 c2                	mov    %eax,%edx
    3591:	8d 45 cc             	lea    -0x34(%ebp),%eax
    3594:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    3597:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    359b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    359e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    35a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    35a9:	00 
    35aa:	89 54 24 04          	mov    %edx,0x4(%esp)
    35ae:	89 04 24             	mov    %eax,(%esp)
    35b1:	e8 4d 02 00 00       	call   3803 <initRect>
    35b6:	83 ec 04             	sub    $0x4,%esp
	Rect r3 = initRect(pic->width - W, pic->height - W, W, W);
    35b9:	8b 45 08             	mov    0x8(%ebp),%eax
    35bc:	8b 40 08             	mov    0x8(%eax),%eax
    35bf:	2b 45 ec             	sub    -0x14(%ebp),%eax
    35c2:	89 c1                	mov    %eax,%ecx
    35c4:	8b 45 08             	mov    0x8(%ebp),%eax
    35c7:	8b 40 04             	mov    0x4(%eax),%eax
    35ca:	2b 45 ec             	sub    -0x14(%ebp),%eax
    35cd:	89 c2                	mov    %eax,%edx
    35cf:	8d 45 bc             	lea    -0x44(%ebp),%eax
    35d2:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    35d5:	89 5c 24 10          	mov    %ebx,0x10(%esp)
    35d9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    35dc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    35e0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    35e4:	89 54 24 04          	mov    %edx,0x4(%esp)
    35e8:	89 04 24             	mov    %eax,(%esp)
    35eb:	e8 13 02 00 00       	call   3803 <initRect>
    35f0:	83 ec 04             	sub    $0x4,%esp
	Rect r4 = initRect(0, pic->height - W, W, W);
    35f3:	8b 45 08             	mov    0x8(%ebp),%eax
    35f6:	8b 40 08             	mov    0x8(%eax),%eax
    35f9:	2b 45 ec             	sub    -0x14(%ebp),%eax
    35fc:	89 c2                	mov    %eax,%edx
    35fe:	8d 45 ac             	lea    -0x54(%ebp),%eax
    3601:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    3604:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    3608:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    360b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    360f:	89 54 24 08          	mov    %edx,0x8(%esp)
    3613:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    361a:	00 
    361b:	89 04 24             	mov    %eax,(%esp)
    361e:	e8 e0 01 00 00       	call   3803 <initRect>
    3623:	83 ec 04             	sub    $0x4,%esp
	Point p;
	int i, j;
	for (i = 0; i < pic->width; i++) {
    3626:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    362d:	e9 96 01 00 00       	jmp    37c8 <set_icon_alpha+0x27f>
		for (j = 0; j < pic->height; j++) {
    3632:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3639:	e9 77 01 00 00       	jmp    37b5 <set_icon_alpha+0x26c>
			p = initPoint(i, j);
    363e:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3641:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3644:	89 54 24 08          	mov    %edx,0x8(%esp)
    3648:	8b 55 f4             	mov    -0xc(%ebp),%edx
    364b:	89 54 24 04          	mov    %edx,0x4(%esp)
    364f:	89 04 24             	mov    %eax,(%esp)
    3652:	e8 85 01 00 00       	call   37dc <initPoint>
    3657:	83 ec 04             	sub    $0x4,%esp
			if (isIn(p, r1) || isIn(p, r2) || isIn(p, r3) || isIn(p, r4)) {
    365a:	8b 45 dc             	mov    -0x24(%ebp),%eax
    365d:	89 44 24 08          	mov    %eax,0x8(%esp)
    3661:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3664:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    366b:	89 44 24 10          	mov    %eax,0x10(%esp)
    366f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3672:	89 44 24 14          	mov    %eax,0x14(%esp)
    3676:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    3679:	8b 55 a8             	mov    -0x58(%ebp),%edx
    367c:	89 04 24             	mov    %eax,(%esp)
    367f:	89 54 24 04          	mov    %edx,0x4(%esp)
    3683:	e8 d6 01 00 00       	call   385e <isIn>
    3688:	85 c0                	test   %eax,%eax
    368a:	0f 85 9a 00 00 00    	jne    372a <set_icon_alpha+0x1e1>
    3690:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3693:	89 44 24 08          	mov    %eax,0x8(%esp)
    3697:	8b 45 d0             	mov    -0x30(%ebp),%eax
    369a:	89 44 24 0c          	mov    %eax,0xc(%esp)
    369e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    36a1:	89 44 24 10          	mov    %eax,0x10(%esp)
    36a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
    36a8:	89 44 24 14          	mov    %eax,0x14(%esp)
    36ac:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    36af:	8b 55 a8             	mov    -0x58(%ebp),%edx
    36b2:	89 04 24             	mov    %eax,(%esp)
    36b5:	89 54 24 04          	mov    %edx,0x4(%esp)
    36b9:	e8 a0 01 00 00       	call   385e <isIn>
    36be:	85 c0                	test   %eax,%eax
    36c0:	75 68                	jne    372a <set_icon_alpha+0x1e1>
    36c2:	8b 45 bc             	mov    -0x44(%ebp),%eax
    36c5:	89 44 24 08          	mov    %eax,0x8(%esp)
    36c9:	8b 45 c0             	mov    -0x40(%ebp),%eax
    36cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
    36d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    36d3:	89 44 24 10          	mov    %eax,0x10(%esp)
    36d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
    36da:	89 44 24 14          	mov    %eax,0x14(%esp)
    36de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    36e1:	8b 55 a8             	mov    -0x58(%ebp),%edx
    36e4:	89 04 24             	mov    %eax,(%esp)
    36e7:	89 54 24 04          	mov    %edx,0x4(%esp)
    36eb:	e8 6e 01 00 00       	call   385e <isIn>
    36f0:	85 c0                	test   %eax,%eax
    36f2:	75 36                	jne    372a <set_icon_alpha+0x1e1>
    36f4:	8b 45 ac             	mov    -0x54(%ebp),%eax
    36f7:	89 44 24 08          	mov    %eax,0x8(%esp)
    36fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
    36fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3702:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    3705:	89 44 24 10          	mov    %eax,0x10(%esp)
    3709:	8b 45 b8             	mov    -0x48(%ebp),%eax
    370c:	89 44 24 14          	mov    %eax,0x14(%esp)
    3710:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    3713:	8b 55 a8             	mov    -0x58(%ebp),%edx
    3716:	89 04 24             	mov    %eax,(%esp)
    3719:	89 54 24 04          	mov    %edx,0x4(%esp)
    371d:	e8 3c 01 00 00       	call   385e <isIn>
    3722:	85 c0                	test   %eax,%eax
    3724:	0f 84 87 00 00 00    	je     37b1 <set_icon_alpha+0x268>
				if (pic->data[j * pic->width + i].rgbBlue == 0xff
    372a:	8b 45 08             	mov    0x8(%ebp),%eax
    372d:	8b 10                	mov    (%eax),%edx
    372f:	8b 45 08             	mov    0x8(%ebp),%eax
    3732:	8b 40 04             	mov    0x4(%eax),%eax
    3735:	0f af 45 f0          	imul   -0x10(%ebp),%eax
    3739:	89 c1                	mov    %eax,%ecx
    373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    373e:	01 c8                	add    %ecx,%eax
    3740:	c1 e0 02             	shl    $0x2,%eax
    3743:	01 d0                	add    %edx,%eax
    3745:	0f b6 00             	movzbl (%eax),%eax
    3748:	3c ff                	cmp    $0xff,%al
    374a:	75 65                	jne    37b1 <set_icon_alpha+0x268>
						&& pic->data[j * pic->width + i].rgbGreen == 0xff
    374c:	8b 45 08             	mov    0x8(%ebp),%eax
    374f:	8b 10                	mov    (%eax),%edx
    3751:	8b 45 08             	mov    0x8(%ebp),%eax
    3754:	8b 40 04             	mov    0x4(%eax),%eax
    3757:	0f af 45 f0          	imul   -0x10(%ebp),%eax
    375b:	89 c1                	mov    %eax,%ecx
    375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3760:	01 c8                	add    %ecx,%eax
    3762:	c1 e0 02             	shl    $0x2,%eax
    3765:	01 d0                	add    %edx,%eax
    3767:	0f b6 40 01          	movzbl 0x1(%eax),%eax
    376b:	3c ff                	cmp    $0xff,%al
    376d:	75 42                	jne    37b1 <set_icon_alpha+0x268>
						&& pic->data[j * pic->width + i].rgbRed == 0xff) {
    376f:	8b 45 08             	mov    0x8(%ebp),%eax
    3772:	8b 10                	mov    (%eax),%edx
    3774:	8b 45 08             	mov    0x8(%ebp),%eax
    3777:	8b 40 04             	mov    0x4(%eax),%eax
    377a:	0f af 45 f0          	imul   -0x10(%ebp),%eax
    377e:	89 c1                	mov    %eax,%ecx
    3780:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3783:	01 c8                	add    %ecx,%eax
    3785:	c1 e0 02             	shl    $0x2,%eax
    3788:	01 d0                	add    %edx,%eax
    378a:	0f b6 40 02          	movzbl 0x2(%eax),%eax
    378e:	3c ff                	cmp    $0xff,%al
    3790:	75 1f                	jne    37b1 <set_icon_alpha+0x268>
					pic->data[j * pic->width + i].rgbReserved = 1;
    3792:	8b 45 08             	mov    0x8(%ebp),%eax
    3795:	8b 10                	mov    (%eax),%edx
    3797:	8b 45 08             	mov    0x8(%ebp),%eax
    379a:	8b 40 04             	mov    0x4(%eax),%eax
    379d:	0f af 45 f0          	imul   -0x10(%ebp),%eax
    37a1:	89 c1                	mov    %eax,%ecx
    37a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    37a6:	01 c8                	add    %ecx,%eax
    37a8:	c1 e0 02             	shl    $0x2,%eax
    37ab:	01 d0                	add    %edx,%eax
    37ad:	c6 40 03 01          	movb   $0x1,0x3(%eax)
	Rect r3 = initRect(pic->width - W, pic->height - W, W, W);
	Rect r4 = initRect(0, pic->height - W, W, W);
	Point p;
	int i, j;
	for (i = 0; i < pic->width; i++) {
		for (j = 0; j < pic->height; j++) {
    37b1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    37b5:	8b 45 08             	mov    0x8(%ebp),%eax
    37b8:	8b 40 08             	mov    0x8(%eax),%eax
    37bb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    37be:	0f 8f 7a fe ff ff    	jg     363e <set_icon_alpha+0xf5>
	Rect r2 = initRect(pic->width - W, 0, W, W);
	Rect r3 = initRect(pic->width - W, pic->height - W, W, W);
	Rect r4 = initRect(0, pic->height - W, W, W);
	Point p;
	int i, j;
	for (i = 0; i < pic->width; i++) {
    37c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    37c8:	8b 45 08             	mov    0x8(%ebp),%eax
    37cb:	8b 40 04             	mov    0x4(%eax),%eax
    37ce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    37d1:	0f 8f 5b fe ff ff    	jg     3632 <set_icon_alpha+0xe9>
					pic->data[j * pic->width + i].rgbReserved = 1;
				}
			}
		}
	}
}
    37d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    37da:	c9                   	leave  
    37db:	c3                   	ret    

000037dc <initPoint>:
#include "message.h"
#include "types.h"
#include "user.h"
#include "finder.h"
Point initPoint(int x, int y)
{
    37dc:	55                   	push   %ebp
    37dd:	89 e5                	mov    %esp,%ebp
    37df:	83 ec 10             	sub    $0x10,%esp
	Point p;
	p.x = x;
    37e2:	8b 45 0c             	mov    0xc(%ebp),%eax
    37e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	p.y = y;
    37e8:	8b 45 10             	mov    0x10(%ebp),%eax
    37eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return p;
    37ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
    37f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    37f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    37f7:	89 01                	mov    %eax,(%ecx)
    37f9:	89 51 04             	mov    %edx,0x4(%ecx)
}
    37fc:	8b 45 08             	mov    0x8(%ebp),%eax
    37ff:	c9                   	leave  
    3800:	c2 04 00             	ret    $0x4

00003803 <initRect>:

Rect initRect(int x, int y, int w, int h)
{
    3803:	55                   	push   %ebp
    3804:	89 e5                	mov    %esp,%ebp
    3806:	83 ec 24             	sub    $0x24,%esp
	Rect r;
	r.start = initPoint(x, y);
    3809:	8d 45 e8             	lea    -0x18(%ebp),%eax
    380c:	8b 55 10             	mov    0x10(%ebp),%edx
    380f:	89 54 24 08          	mov    %edx,0x8(%esp)
    3813:	8b 55 0c             	mov    0xc(%ebp),%edx
    3816:	89 54 24 04          	mov    %edx,0x4(%esp)
    381a:	89 04 24             	mov    %eax,(%esp)
    381d:	e8 ba ff ff ff       	call   37dc <initPoint>
    3822:	83 ec 04             	sub    $0x4,%esp
    3825:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3828:	8b 55 ec             	mov    -0x14(%ebp),%edx
    382b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    382e:	89 55 f4             	mov    %edx,-0xc(%ebp)
	r.width = w;
    3831:	8b 45 14             	mov    0x14(%ebp),%eax
    3834:	89 45 f8             	mov    %eax,-0x8(%ebp)
	r.height = h;
    3837:	8b 45 18             	mov    0x18(%ebp),%eax
    383a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r;
    383d:	8b 45 08             	mov    0x8(%ebp),%eax
    3840:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3843:	89 10                	mov    %edx,(%eax)
    3845:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3848:	89 50 04             	mov    %edx,0x4(%eax)
    384b:	8b 55 f8             	mov    -0x8(%ebp),%edx
    384e:	89 50 08             	mov    %edx,0x8(%eax)
    3851:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3854:	89 50 0c             	mov    %edx,0xc(%eax)
}
    3857:	8b 45 08             	mov    0x8(%ebp),%eax
    385a:	c9                   	leave  
    385b:	c2 04 00             	ret    $0x4

0000385e <isIn>:

int isIn(Point p, Rect r)
{
    385e:	55                   	push   %ebp
    385f:	89 e5                	mov    %esp,%ebp
	return (p.x >= r.start.x) && (p.x < r.start.x+r.width)
    3861:	8b 55 08             	mov    0x8(%ebp),%edx
    3864:	8b 45 10             	mov    0x10(%ebp),%eax
			&& (p.y >= r.start.y) && (p.y < r.start.y+r.height);
    3867:	39 c2                	cmp    %eax,%edx
    3869:	7c 2f                	jl     389a <isIn+0x3c>
	return r;
}

int isIn(Point p, Rect r)
{
	return (p.x >= r.start.x) && (p.x < r.start.x+r.width)
    386b:	8b 45 08             	mov    0x8(%ebp),%eax
    386e:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3871:	8b 55 18             	mov    0x18(%ebp),%edx
    3874:	01 ca                	add    %ecx,%edx
    3876:	39 d0                	cmp    %edx,%eax
    3878:	7d 20                	jge    389a <isIn+0x3c>
			&& (p.y >= r.start.y) && (p.y < r.start.y+r.height);
    387a:	8b 55 0c             	mov    0xc(%ebp),%edx
    387d:	8b 45 14             	mov    0x14(%ebp),%eax
    3880:	39 c2                	cmp    %eax,%edx
    3882:	7c 16                	jl     389a <isIn+0x3c>
    3884:	8b 45 0c             	mov    0xc(%ebp),%eax
    3887:	8b 4d 14             	mov    0x14(%ebp),%ecx
    388a:	8b 55 1c             	mov    0x1c(%ebp),%edx
    388d:	01 ca                	add    %ecx,%edx
    388f:	39 d0                	cmp    %edx,%eax
    3891:	7d 07                	jge    389a <isIn+0x3c>
    3893:	b8 01 00 00 00       	mov    $0x1,%eax
    3898:	eb 05                	jmp    389f <isIn+0x41>
    389a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    389f:	5d                   	pop    %ebp
    38a0:	c3                   	ret    

000038a1 <initClickManager>:

ClickableManager initClickManager(struct Context c)
{
    38a1:	55                   	push   %ebp
    38a2:	89 e5                	mov    %esp,%ebp
    38a4:	83 ec 20             	sub    $0x20,%esp
	ClickableManager cm;
	cm.left_click = 0;
    38a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	cm.double_click = 0;
    38ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cm.right_click = 0;
    38b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	cm.wndWidth = c.width;
    38bc:	8b 45 10             	mov    0x10(%ebp),%eax
    38bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	cm.wndHeight = c.height;
    38c2:	8b 45 14             	mov    0x14(%ebp),%eax
    38c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return cm;
    38c8:	8b 45 08             	mov    0x8(%ebp),%eax
    38cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    38ce:	89 10                	mov    %edx,(%eax)
    38d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
    38d3:	89 50 04             	mov    %edx,0x4(%eax)
    38d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    38d9:	89 50 08             	mov    %edx,0x8(%eax)
    38dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
    38df:	89 50 0c             	mov    %edx,0xc(%eax)
    38e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
    38e5:	89 50 10             	mov    %edx,0x10(%eax)
}
    38e8:	8b 45 08             	mov    0x8(%ebp),%eax
    38eb:	c9                   	leave  
    38ec:	c2 04 00             	ret    $0x4

000038ef <createClickable>:

void createClickable(ClickableManager *c, Rect r, int MsgType, Handler h)
{
    38ef:	55                   	push   %ebp
    38f0:	89 e5                	mov    %esp,%ebp
    38f2:	83 ec 28             	sub    $0x28,%esp
	switch (MsgType)
    38f5:	8b 45 1c             	mov    0x1c(%ebp),%eax
    38f8:	83 f8 03             	cmp    $0x3,%eax
    38fb:	74 72                	je     396f <createClickable+0x80>
    38fd:	83 f8 04             	cmp    $0x4,%eax
    3900:	74 0a                	je     390c <createClickable+0x1d>
    3902:	83 f8 02             	cmp    $0x2,%eax
    3905:	74 38                	je     393f <createClickable+0x50>
    3907:	e9 96 00 00 00       	jmp    39a2 <createClickable+0xb3>
	{
		case MSG_DOUBLECLICK:
			addClickable(&c->double_click, r, h);
    390c:	8b 45 08             	mov    0x8(%ebp),%eax
    390f:	8d 50 04             	lea    0x4(%eax),%edx
    3912:	8b 45 20             	mov    0x20(%ebp),%eax
    3915:	89 44 24 14          	mov    %eax,0x14(%esp)
    3919:	8b 45 0c             	mov    0xc(%ebp),%eax
    391c:	89 44 24 04          	mov    %eax,0x4(%esp)
    3920:	8b 45 10             	mov    0x10(%ebp),%eax
    3923:	89 44 24 08          	mov    %eax,0x8(%esp)
    3927:	8b 45 14             	mov    0x14(%ebp),%eax
    392a:	89 44 24 0c          	mov    %eax,0xc(%esp)
    392e:	8b 45 18             	mov    0x18(%ebp),%eax
    3931:	89 44 24 10          	mov    %eax,0x10(%esp)
    3935:	89 14 24             	mov    %edx,(%esp)
    3938:	e8 7c 00 00 00       	call   39b9 <addClickable>
	        break;
    393d:	eb 78                	jmp    39b7 <createClickable+0xc8>
	    case MSG_LPRESS:
	    	addClickable(&c->left_click, r, h);
    393f:	8b 45 08             	mov    0x8(%ebp),%eax
    3942:	8b 55 20             	mov    0x20(%ebp),%edx
    3945:	89 54 24 14          	mov    %edx,0x14(%esp)
    3949:	8b 55 0c             	mov    0xc(%ebp),%edx
    394c:	89 54 24 04          	mov    %edx,0x4(%esp)
    3950:	8b 55 10             	mov    0x10(%ebp),%edx
    3953:	89 54 24 08          	mov    %edx,0x8(%esp)
    3957:	8b 55 14             	mov    0x14(%ebp),%edx
    395a:	89 54 24 0c          	mov    %edx,0xc(%esp)
    395e:	8b 55 18             	mov    0x18(%ebp),%edx
    3961:	89 54 24 10          	mov    %edx,0x10(%esp)
    3965:	89 04 24             	mov    %eax,(%esp)
    3968:	e8 4c 00 00 00       	call   39b9 <addClickable>
	    	break;
    396d:	eb 48                	jmp    39b7 <createClickable+0xc8>
	    case MSG_RPRESS:
	    	addClickable(&c->right_click, r, h);
    396f:	8b 45 08             	mov    0x8(%ebp),%eax
    3972:	8d 50 08             	lea    0x8(%eax),%edx
    3975:	8b 45 20             	mov    0x20(%ebp),%eax
    3978:	89 44 24 14          	mov    %eax,0x14(%esp)
    397c:	8b 45 0c             	mov    0xc(%ebp),%eax
    397f:	89 44 24 04          	mov    %eax,0x4(%esp)
    3983:	8b 45 10             	mov    0x10(%ebp),%eax
    3986:	89 44 24 08          	mov    %eax,0x8(%esp)
    398a:	8b 45 14             	mov    0x14(%ebp),%eax
    398d:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3991:	8b 45 18             	mov    0x18(%ebp),%eax
    3994:	89 44 24 10          	mov    %eax,0x10(%esp)
    3998:	89 14 24             	mov    %edx,(%esp)
    399b:	e8 19 00 00 00       	call   39b9 <addClickable>
	    	break;
    39a0:	eb 15                	jmp    39b7 <createClickable+0xc8>
	    default:
	    	printf(0, "向clickable传递了非鼠标点击事件！");
    39a2:	c7 44 24 04 88 ae 00 	movl   $0xae88,0x4(%esp)
    39a9:	00 
    39aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    39b1:	e8 8c 09 00 00       	call   4342 <printf>
	    	break;
    39b6:	90                   	nop
	}
}
    39b7:	c9                   	leave  
    39b8:	c3                   	ret    

000039b9 <addClickable>:

void addClickable(Clickable **head, Rect r, Handler h)
{
    39b9:	55                   	push   %ebp
    39ba:	89 e5                	mov    %esp,%ebp
    39bc:	83 ec 28             	sub    $0x28,%esp
	//printf(0, "adding clickable\n");
	Clickable *c = (Clickable *)malloc(sizeof(Clickable));
    39bf:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
    39c6:	e8 63 0c 00 00       	call   462e <malloc>
    39cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	c->area = r;
    39ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    39d1:	8b 55 0c             	mov    0xc(%ebp),%edx
    39d4:	89 10                	mov    %edx,(%eax)
    39d6:	8b 55 10             	mov    0x10(%ebp),%edx
    39d9:	89 50 04             	mov    %edx,0x4(%eax)
    39dc:	8b 55 14             	mov    0x14(%ebp),%edx
    39df:	89 50 08             	mov    %edx,0x8(%eax)
    39e2:	8b 55 18             	mov    0x18(%ebp),%edx
    39e5:	89 50 0c             	mov    %edx,0xc(%eax)
	c->handler = h;
    39e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    39eb:	8b 55 1c             	mov    0x1c(%ebp),%edx
    39ee:	89 50 10             	mov    %edx,0x10(%eax)
	c->next = *head;
    39f1:	8b 45 08             	mov    0x8(%ebp),%eax
    39f4:	8b 10                	mov    (%eax),%edx
    39f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    39f9:	89 50 14             	mov    %edx,0x14(%eax)
	*head = c;
    39fc:	8b 45 08             	mov    0x8(%ebp),%eax
    39ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3a02:	89 10                	mov    %edx,(%eax)
}
    3a04:	c9                   	leave  
    3a05:	c3                   	ret    

00003a06 <deleteClickable>:

void deleteClickable(Clickable **head, Rect region)
{
    3a06:	55                   	push   %ebp
    3a07:	89 e5                	mov    %esp,%ebp
    3a09:	83 ec 38             	sub    $0x38,%esp
	Clickable *prev, *cur, *temp;
	prev = cur = *head;
    3a0c:	8b 45 08             	mov    0x8(%ebp),%eax
    3a0f:	8b 00                	mov    (%eax),%eax
    3a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    3a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (cur != 0)
    3a1a:	e9 bb 00 00 00       	jmp    3ada <deleteClickable+0xd4>
	{
		if (isIn(cur->area.start, region))
    3a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a22:	89 44 24 08          	mov    %eax,0x8(%esp)
    3a26:	8b 45 10             	mov    0x10(%ebp),%eax
    3a29:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3a2d:	8b 45 14             	mov    0x14(%ebp),%eax
    3a30:	89 44 24 10          	mov    %eax,0x10(%esp)
    3a34:	8b 45 18             	mov    0x18(%ebp),%eax
    3a37:	89 44 24 14          	mov    %eax,0x14(%esp)
    3a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3a3e:	8b 50 04             	mov    0x4(%eax),%edx
    3a41:	8b 00                	mov    (%eax),%eax
    3a43:	89 04 24             	mov    %eax,(%esp)
    3a46:	89 54 24 04          	mov    %edx,0x4(%esp)
    3a4a:	e8 0f fe ff ff       	call   385e <isIn>
    3a4f:	85 c0                	test   %eax,%eax
    3a51:	74 60                	je     3ab3 <deleteClickable+0xad>
		{
			//如果当前指针指向头部
			if (cur == *head)
    3a53:	8b 45 08             	mov    0x8(%ebp),%eax
    3a56:	8b 00                	mov    (%eax),%eax
    3a58:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    3a5b:	75 2e                	jne    3a8b <deleteClickable+0x85>
			{
				//删除头节点
				temp = *head;
    3a5d:	8b 45 08             	mov    0x8(%ebp),%eax
    3a60:	8b 00                	mov    (%eax),%eax
    3a62:	89 45 ec             	mov    %eax,-0x14(%ebp)
				*head = cur->next;
    3a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3a68:	8b 50 14             	mov    0x14(%eax),%edx
    3a6b:	8b 45 08             	mov    0x8(%ebp),%eax
    3a6e:	89 10                	mov    %edx,(%eax)
				cur = prev = *head;
    3a70:	8b 45 08             	mov    0x8(%ebp),%eax
    3a73:	8b 00                	mov    (%eax),%eax
    3a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3a7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				free(temp);
    3a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3a81:	89 04 24             	mov    %eax,(%esp)
    3a84:	e8 6c 0a 00 00       	call   44f5 <free>
    3a89:	eb 4f                	jmp    3ada <deleteClickable+0xd4>
			}
			else
			{
				//删除当前节点
				prev->next = cur->next;
    3a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3a8e:	8b 50 14             	mov    0x14(%eax),%edx
    3a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3a94:	89 50 14             	mov    %edx,0x14(%eax)
				temp = cur;
    3a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3a9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				cur = cur->next;
    3a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3aa0:	8b 40 14             	mov    0x14(%eax),%eax
    3aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				free(temp);
    3aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3aa9:	89 04 24             	mov    %eax,(%esp)
    3aac:	e8 44 0a 00 00       	call   44f5 <free>
    3ab1:	eb 27                	jmp    3ada <deleteClickable+0xd4>
			}
		}
		else
		{
			//如果当前节点是头节点，
			if (cur == *head)
    3ab3:	8b 45 08             	mov    0x8(%ebp),%eax
    3ab6:	8b 00                	mov    (%eax),%eax
    3ab8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    3abb:	75 0b                	jne    3ac8 <deleteClickable+0xc2>
			{
				cur = cur->next;
    3abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3ac0:	8b 40 14             	mov    0x14(%eax),%eax
    3ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    3ac6:	eb 12                	jmp    3ada <deleteClickable+0xd4>
			}
			else
			{
				cur = cur->next;
    3ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3acb:	8b 40 14             	mov    0x14(%eax),%eax
    3ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
				prev = prev->next;
    3ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ad4:	8b 40 14             	mov    0x14(%eax),%eax
    3ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)

void deleteClickable(Clickable **head, Rect region)
{
	Clickable *prev, *cur, *temp;
	prev = cur = *head;
	while (cur != 0)
    3ada:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3ade:	0f 85 3b ff ff ff    	jne    3a1f <deleteClickable+0x19>
				cur = cur->next;
				prev = prev->next;
			}
		}
	}
}
    3ae4:	c9                   	leave  
    3ae5:	c3                   	ret    

00003ae6 <executeHandler>:

int executeHandler(Clickable *head, Point click)
{
    3ae6:	55                   	push   %ebp
    3ae7:	89 e5                	mov    %esp,%ebp
    3ae9:	83 ec 38             	sub    $0x38,%esp
	Clickable *cur = head;
    3aec:	8b 45 08             	mov    0x8(%ebp),%eax
    3aef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (cur != 0)
    3af2:	eb 6d                	jmp    3b61 <executeHandler+0x7b>
	{
		if (isIn(click, cur->area))
    3af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3af7:	8b 10                	mov    (%eax),%edx
    3af9:	89 54 24 08          	mov    %edx,0x8(%esp)
    3afd:	8b 50 04             	mov    0x4(%eax),%edx
    3b00:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3b04:	8b 50 08             	mov    0x8(%eax),%edx
    3b07:	89 54 24 10          	mov    %edx,0x10(%esp)
    3b0b:	8b 40 0c             	mov    0xc(%eax),%eax
    3b0e:	89 44 24 14          	mov    %eax,0x14(%esp)
    3b12:	8b 45 0c             	mov    0xc(%ebp),%eax
    3b15:	8b 55 10             	mov    0x10(%ebp),%edx
    3b18:	89 04 24             	mov    %eax,(%esp)
    3b1b:	89 54 24 04          	mov    %edx,0x4(%esp)
    3b1f:	e8 3a fd ff ff       	call   385e <isIn>
    3b24:	85 c0                	test   %eax,%eax
    3b26:	74 30                	je     3b58 <executeHandler+0x72>
		{
			renaming = 0;
    3b28:	c7 05 e4 1d 01 00 00 	movl   $0x0,0x11de4
    3b2f:	00 00 00 
			isSearching = 0;
    3b32:	c7 05 e0 1d 01 00 00 	movl   $0x0,0x11de0
    3b39:	00 00 00 
			cur->handler(click);
    3b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b3f:	8b 48 10             	mov    0x10(%eax),%ecx
    3b42:	8b 45 0c             	mov    0xc(%ebp),%eax
    3b45:	8b 55 10             	mov    0x10(%ebp),%edx
    3b48:	89 04 24             	mov    %eax,(%esp)
    3b4b:	89 54 24 04          	mov    %edx,0x4(%esp)
    3b4f:	ff d1                	call   *%ecx
			return 1;
    3b51:	b8 01 00 00 00       	mov    $0x1,%eax
    3b56:	eb 4d                	jmp    3ba5 <executeHandler+0xbf>
		}
		cur = cur->next;
    3b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b5b:	8b 40 14             	mov    0x14(%eax),%eax
    3b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

int executeHandler(Clickable *head, Point click)
{
	Clickable *cur = head;
	while (cur != 0)
    3b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b65:	75 8d                	jne    3af4 <executeHandler+0xe>
			cur->handler(click);
			return 1;
		}
		cur = cur->next;
	}
	isSearching = 0;
    3b67:	c7 05 e0 1d 01 00 00 	movl   $0x0,0x11de0
    3b6e:	00 00 00 
	if (renaming == 1){
    3b71:	a1 e4 1d 01 00       	mov    0x11de4,%eax
    3b76:	83 f8 01             	cmp    $0x1,%eax
    3b79:	75 11                	jne    3b8c <executeHandler+0xa6>
		renaming = 0;
    3b7b:	c7 05 e4 1d 01 00 00 	movl   $0x0,0x11de4
    3b82:	00 00 00 
		return 1;
    3b85:	b8 01 00 00 00       	mov    $0x1,%eax
    3b8a:	eb 19                	jmp    3ba5 <executeHandler+0xbf>
	}
	printf(0, "execute: none!\n");
    3b8c:	c7 44 24 04 b6 ae 00 	movl   $0xaeb6,0x4(%esp)
    3b93:	00 
    3b94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3b9b:	e8 a2 07 00 00       	call   4342 <printf>
	return 0;
    3ba0:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3ba5:	c9                   	leave  
    3ba6:	c3                   	ret    

00003ba7 <printClickable>:

void printClickable(Clickable *c)
{
    3ba7:	55                   	push   %ebp
    3ba8:	89 e5                	mov    %esp,%ebp
    3baa:	53                   	push   %ebx
    3bab:	83 ec 24             	sub    $0x24,%esp
	printf(0, "(%d, %d, %d, %d)\n", c->area.start.x, c->area.start.y, c->area.width, c->area.height);
    3bae:	8b 45 08             	mov    0x8(%ebp),%eax
    3bb1:	8b 58 0c             	mov    0xc(%eax),%ebx
    3bb4:	8b 45 08             	mov    0x8(%ebp),%eax
    3bb7:	8b 48 08             	mov    0x8(%eax),%ecx
    3bba:	8b 45 08             	mov    0x8(%ebp),%eax
    3bbd:	8b 50 04             	mov    0x4(%eax),%edx
    3bc0:	8b 45 08             	mov    0x8(%ebp),%eax
    3bc3:	8b 00                	mov    (%eax),%eax
    3bc5:	89 5c 24 14          	mov    %ebx,0x14(%esp)
    3bc9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    3bcd:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3bd1:	89 44 24 08          	mov    %eax,0x8(%esp)
    3bd5:	c7 44 24 04 c6 ae 00 	movl   $0xaec6,0x4(%esp)
    3bdc:	00 
    3bdd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3be4:	e8 59 07 00 00       	call   4342 <printf>
}
    3be9:	83 c4 24             	add    $0x24,%esp
    3bec:	5b                   	pop    %ebx
    3bed:	5d                   	pop    %ebp
    3bee:	c3                   	ret    

00003bef <printClickableList>:

void printClickableList(Clickable *head)
{
    3bef:	55                   	push   %ebp
    3bf0:	89 e5                	mov    %esp,%ebp
    3bf2:	83 ec 28             	sub    $0x28,%esp
	Clickable *cur = head;
    3bf5:	8b 45 08             	mov    0x8(%ebp),%eax
    3bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	printf(0, "Clickable List:\n");
    3bfb:	c7 44 24 04 d8 ae 00 	movl   $0xaed8,0x4(%esp)
    3c02:	00 
    3c03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3c0a:	e8 33 07 00 00       	call   4342 <printf>
	while(cur != 0)
    3c0f:	eb 14                	jmp    3c25 <printClickableList+0x36>
	{
		printClickable(cur);
    3c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3c14:	89 04 24             	mov    %eax,(%esp)
    3c17:	e8 8b ff ff ff       	call   3ba7 <printClickable>
		cur = cur->next;
    3c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3c1f:	8b 40 14             	mov    0x14(%eax),%eax
    3c22:	89 45 f4             	mov    %eax,-0xc(%ebp)

void printClickableList(Clickable *head)
{
	Clickable *cur = head;
	printf(0, "Clickable List:\n");
	while(cur != 0)
    3c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3c29:	75 e6                	jne    3c11 <printClickableList+0x22>
	{
		printClickable(cur);
		cur = cur->next;
	}
	printf(0, "\n");
    3c2b:	c7 44 24 04 e9 ae 00 	movl   $0xaee9,0x4(%esp)
    3c32:	00 
    3c33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3c3a:	e8 03 07 00 00       	call   4342 <printf>
}
    3c3f:	c9                   	leave  
    3c40:	c3                   	ret    

00003c41 <testHanler>:

void testHanler(struct Point p)
{
    3c41:	55                   	push   %ebp
    3c42:	89 e5                	mov    %esp,%ebp
    3c44:	83 ec 18             	sub    $0x18,%esp
	printf(0, "execute: (%d, %d)!\n", p.x, p.y);
    3c47:	8b 55 0c             	mov    0xc(%ebp),%edx
    3c4a:	8b 45 08             	mov    0x8(%ebp),%eax
    3c4d:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3c51:	89 44 24 08          	mov    %eax,0x8(%esp)
    3c55:	c7 44 24 04 eb ae 00 	movl   $0xaeeb,0x4(%esp)
    3c5c:	00 
    3c5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3c64:	e8 d9 06 00 00       	call   4342 <printf>
}
    3c69:	c9                   	leave  
    3c6a:	c3                   	ret    

00003c6b <testClickable>:
void testClickable(struct Context c)
{
    3c6b:	55                   	push   %ebp
    3c6c:	89 e5                	mov    %esp,%ebp
    3c6e:	81 ec 98 00 00 00    	sub    $0x98,%esp
	ClickableManager cm = initClickManager(c);
    3c74:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3c77:	8b 55 08             	mov    0x8(%ebp),%edx
    3c7a:	89 54 24 04          	mov    %edx,0x4(%esp)
    3c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
    3c81:	89 54 24 08          	mov    %edx,0x8(%esp)
    3c85:	8b 55 10             	mov    0x10(%ebp),%edx
    3c88:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3c8c:	89 04 24             	mov    %eax,(%esp)
    3c8f:	e8 0d fc ff ff       	call   38a1 <initClickManager>
    3c94:	83 ec 04             	sub    $0x4,%esp

	Rect r1 = initRect(5,5,20,20);
    3c97:	8d 45 d4             	lea    -0x2c(%ebp),%eax
    3c9a:	c7 44 24 10 14 00 00 	movl   $0x14,0x10(%esp)
    3ca1:	00 
    3ca2:	c7 44 24 0c 14 00 00 	movl   $0x14,0xc(%esp)
    3ca9:	00 
    3caa:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    3cb1:	00 
    3cb2:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
    3cb9:	00 
    3cba:	89 04 24             	mov    %eax,(%esp)
    3cbd:	e8 41 fb ff ff       	call   3803 <initRect>
    3cc2:	83 ec 04             	sub    $0x4,%esp
	Rect r2 = initRect(20,20,20,20);
    3cc5:	8d 45 c4             	lea    -0x3c(%ebp),%eax
    3cc8:	c7 44 24 10 14 00 00 	movl   $0x14,0x10(%esp)
    3ccf:	00 
    3cd0:	c7 44 24 0c 14 00 00 	movl   $0x14,0xc(%esp)
    3cd7:	00 
    3cd8:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
    3cdf:	00 
    3ce0:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
    3ce7:	00 
    3ce8:	89 04 24             	mov    %eax,(%esp)
    3ceb:	e8 13 fb ff ff       	call   3803 <initRect>
    3cf0:	83 ec 04             	sub    $0x4,%esp
	Rect r3 = initRect(50,50,15,15);
    3cf3:	8d 45 b4             	lea    -0x4c(%ebp),%eax
    3cf6:	c7 44 24 10 0f 00 00 	movl   $0xf,0x10(%esp)
    3cfd:	00 
    3cfe:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
    3d05:	00 
    3d06:	c7 44 24 08 32 00 00 	movl   $0x32,0x8(%esp)
    3d0d:	00 
    3d0e:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
    3d15:	00 
    3d16:	89 04 24             	mov    %eax,(%esp)
    3d19:	e8 e5 fa ff ff       	call   3803 <initRect>
    3d1e:	83 ec 04             	sub    $0x4,%esp
	Rect r4 = initRect(0,0,30,30);
    3d21:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3d24:	c7 44 24 10 1e 00 00 	movl   $0x1e,0x10(%esp)
    3d2b:	00 
    3d2c:	c7 44 24 0c 1e 00 00 	movl   $0x1e,0xc(%esp)
    3d33:	00 
    3d34:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    3d3b:	00 
    3d3c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3d43:	00 
    3d44:	89 04 24             	mov    %eax,(%esp)
    3d47:	e8 b7 fa ff ff       	call   3803 <initRect>
    3d4c:	83 ec 04             	sub    $0x4,%esp
	Point p1 = initPoint(23, 23);
    3d4f:	8d 45 9c             	lea    -0x64(%ebp),%eax
    3d52:	c7 44 24 08 17 00 00 	movl   $0x17,0x8(%esp)
    3d59:	00 
    3d5a:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
    3d61:	00 
    3d62:	89 04 24             	mov    %eax,(%esp)
    3d65:	e8 72 fa ff ff       	call   37dc <initPoint>
    3d6a:	83 ec 04             	sub    $0x4,%esp
	Point p2 = initPoint(70, 70);
    3d6d:	8d 45 94             	lea    -0x6c(%ebp),%eax
    3d70:	c7 44 24 08 46 00 00 	movl   $0x46,0x8(%esp)
    3d77:	00 
    3d78:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
    3d7f:	00 
    3d80:	89 04 24             	mov    %eax,(%esp)
    3d83:	e8 54 fa ff ff       	call   37dc <initPoint>
    3d88:	83 ec 04             	sub    $0x4,%esp
	createClickable(&cm, r1, MSG_LPRESS, &testHanler);
    3d8b:	c7 44 24 18 41 3c 00 	movl   $0x3c41,0x18(%esp)
    3d92:	00 
    3d93:	c7 44 24 14 02 00 00 	movl   $0x2,0x14(%esp)
    3d9a:	00 
    3d9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3d9e:	89 44 24 04          	mov    %eax,0x4(%esp)
    3da2:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3da5:	89 44 24 08          	mov    %eax,0x8(%esp)
    3da9:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3dac:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3db3:	89 44 24 10          	mov    %eax,0x10(%esp)
    3db7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3dba:	89 04 24             	mov    %eax,(%esp)
    3dbd:	e8 2d fb ff ff       	call   38ef <createClickable>
	printf(0, "left_click: %d\n", cm.left_click);
    3dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3dc5:	89 44 24 08          	mov    %eax,0x8(%esp)
    3dc9:	c7 44 24 04 ff ae 00 	movl   $0xaeff,0x4(%esp)
    3dd0:	00 
    3dd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3dd8:	e8 65 05 00 00       	call   4342 <printf>
	createClickable(&cm, r2, MSG_LPRESS, &testHanler);
    3ddd:	c7 44 24 18 41 3c 00 	movl   $0x3c41,0x18(%esp)
    3de4:	00 
    3de5:	c7 44 24 14 02 00 00 	movl   $0x2,0x14(%esp)
    3dec:	00 
    3ded:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    3df0:	89 44 24 04          	mov    %eax,0x4(%esp)
    3df4:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3df7:	89 44 24 08          	mov    %eax,0x8(%esp)
    3dfb:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3dfe:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3e02:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3e05:	89 44 24 10          	mov    %eax,0x10(%esp)
    3e09:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3e0c:	89 04 24             	mov    %eax,(%esp)
    3e0f:	e8 db fa ff ff       	call   38ef <createClickable>
	printf(0, "left_click: %d\n", cm.left_click);
    3e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3e17:	89 44 24 08          	mov    %eax,0x8(%esp)
    3e1b:	c7 44 24 04 ff ae 00 	movl   $0xaeff,0x4(%esp)
    3e22:	00 
    3e23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3e2a:	e8 13 05 00 00       	call   4342 <printf>
	createClickable(&cm, r3, MSG_LPRESS, &testHanler);
    3e2f:	c7 44 24 18 41 3c 00 	movl   $0x3c41,0x18(%esp)
    3e36:	00 
    3e37:	c7 44 24 14 02 00 00 	movl   $0x2,0x14(%esp)
    3e3e:	00 
    3e3f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    3e42:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e46:	8b 45 b8             	mov    -0x48(%ebp),%eax
    3e49:	89 44 24 08          	mov    %eax,0x8(%esp)
    3e4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
    3e50:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3e54:	8b 45 c0             	mov    -0x40(%ebp),%eax
    3e57:	89 44 24 10          	mov    %eax,0x10(%esp)
    3e5b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3e5e:	89 04 24             	mov    %eax,(%esp)
    3e61:	e8 89 fa ff ff       	call   38ef <createClickable>
	printf(0, "left_click: %d\n", cm.left_click);
    3e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3e69:	89 44 24 08          	mov    %eax,0x8(%esp)
    3e6d:	c7 44 24 04 ff ae 00 	movl   $0xaeff,0x4(%esp)
    3e74:	00 
    3e75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3e7c:	e8 c1 04 00 00       	call   4342 <printf>
	printClickableList(cm.left_click);
    3e81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3e84:	89 04 24             	mov    %eax,(%esp)
    3e87:	e8 63 fd ff ff       	call   3bef <printClickableList>
	executeHandler(cm.left_click, p1);
    3e8c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    3e8f:	8b 45 9c             	mov    -0x64(%ebp),%eax
    3e92:	8b 55 a0             	mov    -0x60(%ebp),%edx
    3e95:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e99:	89 54 24 08          	mov    %edx,0x8(%esp)
    3e9d:	89 0c 24             	mov    %ecx,(%esp)
    3ea0:	e8 41 fc ff ff       	call   3ae6 <executeHandler>
	executeHandler(cm.left_click, p2);
    3ea5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    3ea8:	8b 45 94             	mov    -0x6c(%ebp),%eax
    3eab:	8b 55 98             	mov    -0x68(%ebp),%edx
    3eae:	89 44 24 04          	mov    %eax,0x4(%esp)
    3eb2:	89 54 24 08          	mov    %edx,0x8(%esp)
    3eb6:	89 0c 24             	mov    %ecx,(%esp)
    3eb9:	e8 28 fc ff ff       	call   3ae6 <executeHandler>
	deleteClickable(&cm.left_click, r4);
    3ebe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    3ec1:	89 44 24 04          	mov    %eax,0x4(%esp)
    3ec5:	8b 45 a8             	mov    -0x58(%ebp),%eax
    3ec8:	89 44 24 08          	mov    %eax,0x8(%esp)
    3ecc:	8b 45 ac             	mov    -0x54(%ebp),%eax
    3ecf:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3ed3:	8b 45 b0             	mov    -0x50(%ebp),%eax
    3ed6:	89 44 24 10          	mov    %eax,0x10(%esp)
    3eda:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3edd:	89 04 24             	mov    %eax,(%esp)
    3ee0:	e8 21 fb ff ff       	call   3a06 <deleteClickable>
	printClickableList(cm.left_click);
    3ee5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3ee8:	89 04 24             	mov    %eax,(%esp)
    3eeb:	e8 ff fc ff ff       	call   3bef <printClickableList>
}
    3ef0:	c9                   	leave  
    3ef1:	c3                   	ret    

00003ef2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3ef2:	55                   	push   %ebp
    3ef3:	89 e5                	mov    %esp,%ebp
    3ef5:	57                   	push   %edi
    3ef6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3efa:	8b 55 10             	mov    0x10(%ebp),%edx
    3efd:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f00:	89 cb                	mov    %ecx,%ebx
    3f02:	89 df                	mov    %ebx,%edi
    3f04:	89 d1                	mov    %edx,%ecx
    3f06:	fc                   	cld    
    3f07:	f3 aa                	rep stos %al,%es:(%edi)
    3f09:	89 ca                	mov    %ecx,%edx
    3f0b:	89 fb                	mov    %edi,%ebx
    3f0d:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3f10:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3f13:	5b                   	pop    %ebx
    3f14:	5f                   	pop    %edi
    3f15:	5d                   	pop    %ebp
    3f16:	c3                   	ret    

00003f17 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3f17:	55                   	push   %ebp
    3f18:	89 e5                	mov    %esp,%ebp
    3f1a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3f1d:	8b 45 08             	mov    0x8(%ebp),%eax
    3f20:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3f23:	90                   	nop
    3f24:	8b 45 08             	mov    0x8(%ebp),%eax
    3f27:	8d 50 01             	lea    0x1(%eax),%edx
    3f2a:	89 55 08             	mov    %edx,0x8(%ebp)
    3f2d:	8b 55 0c             	mov    0xc(%ebp),%edx
    3f30:	8d 4a 01             	lea    0x1(%edx),%ecx
    3f33:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    3f36:	0f b6 12             	movzbl (%edx),%edx
    3f39:	88 10                	mov    %dl,(%eax)
    3f3b:	0f b6 00             	movzbl (%eax),%eax
    3f3e:	84 c0                	test   %al,%al
    3f40:	75 e2                	jne    3f24 <strcpy+0xd>
    ;
  return os;
    3f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3f45:	c9                   	leave  
    3f46:	c3                   	ret    

00003f47 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3f47:	55                   	push   %ebp
    3f48:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3f4a:	eb 08                	jmp    3f54 <strcmp+0xd>
    p++, q++;
    3f4c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3f50:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3f54:	8b 45 08             	mov    0x8(%ebp),%eax
    3f57:	0f b6 00             	movzbl (%eax),%eax
    3f5a:	84 c0                	test   %al,%al
    3f5c:	74 10                	je     3f6e <strcmp+0x27>
    3f5e:	8b 45 08             	mov    0x8(%ebp),%eax
    3f61:	0f b6 10             	movzbl (%eax),%edx
    3f64:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f67:	0f b6 00             	movzbl (%eax),%eax
    3f6a:	38 c2                	cmp    %al,%dl
    3f6c:	74 de                	je     3f4c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3f6e:	8b 45 08             	mov    0x8(%ebp),%eax
    3f71:	0f b6 00             	movzbl (%eax),%eax
    3f74:	0f b6 d0             	movzbl %al,%edx
    3f77:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f7a:	0f b6 00             	movzbl (%eax),%eax
    3f7d:	0f b6 c0             	movzbl %al,%eax
    3f80:	29 c2                	sub    %eax,%edx
    3f82:	89 d0                	mov    %edx,%eax
}
    3f84:	5d                   	pop    %ebp
    3f85:	c3                   	ret    

00003f86 <strlen>:

uint
strlen(char *s)
{
    3f86:	55                   	push   %ebp
    3f87:	89 e5                	mov    %esp,%ebp
    3f89:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3f8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3f93:	eb 04                	jmp    3f99 <strlen+0x13>
    3f95:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3f99:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3f9c:	8b 45 08             	mov    0x8(%ebp),%eax
    3f9f:	01 d0                	add    %edx,%eax
    3fa1:	0f b6 00             	movzbl (%eax),%eax
    3fa4:	84 c0                	test   %al,%al
    3fa6:	75 ed                	jne    3f95 <strlen+0xf>
    ;
  return n;
    3fa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3fab:	c9                   	leave  
    3fac:	c3                   	ret    

00003fad <memset>:

void*
memset(void *dst, int c, uint n)
{
    3fad:	55                   	push   %ebp
    3fae:	89 e5                	mov    %esp,%ebp
    3fb0:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3fb3:	8b 45 10             	mov    0x10(%ebp),%eax
    3fb6:	89 44 24 08          	mov    %eax,0x8(%esp)
    3fba:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fbd:	89 44 24 04          	mov    %eax,0x4(%esp)
    3fc1:	8b 45 08             	mov    0x8(%ebp),%eax
    3fc4:	89 04 24             	mov    %eax,(%esp)
    3fc7:	e8 26 ff ff ff       	call   3ef2 <stosb>
  return dst;
    3fcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3fcf:	c9                   	leave  
    3fd0:	c3                   	ret    

00003fd1 <strchr>:

char*
strchr(const char *s, char c)
{
    3fd1:	55                   	push   %ebp
    3fd2:	89 e5                	mov    %esp,%ebp
    3fd4:	83 ec 04             	sub    $0x4,%esp
    3fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fda:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3fdd:	eb 14                	jmp    3ff3 <strchr+0x22>
    if(*s == c)
    3fdf:	8b 45 08             	mov    0x8(%ebp),%eax
    3fe2:	0f b6 00             	movzbl (%eax),%eax
    3fe5:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3fe8:	75 05                	jne    3fef <strchr+0x1e>
      return (char*)s;
    3fea:	8b 45 08             	mov    0x8(%ebp),%eax
    3fed:	eb 13                	jmp    4002 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3fef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3ff3:	8b 45 08             	mov    0x8(%ebp),%eax
    3ff6:	0f b6 00             	movzbl (%eax),%eax
    3ff9:	84 c0                	test   %al,%al
    3ffb:	75 e2                	jne    3fdf <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3ffd:	b8 00 00 00 00       	mov    $0x0,%eax
}
    4002:	c9                   	leave  
    4003:	c3                   	ret    

00004004 <gets>:

char*
gets(char *buf, int max)
{
    4004:	55                   	push   %ebp
    4005:	89 e5                	mov    %esp,%ebp
    4007:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    400a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    4011:	eb 4c                	jmp    405f <gets+0x5b>
    cc = read(0, &c, 1);
    4013:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    401a:	00 
    401b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    401e:	89 44 24 04          	mov    %eax,0x4(%esp)
    4022:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4029:	e8 44 01 00 00       	call   4172 <read>
    402e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    4031:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4035:	7f 02                	jg     4039 <gets+0x35>
      break;
    4037:	eb 31                	jmp    406a <gets+0x66>
    buf[i++] = c;
    4039:	8b 45 f4             	mov    -0xc(%ebp),%eax
    403c:	8d 50 01             	lea    0x1(%eax),%edx
    403f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4042:	89 c2                	mov    %eax,%edx
    4044:	8b 45 08             	mov    0x8(%ebp),%eax
    4047:	01 c2                	add    %eax,%edx
    4049:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    404d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    404f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    4053:	3c 0a                	cmp    $0xa,%al
    4055:	74 13                	je     406a <gets+0x66>
    4057:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    405b:	3c 0d                	cmp    $0xd,%al
    405d:	74 0b                	je     406a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    405f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4062:	83 c0 01             	add    $0x1,%eax
    4065:	3b 45 0c             	cmp    0xc(%ebp),%eax
    4068:	7c a9                	jl     4013 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    406a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    406d:	8b 45 08             	mov    0x8(%ebp),%eax
    4070:	01 d0                	add    %edx,%eax
    4072:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    4075:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4078:	c9                   	leave  
    4079:	c3                   	ret    

0000407a <stat>:

int
stat(char *n, struct stat *st)
{
    407a:	55                   	push   %ebp
    407b:	89 e5                	mov    %esp,%ebp
    407d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4080:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    4087:	00 
    4088:	8b 45 08             	mov    0x8(%ebp),%eax
    408b:	89 04 24             	mov    %eax,(%esp)
    408e:	e8 07 01 00 00       	call   419a <open>
    4093:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    4096:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    409a:	79 07                	jns    40a3 <stat+0x29>
    return -1;
    409c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    40a1:	eb 23                	jmp    40c6 <stat+0x4c>
  r = fstat(fd, st);
    40a3:	8b 45 0c             	mov    0xc(%ebp),%eax
    40a6:	89 44 24 04          	mov    %eax,0x4(%esp)
    40aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40ad:	89 04 24             	mov    %eax,(%esp)
    40b0:	e8 fd 00 00 00       	call   41b2 <fstat>
    40b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    40b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40bb:	89 04 24             	mov    %eax,(%esp)
    40be:	e8 bf 00 00 00       	call   4182 <close>
  return r;
    40c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    40c6:	c9                   	leave  
    40c7:	c3                   	ret    

000040c8 <atoi>:

int
atoi(const char *s)
{
    40c8:	55                   	push   %ebp
    40c9:	89 e5                	mov    %esp,%ebp
    40cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    40ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    40d5:	eb 25                	jmp    40fc <atoi+0x34>
    n = n*10 + *s++ - '0';
    40d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    40da:	89 d0                	mov    %edx,%eax
    40dc:	c1 e0 02             	shl    $0x2,%eax
    40df:	01 d0                	add    %edx,%eax
    40e1:	01 c0                	add    %eax,%eax
    40e3:	89 c1                	mov    %eax,%ecx
    40e5:	8b 45 08             	mov    0x8(%ebp),%eax
    40e8:	8d 50 01             	lea    0x1(%eax),%edx
    40eb:	89 55 08             	mov    %edx,0x8(%ebp)
    40ee:	0f b6 00             	movzbl (%eax),%eax
    40f1:	0f be c0             	movsbl %al,%eax
    40f4:	01 c8                	add    %ecx,%eax
    40f6:	83 e8 30             	sub    $0x30,%eax
    40f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    40fc:	8b 45 08             	mov    0x8(%ebp),%eax
    40ff:	0f b6 00             	movzbl (%eax),%eax
    4102:	3c 2f                	cmp    $0x2f,%al
    4104:	7e 0a                	jle    4110 <atoi+0x48>
    4106:	8b 45 08             	mov    0x8(%ebp),%eax
    4109:	0f b6 00             	movzbl (%eax),%eax
    410c:	3c 39                	cmp    $0x39,%al
    410e:	7e c7                	jle    40d7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    4110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4113:	c9                   	leave  
    4114:	c3                   	ret    

00004115 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    4115:	55                   	push   %ebp
    4116:	89 e5                	mov    %esp,%ebp
    4118:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    411b:	8b 45 08             	mov    0x8(%ebp),%eax
    411e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    4121:	8b 45 0c             	mov    0xc(%ebp),%eax
    4124:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    4127:	eb 17                	jmp    4140 <memmove+0x2b>
    *dst++ = *src++;
    4129:	8b 45 fc             	mov    -0x4(%ebp),%eax
    412c:	8d 50 01             	lea    0x1(%eax),%edx
    412f:	89 55 fc             	mov    %edx,-0x4(%ebp)
    4132:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4135:	8d 4a 01             	lea    0x1(%edx),%ecx
    4138:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    413b:	0f b6 12             	movzbl (%edx),%edx
    413e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    4140:	8b 45 10             	mov    0x10(%ebp),%eax
    4143:	8d 50 ff             	lea    -0x1(%eax),%edx
    4146:	89 55 10             	mov    %edx,0x10(%ebp)
    4149:	85 c0                	test   %eax,%eax
    414b:	7f dc                	jg     4129 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    414d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4150:	c9                   	leave  
    4151:	c3                   	ret    

00004152 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    4152:	b8 01 00 00 00       	mov    $0x1,%eax
    4157:	cd 40                	int    $0x40
    4159:	c3                   	ret    

0000415a <exit>:
SYSCALL(exit)
    415a:	b8 02 00 00 00       	mov    $0x2,%eax
    415f:	cd 40                	int    $0x40
    4161:	c3                   	ret    

00004162 <wait>:
SYSCALL(wait)
    4162:	b8 03 00 00 00       	mov    $0x3,%eax
    4167:	cd 40                	int    $0x40
    4169:	c3                   	ret    

0000416a <pipe>:
SYSCALL(pipe)
    416a:	b8 04 00 00 00       	mov    $0x4,%eax
    416f:	cd 40                	int    $0x40
    4171:	c3                   	ret    

00004172 <read>:
SYSCALL(read)
    4172:	b8 05 00 00 00       	mov    $0x5,%eax
    4177:	cd 40                	int    $0x40
    4179:	c3                   	ret    

0000417a <write>:
SYSCALL(write)
    417a:	b8 10 00 00 00       	mov    $0x10,%eax
    417f:	cd 40                	int    $0x40
    4181:	c3                   	ret    

00004182 <close>:
SYSCALL(close)
    4182:	b8 15 00 00 00       	mov    $0x15,%eax
    4187:	cd 40                	int    $0x40
    4189:	c3                   	ret    

0000418a <kill>:
SYSCALL(kill)
    418a:	b8 06 00 00 00       	mov    $0x6,%eax
    418f:	cd 40                	int    $0x40
    4191:	c3                   	ret    

00004192 <exec>:
SYSCALL(exec)
    4192:	b8 07 00 00 00       	mov    $0x7,%eax
    4197:	cd 40                	int    $0x40
    4199:	c3                   	ret    

0000419a <open>:
SYSCALL(open)
    419a:	b8 0f 00 00 00       	mov    $0xf,%eax
    419f:	cd 40                	int    $0x40
    41a1:	c3                   	ret    

000041a2 <mknod>:
SYSCALL(mknod)
    41a2:	b8 11 00 00 00       	mov    $0x11,%eax
    41a7:	cd 40                	int    $0x40
    41a9:	c3                   	ret    

000041aa <unlink>:
SYSCALL(unlink)
    41aa:	b8 12 00 00 00       	mov    $0x12,%eax
    41af:	cd 40                	int    $0x40
    41b1:	c3                   	ret    

000041b2 <fstat>:
SYSCALL(fstat)
    41b2:	b8 08 00 00 00       	mov    $0x8,%eax
    41b7:	cd 40                	int    $0x40
    41b9:	c3                   	ret    

000041ba <link>:
SYSCALL(link)
    41ba:	b8 13 00 00 00       	mov    $0x13,%eax
    41bf:	cd 40                	int    $0x40
    41c1:	c3                   	ret    

000041c2 <mkdir>:
SYSCALL(mkdir)
    41c2:	b8 14 00 00 00       	mov    $0x14,%eax
    41c7:	cd 40                	int    $0x40
    41c9:	c3                   	ret    

000041ca <chdir>:
SYSCALL(chdir)
    41ca:	b8 09 00 00 00       	mov    $0x9,%eax
    41cf:	cd 40                	int    $0x40
    41d1:	c3                   	ret    

000041d2 <dup>:
SYSCALL(dup)
    41d2:	b8 0a 00 00 00       	mov    $0xa,%eax
    41d7:	cd 40                	int    $0x40
    41d9:	c3                   	ret    

000041da <getpid>:
SYSCALL(getpid)
    41da:	b8 0b 00 00 00       	mov    $0xb,%eax
    41df:	cd 40                	int    $0x40
    41e1:	c3                   	ret    

000041e2 <sbrk>:
SYSCALL(sbrk)
    41e2:	b8 0c 00 00 00       	mov    $0xc,%eax
    41e7:	cd 40                	int    $0x40
    41e9:	c3                   	ret    

000041ea <sleep>:
SYSCALL(sleep)
    41ea:	b8 0d 00 00 00       	mov    $0xd,%eax
    41ef:	cd 40                	int    $0x40
    41f1:	c3                   	ret    

000041f2 <uptime>:
SYSCALL(uptime)
    41f2:	b8 0e 00 00 00       	mov    $0xe,%eax
    41f7:	cd 40                	int    $0x40
    41f9:	c3                   	ret    

000041fa <getMsg>:
SYSCALL(getMsg)
    41fa:	b8 16 00 00 00       	mov    $0x16,%eax
    41ff:	cd 40                	int    $0x40
    4201:	c3                   	ret    

00004202 <createWindow>:
SYSCALL(createWindow)
    4202:	b8 17 00 00 00       	mov    $0x17,%eax
    4207:	cd 40                	int    $0x40
    4209:	c3                   	ret    

0000420a <destroyWindow>:
SYSCALL(destroyWindow)
    420a:	b8 18 00 00 00       	mov    $0x18,%eax
    420f:	cd 40                	int    $0x40
    4211:	c3                   	ret    

00004212 <updateWindow>:
SYSCALL(updateWindow)
    4212:	b8 19 00 00 00       	mov    $0x19,%eax
    4217:	cd 40                	int    $0x40
    4219:	c3                   	ret    

0000421a <updatePartialWindow>:
SYSCALL(updatePartialWindow)
    421a:	b8 1a 00 00 00       	mov    $0x1a,%eax
    421f:	cd 40                	int    $0x40
    4221:	c3                   	ret    

00004222 <kwrite>:
SYSCALL(kwrite)
    4222:	b8 1c 00 00 00       	mov    $0x1c,%eax
    4227:	cd 40                	int    $0x40
    4229:	c3                   	ret    

0000422a <setSampleRate>:
SYSCALL(setSampleRate)
    422a:	b8 1b 00 00 00       	mov    $0x1b,%eax
    422f:	cd 40                	int    $0x40
    4231:	c3                   	ret    

00004232 <pause>:
SYSCALL(pause)
    4232:	b8 1d 00 00 00       	mov    $0x1d,%eax
    4237:	cd 40                	int    $0x40
    4239:	c3                   	ret    

0000423a <wavdecode>:
SYSCALL(wavdecode)
    423a:	b8 1e 00 00 00       	mov    $0x1e,%eax
    423f:	cd 40                	int    $0x40
    4241:	c3                   	ret    

00004242 <beginDecode>:
SYSCALL(beginDecode)
    4242:	b8 1f 00 00 00       	mov    $0x1f,%eax
    4247:	cd 40                	int    $0x40
    4249:	c3                   	ret    

0000424a <waitForDecode>:
SYSCALL(waitForDecode)
    424a:	b8 20 00 00 00       	mov    $0x20,%eax
    424f:	cd 40                	int    $0x40
    4251:	c3                   	ret    

00004252 <endDecode>:
SYSCALL(endDecode)
    4252:	b8 21 00 00 00       	mov    $0x21,%eax
    4257:	cd 40                	int    $0x40
    4259:	c3                   	ret    

0000425a <getCoreBuf>:
    425a:	b8 22 00 00 00       	mov    $0x22,%eax
    425f:	cd 40                	int    $0x40
    4261:	c3                   	ret    

00004262 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    4262:	55                   	push   %ebp
    4263:	89 e5                	mov    %esp,%ebp
    4265:	83 ec 18             	sub    $0x18,%esp
    4268:	8b 45 0c             	mov    0xc(%ebp),%eax
    426b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    426e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    4275:	00 
    4276:	8d 45 f4             	lea    -0xc(%ebp),%eax
    4279:	89 44 24 04          	mov    %eax,0x4(%esp)
    427d:	8b 45 08             	mov    0x8(%ebp),%eax
    4280:	89 04 24             	mov    %eax,(%esp)
    4283:	e8 f2 fe ff ff       	call   417a <write>
}
    4288:	c9                   	leave  
    4289:	c3                   	ret    

0000428a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    428a:	55                   	push   %ebp
    428b:	89 e5                	mov    %esp,%ebp
    428d:	56                   	push   %esi
    428e:	53                   	push   %ebx
    428f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    4292:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    4299:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    429d:	74 17                	je     42b6 <printint+0x2c>
    429f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    42a3:	79 11                	jns    42b6 <printint+0x2c>
    neg = 1;
    42a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    42ac:	8b 45 0c             	mov    0xc(%ebp),%eax
    42af:	f7 d8                	neg    %eax
    42b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    42b4:	eb 06                	jmp    42bc <printint+0x32>
  } else {
    x = xx;
    42b6:	8b 45 0c             	mov    0xc(%ebp),%eax
    42b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    42bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    42c3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    42c6:	8d 41 01             	lea    0x1(%ecx),%eax
    42c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    42cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
    42cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    42d2:	ba 00 00 00 00       	mov    $0x0,%edx
    42d7:	f7 f3                	div    %ebx
    42d9:	89 d0                	mov    %edx,%eax
    42db:	0f b6 80 00 e7 00 00 	movzbl 0xe700(%eax),%eax
    42e2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    42e6:	8b 75 10             	mov    0x10(%ebp),%esi
    42e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    42ec:	ba 00 00 00 00       	mov    $0x0,%edx
    42f1:	f7 f6                	div    %esi
    42f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    42f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    42fa:	75 c7                	jne    42c3 <printint+0x39>
  if(neg)
    42fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4300:	74 10                	je     4312 <printint+0x88>
    buf[i++] = '-';
    4302:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4305:	8d 50 01             	lea    0x1(%eax),%edx
    4308:	89 55 f4             	mov    %edx,-0xc(%ebp)
    430b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    4310:	eb 1f                	jmp    4331 <printint+0xa7>
    4312:	eb 1d                	jmp    4331 <printint+0xa7>
    putc(fd, buf[i]);
    4314:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4317:	8b 45 f4             	mov    -0xc(%ebp),%eax
    431a:	01 d0                	add    %edx,%eax
    431c:	0f b6 00             	movzbl (%eax),%eax
    431f:	0f be c0             	movsbl %al,%eax
    4322:	89 44 24 04          	mov    %eax,0x4(%esp)
    4326:	8b 45 08             	mov    0x8(%ebp),%eax
    4329:	89 04 24             	mov    %eax,(%esp)
    432c:	e8 31 ff ff ff       	call   4262 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    4331:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    4335:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4339:	79 d9                	jns    4314 <printint+0x8a>
    putc(fd, buf[i]);
}
    433b:	83 c4 30             	add    $0x30,%esp
    433e:	5b                   	pop    %ebx
    433f:	5e                   	pop    %esi
    4340:	5d                   	pop    %ebp
    4341:	c3                   	ret    

00004342 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4342:	55                   	push   %ebp
    4343:	89 e5                	mov    %esp,%ebp
    4345:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    4348:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    434f:	8d 45 0c             	lea    0xc(%ebp),%eax
    4352:	83 c0 04             	add    $0x4,%eax
    4355:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    4358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    435f:	e9 7c 01 00 00       	jmp    44e0 <printf+0x19e>
    c = fmt[i] & 0xff;
    4364:	8b 55 0c             	mov    0xc(%ebp),%edx
    4367:	8b 45 f0             	mov    -0x10(%ebp),%eax
    436a:	01 d0                	add    %edx,%eax
    436c:	0f b6 00             	movzbl (%eax),%eax
    436f:	0f be c0             	movsbl %al,%eax
    4372:	25 ff 00 00 00       	and    $0xff,%eax
    4377:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    437a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    437e:	75 2c                	jne    43ac <printf+0x6a>
      if(c == '%'){
    4380:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4384:	75 0c                	jne    4392 <printf+0x50>
        state = '%';
    4386:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    438d:	e9 4a 01 00 00       	jmp    44dc <printf+0x19a>
      } else {
        putc(fd, c);
    4392:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4395:	0f be c0             	movsbl %al,%eax
    4398:	89 44 24 04          	mov    %eax,0x4(%esp)
    439c:	8b 45 08             	mov    0x8(%ebp),%eax
    439f:	89 04 24             	mov    %eax,(%esp)
    43a2:	e8 bb fe ff ff       	call   4262 <putc>
    43a7:	e9 30 01 00 00       	jmp    44dc <printf+0x19a>
      }
    } else if(state == '%'){
    43ac:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    43b0:	0f 85 26 01 00 00    	jne    44dc <printf+0x19a>
      if(c == 'd'){
    43b6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    43ba:	75 2d                	jne    43e9 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    43bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    43bf:	8b 00                	mov    (%eax),%eax
    43c1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    43c8:	00 
    43c9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    43d0:	00 
    43d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    43d5:	8b 45 08             	mov    0x8(%ebp),%eax
    43d8:	89 04 24             	mov    %eax,(%esp)
    43db:	e8 aa fe ff ff       	call   428a <printint>
        ap++;
    43e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    43e4:	e9 ec 00 00 00       	jmp    44d5 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    43e9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    43ed:	74 06                	je     43f5 <printf+0xb3>
    43ef:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    43f3:	75 2d                	jne    4422 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    43f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    43f8:	8b 00                	mov    (%eax),%eax
    43fa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    4401:	00 
    4402:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    4409:	00 
    440a:	89 44 24 04          	mov    %eax,0x4(%esp)
    440e:	8b 45 08             	mov    0x8(%ebp),%eax
    4411:	89 04 24             	mov    %eax,(%esp)
    4414:	e8 71 fe ff ff       	call   428a <printint>
        ap++;
    4419:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    441d:	e9 b3 00 00 00       	jmp    44d5 <printf+0x193>
      } else if(c == 's'){
    4422:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    4426:	75 45                	jne    446d <printf+0x12b>
        s = (char*)*ap;
    4428:	8b 45 e8             	mov    -0x18(%ebp),%eax
    442b:	8b 00                	mov    (%eax),%eax
    442d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4430:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    4434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4438:	75 09                	jne    4443 <printf+0x101>
          s = "(null)";
    443a:	c7 45 f4 0f af 00 00 	movl   $0xaf0f,-0xc(%ebp)
        while(*s != 0){
    4441:	eb 1e                	jmp    4461 <printf+0x11f>
    4443:	eb 1c                	jmp    4461 <printf+0x11f>
          putc(fd, *s);
    4445:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4448:	0f b6 00             	movzbl (%eax),%eax
    444b:	0f be c0             	movsbl %al,%eax
    444e:	89 44 24 04          	mov    %eax,0x4(%esp)
    4452:	8b 45 08             	mov    0x8(%ebp),%eax
    4455:	89 04 24             	mov    %eax,(%esp)
    4458:	e8 05 fe ff ff       	call   4262 <putc>
          s++;
    445d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4461:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4464:	0f b6 00             	movzbl (%eax),%eax
    4467:	84 c0                	test   %al,%al
    4469:	75 da                	jne    4445 <printf+0x103>
    446b:	eb 68                	jmp    44d5 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    446d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4471:	75 1d                	jne    4490 <printf+0x14e>
        putc(fd, *ap);
    4473:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4476:	8b 00                	mov    (%eax),%eax
    4478:	0f be c0             	movsbl %al,%eax
    447b:	89 44 24 04          	mov    %eax,0x4(%esp)
    447f:	8b 45 08             	mov    0x8(%ebp),%eax
    4482:	89 04 24             	mov    %eax,(%esp)
    4485:	e8 d8 fd ff ff       	call   4262 <putc>
        ap++;
    448a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    448e:	eb 45                	jmp    44d5 <printf+0x193>
      } else if(c == '%'){
    4490:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4494:	75 17                	jne    44ad <printf+0x16b>
        putc(fd, c);
    4496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4499:	0f be c0             	movsbl %al,%eax
    449c:	89 44 24 04          	mov    %eax,0x4(%esp)
    44a0:	8b 45 08             	mov    0x8(%ebp),%eax
    44a3:	89 04 24             	mov    %eax,(%esp)
    44a6:	e8 b7 fd ff ff       	call   4262 <putc>
    44ab:	eb 28                	jmp    44d5 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    44ad:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    44b4:	00 
    44b5:	8b 45 08             	mov    0x8(%ebp),%eax
    44b8:	89 04 24             	mov    %eax,(%esp)
    44bb:	e8 a2 fd ff ff       	call   4262 <putc>
        putc(fd, c);
    44c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    44c3:	0f be c0             	movsbl %al,%eax
    44c6:	89 44 24 04          	mov    %eax,0x4(%esp)
    44ca:	8b 45 08             	mov    0x8(%ebp),%eax
    44cd:	89 04 24             	mov    %eax,(%esp)
    44d0:	e8 8d fd ff ff       	call   4262 <putc>
      }
      state = 0;
    44d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    44dc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    44e0:	8b 55 0c             	mov    0xc(%ebp),%edx
    44e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44e6:	01 d0                	add    %edx,%eax
    44e8:	0f b6 00             	movzbl (%eax),%eax
    44eb:	84 c0                	test   %al,%al
    44ed:	0f 85 71 fe ff ff    	jne    4364 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    44f3:	c9                   	leave  
    44f4:	c3                   	ret    

000044f5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    44f5:	55                   	push   %ebp
    44f6:	89 e5                	mov    %esp,%ebp
    44f8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    44fb:	8b 45 08             	mov    0x8(%ebp),%eax
    44fe:	83 e8 08             	sub    $0x8,%eax
    4501:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4504:	a1 1c ec 00 00       	mov    0xec1c,%eax
    4509:	89 45 fc             	mov    %eax,-0x4(%ebp)
    450c:	eb 24                	jmp    4532 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    450e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4511:	8b 00                	mov    (%eax),%eax
    4513:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4516:	77 12                	ja     452a <free+0x35>
    4518:	8b 45 f8             	mov    -0x8(%ebp),%eax
    451b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    451e:	77 24                	ja     4544 <free+0x4f>
    4520:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4523:	8b 00                	mov    (%eax),%eax
    4525:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4528:	77 1a                	ja     4544 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    452a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    452d:	8b 00                	mov    (%eax),%eax
    452f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4532:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4535:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4538:	76 d4                	jbe    450e <free+0x19>
    453a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    453d:	8b 00                	mov    (%eax),%eax
    453f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4542:	76 ca                	jbe    450e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    4544:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4547:	8b 40 04             	mov    0x4(%eax),%eax
    454a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4551:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4554:	01 c2                	add    %eax,%edx
    4556:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4559:	8b 00                	mov    (%eax),%eax
    455b:	39 c2                	cmp    %eax,%edx
    455d:	75 24                	jne    4583 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    455f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4562:	8b 50 04             	mov    0x4(%eax),%edx
    4565:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4568:	8b 00                	mov    (%eax),%eax
    456a:	8b 40 04             	mov    0x4(%eax),%eax
    456d:	01 c2                	add    %eax,%edx
    456f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4572:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    4575:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4578:	8b 00                	mov    (%eax),%eax
    457a:	8b 10                	mov    (%eax),%edx
    457c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    457f:	89 10                	mov    %edx,(%eax)
    4581:	eb 0a                	jmp    458d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    4583:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4586:	8b 10                	mov    (%eax),%edx
    4588:	8b 45 f8             	mov    -0x8(%ebp),%eax
    458b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    458d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4590:	8b 40 04             	mov    0x4(%eax),%eax
    4593:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    459a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    459d:	01 d0                	add    %edx,%eax
    459f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    45a2:	75 20                	jne    45c4 <free+0xcf>
    p->s.size += bp->s.size;
    45a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    45a7:	8b 50 04             	mov    0x4(%eax),%edx
    45aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    45ad:	8b 40 04             	mov    0x4(%eax),%eax
    45b0:	01 c2                	add    %eax,%edx
    45b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    45b5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    45b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    45bb:	8b 10                	mov    (%eax),%edx
    45bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    45c0:	89 10                	mov    %edx,(%eax)
    45c2:	eb 08                	jmp    45cc <free+0xd7>
  } else
    p->s.ptr = bp;
    45c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    45c7:	8b 55 f8             	mov    -0x8(%ebp),%edx
    45ca:	89 10                	mov    %edx,(%eax)
  freep = p;
    45cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    45cf:	a3 1c ec 00 00       	mov    %eax,0xec1c
}
    45d4:	c9                   	leave  
    45d5:	c3                   	ret    

000045d6 <morecore>:

static Header*
morecore(uint nu)
{
    45d6:	55                   	push   %ebp
    45d7:	89 e5                	mov    %esp,%ebp
    45d9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    45dc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    45e3:	77 07                	ja     45ec <morecore+0x16>
    nu = 4096;
    45e5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    45ec:	8b 45 08             	mov    0x8(%ebp),%eax
    45ef:	c1 e0 03             	shl    $0x3,%eax
    45f2:	89 04 24             	mov    %eax,(%esp)
    45f5:	e8 e8 fb ff ff       	call   41e2 <sbrk>
    45fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    45fd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    4601:	75 07                	jne    460a <morecore+0x34>
    return 0;
    4603:	b8 00 00 00 00       	mov    $0x0,%eax
    4608:	eb 22                	jmp    462c <morecore+0x56>
  hp = (Header*)p;
    460a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    460d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    4610:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4613:	8b 55 08             	mov    0x8(%ebp),%edx
    4616:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    4619:	8b 45 f0             	mov    -0x10(%ebp),%eax
    461c:	83 c0 08             	add    $0x8,%eax
    461f:	89 04 24             	mov    %eax,(%esp)
    4622:	e8 ce fe ff ff       	call   44f5 <free>
  return freep;
    4627:	a1 1c ec 00 00       	mov    0xec1c,%eax
}
    462c:	c9                   	leave  
    462d:	c3                   	ret    

0000462e <malloc>:

void*
malloc(uint nbytes)
{
    462e:	55                   	push   %ebp
    462f:	89 e5                	mov    %esp,%ebp
    4631:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4634:	8b 45 08             	mov    0x8(%ebp),%eax
    4637:	83 c0 07             	add    $0x7,%eax
    463a:	c1 e8 03             	shr    $0x3,%eax
    463d:	83 c0 01             	add    $0x1,%eax
    4640:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4643:	a1 1c ec 00 00       	mov    0xec1c,%eax
    4648:	89 45 f0             	mov    %eax,-0x10(%ebp)
    464b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    464f:	75 23                	jne    4674 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    4651:	c7 45 f0 14 ec 00 00 	movl   $0xec14,-0x10(%ebp)
    4658:	8b 45 f0             	mov    -0x10(%ebp),%eax
    465b:	a3 1c ec 00 00       	mov    %eax,0xec1c
    4660:	a1 1c ec 00 00       	mov    0xec1c,%eax
    4665:	a3 14 ec 00 00       	mov    %eax,0xec14
    base.s.size = 0;
    466a:	c7 05 18 ec 00 00 00 	movl   $0x0,0xec18
    4671:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4674:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4677:	8b 00                	mov    (%eax),%eax
    4679:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    467c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    467f:	8b 40 04             	mov    0x4(%eax),%eax
    4682:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4685:	72 4d                	jb     46d4 <malloc+0xa6>
      if(p->s.size == nunits)
    4687:	8b 45 f4             	mov    -0xc(%ebp),%eax
    468a:	8b 40 04             	mov    0x4(%eax),%eax
    468d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4690:	75 0c                	jne    469e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    4692:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4695:	8b 10                	mov    (%eax),%edx
    4697:	8b 45 f0             	mov    -0x10(%ebp),%eax
    469a:	89 10                	mov    %edx,(%eax)
    469c:	eb 26                	jmp    46c4 <malloc+0x96>
      else {
        p->s.size -= nunits;
    469e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    46a1:	8b 40 04             	mov    0x4(%eax),%eax
    46a4:	2b 45 ec             	sub    -0x14(%ebp),%eax
    46a7:	89 c2                	mov    %eax,%edx
    46a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    46ac:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    46af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    46b2:	8b 40 04             	mov    0x4(%eax),%eax
    46b5:	c1 e0 03             	shl    $0x3,%eax
    46b8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    46bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    46be:	8b 55 ec             	mov    -0x14(%ebp),%edx
    46c1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    46c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    46c7:	a3 1c ec 00 00       	mov    %eax,0xec1c
      return (void*)(p + 1);
    46cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    46cf:	83 c0 08             	add    $0x8,%eax
    46d2:	eb 38                	jmp    470c <malloc+0xde>
    }
    if(p == freep)
    46d4:	a1 1c ec 00 00       	mov    0xec1c,%eax
    46d9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    46dc:	75 1b                	jne    46f9 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    46de:	8b 45 ec             	mov    -0x14(%ebp),%eax
    46e1:	89 04 24             	mov    %eax,(%esp)
    46e4:	e8 ed fe ff ff       	call   45d6 <morecore>
    46e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    46ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    46f0:	75 07                	jne    46f9 <malloc+0xcb>
        return 0;
    46f2:	b8 00 00 00 00       	mov    $0x0,%eax
    46f7:	eb 13                	jmp    470c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    46f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    46fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    46ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4702:	8b 00                	mov    (%eax),%eax
    4704:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    4707:	e9 70 ff ff ff       	jmp    467c <malloc+0x4e>
}
    470c:	c9                   	leave  
    470d:	c3                   	ret    

0000470e <abs>:
#include "math.h"
#define pi 3.1415926535898 
int abs(int x)
{
    470e:	55                   	push   %ebp
    470f:	89 e5                	mov    %esp,%ebp
	if (x < 0)
    4711:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    4715:	79 07                	jns    471e <abs+0x10>
		return x * -1;
    4717:	8b 45 08             	mov    0x8(%ebp),%eax
    471a:	f7 d8                	neg    %eax
    471c:	eb 03                	jmp    4721 <abs+0x13>
	else
		return x;
    471e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4721:	5d                   	pop    %ebp
    4722:	c3                   	ret    

00004723 <sin>:
double sin(double x)  
{  
    4723:	55                   	push   %ebp
    4724:	89 e5                	mov    %esp,%ebp
    4726:	83 ec 3c             	sub    $0x3c,%esp
    4729:	8b 45 08             	mov    0x8(%ebp),%eax
    472c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    472f:	8b 45 0c             	mov    0xc(%ebp),%eax
    4732:	89 45 cc             	mov    %eax,-0x34(%ebp)
	double Result=x,Fac=1.0,Xn=x,Precious=x;  
    4735:	dd 45 c8             	fldl   -0x38(%ebp)
    4738:	dd 5d f8             	fstpl  -0x8(%ebp)
    473b:	d9 e8                	fld1   
    473d:	dd 5d f0             	fstpl  -0x10(%ebp)
    4740:	dd 45 c8             	fldl   -0x38(%ebp)
    4743:	dd 5d e8             	fstpl  -0x18(%ebp)
    4746:	dd 45 c8             	fldl   -0x38(%ebp)
    4749:	dd 5d e0             	fstpl  -0x20(%ebp)
	int n=1,sign=1;  
    474c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
    4753:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	while(Precious>1e-6)  
    475a:	eb 50                	jmp    47ac <sin+0x89>
	{  
		n = n+1;  
    475c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
		Fac=Fac*n*(n + 1);
    4760:	db 45 dc             	fildl  -0x24(%ebp)
    4763:	dc 4d f0             	fmull  -0x10(%ebp)
    4766:	8b 45 dc             	mov    -0x24(%ebp),%eax
    4769:	83 c0 01             	add    $0x1,%eax
    476c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    476f:	db 45 c4             	fildl  -0x3c(%ebp)
    4772:	de c9                	fmulp  %st,%st(1)
    4774:	dd 5d f0             	fstpl  -0x10(%ebp)
		n = n + 1;  
    4777:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
		Xn*=x*x;  
    477b:	dd 45 c8             	fldl   -0x38(%ebp)
    477e:	dc 4d c8             	fmull  -0x38(%ebp)
    4781:	dd 45 e8             	fldl   -0x18(%ebp)
    4784:	de c9                	fmulp  %st,%st(1)
    4786:	dd 5d e8             	fstpl  -0x18(%ebp)
		sign=-sign;  
    4789:	f7 5d d8             	negl   -0x28(%ebp)
		Precious=Xn/Fac;  
    478c:	dd 45 e8             	fldl   -0x18(%ebp)
    478f:	dc 75 f0             	fdivl  -0x10(%ebp)
    4792:	dd 5d e0             	fstpl  -0x20(%ebp)
		Result=sign>0?Result+Precious:Result-Precious;  
    4795:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    4799:	7e 08                	jle    47a3 <sin+0x80>
    479b:	dd 45 f8             	fldl   -0x8(%ebp)
    479e:	dc 45 e0             	faddl  -0x20(%ebp)
    47a1:	eb 06                	jmp    47a9 <sin+0x86>
    47a3:	dd 45 f8             	fldl   -0x8(%ebp)
    47a6:	dc 65 e0             	fsubl  -0x20(%ebp)
    47a9:	dd 5d f8             	fstpl  -0x8(%ebp)
}
double sin(double x)  
{  
	double Result=x,Fac=1.0,Xn=x,Precious=x;  
	int n=1,sign=1;  
	while(Precious>1e-6)  
    47ac:	dd 45 e0             	fldl   -0x20(%ebp)
    47af:	dd 05 18 af 00 00    	fldl   0xaf18
    47b5:	d9 c9                	fxch   %st(1)
    47b7:	df e9                	fucomip %st(1),%st
    47b9:	dd d8                	fstp   %st(0)
    47bb:	77 9f                	ja     475c <sin+0x39>
		Xn*=x*x;  
		sign=-sign;  
		Precious=Xn/Fac;  
		Result=sign>0?Result+Precious:Result-Precious;  
	}  
	return Result;  
    47bd:	dd 45 f8             	fldl   -0x8(%ebp)
}  
    47c0:	c9                   	leave  
    47c1:	c3                   	ret    

000047c2 <cos>:
double cos(double x)  
{  
    47c2:	55                   	push   %ebp
    47c3:	89 e5                	mov    %esp,%ebp
    47c5:	83 ec 10             	sub    $0x10,%esp
    47c8:	8b 45 08             	mov    0x8(%ebp),%eax
    47cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    47ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    47d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return sin(pi/2-x);  
    47d4:	dd 05 20 af 00 00    	fldl   0xaf20
    47da:	dc 65 f8             	fsubl  -0x8(%ebp)
    47dd:	dd 1c 24             	fstpl  (%esp)
    47e0:	e8 3e ff ff ff       	call   4723 <sin>
}  
    47e5:	c9                   	leave  
    47e6:	c3                   	ret    

000047e7 <tan>:
double tan(double x)  
{  
    47e7:	55                   	push   %ebp
    47e8:	89 e5                	mov    %esp,%ebp
    47ea:	83 ec 18             	sub    $0x18,%esp
    47ed:	8b 45 08             	mov    0x8(%ebp),%eax
    47f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    47f3:	8b 45 0c             	mov    0xc(%ebp),%eax
    47f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return sin(x)/cos(x);  
    47f9:	dd 45 f8             	fldl   -0x8(%ebp)
    47fc:	dd 1c 24             	fstpl  (%esp)
    47ff:	e8 1f ff ff ff       	call   4723 <sin>
    4804:	dd 5d f0             	fstpl  -0x10(%ebp)
    4807:	dd 45 f8             	fldl   -0x8(%ebp)
    480a:	dd 1c 24             	fstpl  (%esp)
    480d:	e8 b0 ff ff ff       	call   47c2 <cos>
    4812:	dc 7d f0             	fdivrl -0x10(%ebp)
}  
    4815:	c9                   	leave  
    4816:	c3                   	ret    

00004817 <pow>:

double pow(double x, double y)
{
    4817:	55                   	push   %ebp
    4818:	89 e5                	mov    %esp,%ebp
    481a:	83 ec 48             	sub    $0x48,%esp
    481d:	8b 45 08             	mov    0x8(%ebp),%eax
    4820:	89 45 e0             	mov    %eax,-0x20(%ebp)
    4823:	8b 45 0c             	mov    0xc(%ebp),%eax
    4826:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    4829:	8b 45 10             	mov    0x10(%ebp),%eax
    482c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    482f:	8b 45 14             	mov    0x14(%ebp),%eax
    4832:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(x==0 && y!=0) return 0;
    4835:	dd 45 e0             	fldl   -0x20(%ebp)
    4838:	d9 ee                	fldz   
    483a:	df e9                	fucomip %st(1),%st
    483c:	dd d8                	fstp   %st(0)
    483e:	7a 28                	jp     4868 <pow+0x51>
    4840:	dd 45 e0             	fldl   -0x20(%ebp)
    4843:	d9 ee                	fldz   
    4845:	df e9                	fucomip %st(1),%st
    4847:	dd d8                	fstp   %st(0)
    4849:	75 1d                	jne    4868 <pow+0x51>
    484b:	dd 45 d8             	fldl   -0x28(%ebp)
    484e:	d9 ee                	fldz   
    4850:	df e9                	fucomip %st(1),%st
    4852:	dd d8                	fstp   %st(0)
    4854:	7a 0b                	jp     4861 <pow+0x4a>
    4856:	dd 45 d8             	fldl   -0x28(%ebp)
    4859:	d9 ee                	fldz   
    485b:	df e9                	fucomip %st(1),%st
    485d:	dd d8                	fstp   %st(0)
    485f:	74 07                	je     4868 <pow+0x51>
    4861:	d9 ee                	fldz   
    4863:	e9 30 01 00 00       	jmp    4998 <pow+0x181>
	else if(x==0 && y==0) return 1;
    4868:	dd 45 e0             	fldl   -0x20(%ebp)
    486b:	d9 ee                	fldz   
    486d:	df e9                	fucomip %st(1),%st
    486f:	dd d8                	fstp   %st(0)
    4871:	7a 28                	jp     489b <pow+0x84>
    4873:	dd 45 e0             	fldl   -0x20(%ebp)
    4876:	d9 ee                	fldz   
    4878:	df e9                	fucomip %st(1),%st
    487a:	dd d8                	fstp   %st(0)
    487c:	75 1d                	jne    489b <pow+0x84>
    487e:	dd 45 d8             	fldl   -0x28(%ebp)
    4881:	d9 ee                	fldz   
    4883:	df e9                	fucomip %st(1),%st
    4885:	dd d8                	fstp   %st(0)
    4887:	7a 12                	jp     489b <pow+0x84>
    4889:	dd 45 d8             	fldl   -0x28(%ebp)
    488c:	d9 ee                	fldz   
    488e:	df e9                	fucomip %st(1),%st
    4890:	dd d8                	fstp   %st(0)
    4892:	75 07                	jne    489b <pow+0x84>
    4894:	d9 e8                	fld1   
    4896:	e9 fd 00 00 00       	jmp    4998 <pow+0x181>
	else if(y<0) return 1/pow(x,-y);//把指数小于0的情况转为1/x^-y计算
    489b:	d9 ee                	fldz   
    489d:	dd 45 d8             	fldl   -0x28(%ebp)
    48a0:	d9 c9                	fxch   %st(1)
    48a2:	df e9                	fucomip %st(1),%st
    48a4:	dd d8                	fstp   %st(0)
    48a6:	76 1d                	jbe    48c5 <pow+0xae>
    48a8:	dd 45 d8             	fldl   -0x28(%ebp)
    48ab:	d9 e0                	fchs   
    48ad:	dd 5c 24 08          	fstpl  0x8(%esp)
    48b1:	dd 45 e0             	fldl   -0x20(%ebp)
    48b4:	dd 1c 24             	fstpl  (%esp)
    48b7:	e8 5b ff ff ff       	call   4817 <pow>
    48bc:	d9 e8                	fld1   
    48be:	de f1                	fdivp  %st,%st(1)
    48c0:	e9 d3 00 00 00       	jmp    4998 <pow+0x181>
	else if(x<0 && y-(int)y!=0) return 0;//若x为负，且y不为整数数，则出错，返回0  
    48c5:	d9 ee                	fldz   
    48c7:	dd 45 e0             	fldl   -0x20(%ebp)
    48ca:	d9 c9                	fxch   %st(1)
    48cc:	df e9                	fucomip %st(1),%st
    48ce:	dd d8                	fstp   %st(0)
    48d0:	76 40                	jbe    4912 <pow+0xfb>
    48d2:	dd 45 d8             	fldl   -0x28(%ebp)
    48d5:	d9 7d d6             	fnstcw -0x2a(%ebp)
    48d8:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
    48dc:	b4 0c                	mov    $0xc,%ah
    48de:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
    48e2:	d9 6d d4             	fldcw  -0x2c(%ebp)
    48e5:	db 5d d0             	fistpl -0x30(%ebp)
    48e8:	d9 6d d6             	fldcw  -0x2a(%ebp)
    48eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
    48ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
    48f1:	db 45 d0             	fildl  -0x30(%ebp)
    48f4:	dd 45 d8             	fldl   -0x28(%ebp)
    48f7:	de e1                	fsubp  %st,%st(1)
    48f9:	d9 ee                	fldz   
    48fb:	df e9                	fucomip %st(1),%st
    48fd:	7a 0a                	jp     4909 <pow+0xf2>
    48ff:	d9 ee                	fldz   
    4901:	df e9                	fucomip %st(1),%st
    4903:	dd d8                	fstp   %st(0)
    4905:	74 0b                	je     4912 <pow+0xfb>
    4907:	eb 02                	jmp    490b <pow+0xf4>
    4909:	dd d8                	fstp   %st(0)
    490b:	d9 ee                	fldz   
    490d:	e9 86 00 00 00       	jmp    4998 <pow+0x181>
	else if(x<0 && y-(int)y==0)//若x为负，且y为整数数，则用循环计算 
    4912:	d9 ee                	fldz   
    4914:	dd 45 e0             	fldl   -0x20(%ebp)
    4917:	d9 c9                	fxch   %st(1)
    4919:	df e9                	fucomip %st(1),%st
    491b:	dd d8                	fstp   %st(0)
    491d:	76 63                	jbe    4982 <pow+0x16b>
    491f:	dd 45 d8             	fldl   -0x28(%ebp)
    4922:	d9 7d d6             	fnstcw -0x2a(%ebp)
    4925:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
    4929:	b4 0c                	mov    $0xc,%ah
    492b:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
    492f:	d9 6d d4             	fldcw  -0x2c(%ebp)
    4932:	db 5d d0             	fistpl -0x30(%ebp)
    4935:	d9 6d d6             	fldcw  -0x2a(%ebp)
    4938:	8b 45 d0             	mov    -0x30(%ebp),%eax
    493b:	89 45 d0             	mov    %eax,-0x30(%ebp)
    493e:	db 45 d0             	fildl  -0x30(%ebp)
    4941:	dd 45 d8             	fldl   -0x28(%ebp)
    4944:	de e1                	fsubp  %st,%st(1)
    4946:	d9 ee                	fldz   
    4948:	df e9                	fucomip %st(1),%st
    494a:	7a 34                	jp     4980 <pow+0x169>
    494c:	d9 ee                	fldz   
    494e:	df e9                	fucomip %st(1),%st
    4950:	dd d8                	fstp   %st(0)
    4952:	75 2e                	jne    4982 <pow+0x16b>
	{
		double powint=1;
    4954:	d9 e8                	fld1   
    4956:	dd 5d f0             	fstpl  -0x10(%ebp)
		int i;
		for(i=1;i<=y;i++) powint*=x;
    4959:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    4960:	eb 0d                	jmp    496f <pow+0x158>
    4962:	dd 45 f0             	fldl   -0x10(%ebp)
    4965:	dc 4d e0             	fmull  -0x20(%ebp)
    4968:	dd 5d f0             	fstpl  -0x10(%ebp)
    496b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    496f:	db 45 ec             	fildl  -0x14(%ebp)
    4972:	dd 45 d8             	fldl   -0x28(%ebp)
    4975:	df e9                	fucomip %st(1),%st
    4977:	dd d8                	fstp   %st(0)
    4979:	73 e7                	jae    4962 <pow+0x14b>
		return powint;
    497b:	dd 45 f0             	fldl   -0x10(%ebp)
    497e:	eb 18                	jmp    4998 <pow+0x181>
    4980:	dd d8                	fstp   %st(0)
	}
	return exp(y*ln(x));
    4982:	dd 45 e0             	fldl   -0x20(%ebp)
    4985:	dd 1c 24             	fstpl  (%esp)
    4988:	e8 36 00 00 00       	call   49c3 <ln>
    498d:	dc 4d d8             	fmull  -0x28(%ebp)
    4990:	dd 1c 24             	fstpl  (%esp)
    4993:	e8 0e 02 00 00       	call   4ba6 <exp>
}
    4998:	c9                   	leave  
    4999:	c3                   	ret    

0000499a <sqrt>:
// 求根
double sqrt(double x)
{
    499a:	55                   	push   %ebp
    499b:	89 e5                	mov    %esp,%ebp
    499d:	83 ec 28             	sub    $0x28,%esp
    49a0:	8b 45 08             	mov    0x8(%ebp),%eax
    49a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    49a6:	8b 45 0c             	mov    0xc(%ebp),%eax
    49a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pow(x,0.5);
    49ac:	dd 05 28 af 00 00    	fldl   0xaf28
    49b2:	dd 5c 24 08          	fstpl  0x8(%esp)
    49b6:	dd 45 f0             	fldl   -0x10(%ebp)
    49b9:	dd 1c 24             	fstpl  (%esp)
    49bc:	e8 56 fe ff ff       	call   4817 <pow>
}
    49c1:	c9                   	leave  
    49c2:	c3                   	ret    

000049c3 <ln>:

// ln(x) = 2 arctanh((x-1)/(x+1))
// 调用了Arctanh(double) 方法
double ln(double x)
{
    49c3:	55                   	push   %ebp
    49c4:	89 e5                	mov    %esp,%ebp
    49c6:	81 ec 88 00 00 00    	sub    $0x88,%esp
    49cc:	8b 45 08             	mov    0x8(%ebp),%eax
    49cf:	89 45 90             	mov    %eax,-0x70(%ebp)
    49d2:	8b 45 0c             	mov    0xc(%ebp),%eax
    49d5:	89 45 94             	mov    %eax,-0x6c(%ebp)
	double y=x-1,ln_p1=0,ln_p2=0,ln_p3=0,ln_px=0,ln_tmp=1,dln_px=1,tmp;
    49d8:	dd 45 90             	fldl   -0x70(%ebp)
    49db:	d9 e8                	fld1   
    49dd:	de e9                	fsubrp %st,%st(1)
    49df:	dd 5d c0             	fstpl  -0x40(%ebp)
    49e2:	d9 ee                	fldz   
    49e4:	dd 5d f0             	fstpl  -0x10(%ebp)
    49e7:	d9 ee                	fldz   
    49e9:	dd 5d b8             	fstpl  -0x48(%ebp)
    49ec:	d9 ee                	fldz   
    49ee:	dd 5d b0             	fstpl  -0x50(%ebp)
    49f1:	d9 ee                	fldz   
    49f3:	dd 5d e8             	fstpl  -0x18(%ebp)
    49f6:	d9 e8                	fld1   
    49f8:	dd 5d e0             	fstpl  -0x20(%ebp)
    49fb:	d9 e8                	fld1   
    49fd:	dd 5d a8             	fstpl  -0x58(%ebp)
	int l;
	if(x==1) return 0;
    4a00:	dd 45 90             	fldl   -0x70(%ebp)
    4a03:	d9 e8                	fld1   
    4a05:	df e9                	fucomip %st(1),%st
    4a07:	dd d8                	fstp   %st(0)
    4a09:	7a 12                	jp     4a1d <ln+0x5a>
    4a0b:	dd 45 90             	fldl   -0x70(%ebp)
    4a0e:	d9 e8                	fld1   
    4a10:	df e9                	fucomip %st(1),%st
    4a12:	dd d8                	fstp   %st(0)
    4a14:	75 07                	jne    4a1d <ln+0x5a>
    4a16:	d9 ee                	fldz   
    4a18:	e9 87 01 00 00       	jmp    4ba4 <ln+0x1e1>
	else if(x>2) return -ln(1/x);
    4a1d:	dd 45 90             	fldl   -0x70(%ebp)
    4a20:	dd 05 30 af 00 00    	fldl   0xaf30
    4a26:	d9 c9                	fxch   %st(1)
    4a28:	df e9                	fucomip %st(1),%st
    4a2a:	dd d8                	fstp   %st(0)
    4a2c:	76 14                	jbe    4a42 <ln+0x7f>
    4a2e:	d9 e8                	fld1   
    4a30:	dc 75 90             	fdivl  -0x70(%ebp)
    4a33:	dd 1c 24             	fstpl  (%esp)
    4a36:	e8 88 ff ff ff       	call   49c3 <ln>
    4a3b:	d9 e0                	fchs   
    4a3d:	e9 62 01 00 00       	jmp    4ba4 <ln+0x1e1>
	else if(x<.1)
    4a42:	dd 05 38 af 00 00    	fldl   0xaf38
    4a48:	dd 45 90             	fldl   -0x70(%ebp)
    4a4b:	d9 c9                	fxch   %st(1)
    4a4d:	df e9                	fucomip %st(1),%st
    4a4f:	dd d8                	fstp   %st(0)
    4a51:	76 59                	jbe    4aac <ln+0xe9>
	{
		double n=-1;
    4a53:	d9 e8                	fld1   
    4a55:	d9 e0                	fchs   
    4a57:	dd 5d c8             	fstpl  -0x38(%ebp)
		double a;
		do
		{
			n=n-.6;
    4a5a:	dd 45 c8             	fldl   -0x38(%ebp)
    4a5d:	dd 05 40 af 00 00    	fldl   0xaf40
    4a63:	de e9                	fsubrp %st,%st(1)
    4a65:	dd 5d c8             	fstpl  -0x38(%ebp)
			a=x/exp(n);
    4a68:	dd 45 c8             	fldl   -0x38(%ebp)
    4a6b:	dd 1c 24             	fstpl  (%esp)
    4a6e:	e8 33 01 00 00       	call   4ba6 <exp>
    4a73:	dd 45 90             	fldl   -0x70(%ebp)
    4a76:	de f1                	fdivp  %st,%st(1)
    4a78:	dd 5d a0             	fstpl  -0x60(%ebp)
		}
		while(a>2 || a<1);
    4a7b:	dd 45 a0             	fldl   -0x60(%ebp)
    4a7e:	dd 05 30 af 00 00    	fldl   0xaf30
    4a84:	d9 c9                	fxch   %st(1)
    4a86:	df e9                	fucomip %st(1),%st
    4a88:	dd d8                	fstp   %st(0)
    4a8a:	77 ce                	ja     4a5a <ln+0x97>
    4a8c:	d9 e8                	fld1   
    4a8e:	dd 45 a0             	fldl   -0x60(%ebp)
    4a91:	d9 c9                	fxch   %st(1)
    4a93:	df e9                	fucomip %st(1),%st
    4a95:	dd d8                	fstp   %st(0)
    4a97:	77 c1                	ja     4a5a <ln+0x97>
		return ln(a)+n;
    4a99:	dd 45 a0             	fldl   -0x60(%ebp)
    4a9c:	dd 1c 24             	fstpl  (%esp)
    4a9f:	e8 1f ff ff ff       	call   49c3 <ln>
    4aa4:	dc 45 c8             	faddl  -0x38(%ebp)
    4aa7:	e9 f8 00 00 00       	jmp    4ba4 <ln+0x1e1>
	}
	for(l=1,tmp=1;(ln_px-ln_tmp)>1e-9 || (ln_px-ln_tmp)<-1e-9;l++)
    4aac:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    4ab3:	d9 e8                	fld1   
    4ab5:	dd 5d d8             	fstpl  -0x28(%ebp)
    4ab8:	e9 b6 00 00 00       	jmp    4b73 <ln+0x1b0>
	{
		ln_tmp=ln_px;
    4abd:	dd 45 e8             	fldl   -0x18(%ebp)
    4ac0:	dd 5d e0             	fstpl  -0x20(%ebp)
		tmp*=y;
    4ac3:	dd 45 d8             	fldl   -0x28(%ebp)
    4ac6:	dc 4d c0             	fmull  -0x40(%ebp)
    4ac9:	dd 5d d8             	fstpl  -0x28(%ebp)
		if(l==1) tmp=tmp/l;
    4acc:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
    4ad0:	75 0d                	jne    4adf <ln+0x11c>
    4ad2:	db 45 d4             	fildl  -0x2c(%ebp)
    4ad5:	dd 45 d8             	fldl   -0x28(%ebp)
    4ad8:	de f1                	fdivp  %st,%st(1)
    4ada:	dd 5d d8             	fstpl  -0x28(%ebp)
    4add:	eb 13                	jmp    4af2 <ln+0x12f>
		else tmp=tmp/-l;
    4adf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    4ae2:	f7 d8                	neg    %eax
    4ae4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    4ae7:	db 45 8c             	fildl  -0x74(%ebp)
    4aea:	dd 45 d8             	fldl   -0x28(%ebp)
    4aed:	de f1                	fdivp  %st,%st(1)
    4aef:	dd 5d d8             	fstpl  -0x28(%ebp)
		ln_p1+=tmp;
    4af2:	dd 45 f0             	fldl   -0x10(%ebp)
    4af5:	dc 45 d8             	faddl  -0x28(%ebp)
    4af8:	dd 5d f0             	fstpl  -0x10(%ebp)
		ln_p2=ln_p1+-1*tmp*y*l/(l+1);
    4afb:	dd 45 d8             	fldl   -0x28(%ebp)
    4afe:	d9 e0                	fchs   
    4b00:	dc 4d c0             	fmull  -0x40(%ebp)
    4b03:	db 45 d4             	fildl  -0x2c(%ebp)
    4b06:	de c9                	fmulp  %st,%st(1)
    4b08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    4b0b:	83 c0 01             	add    $0x1,%eax
    4b0e:	89 45 8c             	mov    %eax,-0x74(%ebp)
    4b11:	db 45 8c             	fildl  -0x74(%ebp)
    4b14:	de f9                	fdivrp %st,%st(1)
    4b16:	dc 45 f0             	faddl  -0x10(%ebp)
    4b19:	dd 5d b8             	fstpl  -0x48(%ebp)
		ln_p3=ln_p2+tmp*y*y*l/(l+2);
    4b1c:	dd 45 d8             	fldl   -0x28(%ebp)
    4b1f:	dc 4d c0             	fmull  -0x40(%ebp)
    4b22:	dc 4d c0             	fmull  -0x40(%ebp)
    4b25:	db 45 d4             	fildl  -0x2c(%ebp)
    4b28:	de c9                	fmulp  %st,%st(1)
    4b2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    4b2d:	83 c0 02             	add    $0x2,%eax
    4b30:	89 45 8c             	mov    %eax,-0x74(%ebp)
    4b33:	db 45 8c             	fildl  -0x74(%ebp)
    4b36:	de f9                	fdivrp %st,%st(1)
    4b38:	dc 45 b8             	faddl  -0x48(%ebp)
    4b3b:	dd 5d b0             	fstpl  -0x50(%ebp)
		dln_px=ln_p3-ln_p2;
    4b3e:	dd 45 b0             	fldl   -0x50(%ebp)
    4b41:	dc 65 b8             	fsubl  -0x48(%ebp)
    4b44:	dd 5d a8             	fstpl  -0x58(%ebp)
		ln_px=ln_p3-dln_px*dln_px/(ln_p3-2*ln_p2+ln_p1);
    4b47:	dd 45 a8             	fldl   -0x58(%ebp)
    4b4a:	dc 4d a8             	fmull  -0x58(%ebp)
    4b4d:	dd 45 b8             	fldl   -0x48(%ebp)
    4b50:	d8 c0                	fadd   %st(0),%st
    4b52:	dd 45 b0             	fldl   -0x50(%ebp)
    4b55:	de e1                	fsubp  %st,%st(1)
    4b57:	dc 45 f0             	faddl  -0x10(%ebp)
    4b5a:	de f9                	fdivrp %st,%st(1)
    4b5c:	dd 45 b0             	fldl   -0x50(%ebp)
    4b5f:	de e1                	fsubp  %st,%st(1)
    4b61:	dd 5d e8             	fstpl  -0x18(%ebp)
		tmp*=l;
    4b64:	db 45 d4             	fildl  -0x2c(%ebp)
    4b67:	dd 45 d8             	fldl   -0x28(%ebp)
    4b6a:	de c9                	fmulp  %st,%st(1)
    4b6c:	dd 5d d8             	fstpl  -0x28(%ebp)
			a=x/exp(n);
		}
		while(a>2 || a<1);
		return ln(a)+n;
	}
	for(l=1,tmp=1;(ln_px-ln_tmp)>1e-9 || (ln_px-ln_tmp)<-1e-9;l++)
    4b6f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
    4b73:	dd 45 e8             	fldl   -0x18(%ebp)
    4b76:	dc 65 e0             	fsubl  -0x20(%ebp)
    4b79:	dd 05 48 af 00 00    	fldl   0xaf48
    4b7f:	d9 c9                	fxch   %st(1)
    4b81:	df e9                	fucomip %st(1),%st
    4b83:	dd d8                	fstp   %st(0)
    4b85:	0f 87 32 ff ff ff    	ja     4abd <ln+0xfa>
    4b8b:	dd 45 e8             	fldl   -0x18(%ebp)
    4b8e:	dc 65 e0             	fsubl  -0x20(%ebp)
    4b91:	dd 05 50 af 00 00    	fldl   0xaf50
    4b97:	df e9                	fucomip %st(1),%st
    4b99:	dd d8                	fstp   %st(0)
    4b9b:	0f 87 1c ff ff ff    	ja     4abd <ln+0xfa>
		ln_p3=ln_p2+tmp*y*y*l/(l+2);
		dln_px=ln_p3-ln_p2;
		ln_px=ln_p3-dln_px*dln_px/(ln_p3-2*ln_p2+ln_p1);
		tmp*=l;
	}
	return ln_px;
    4ba1:	dd 45 e8             	fldl   -0x18(%ebp)
}
    4ba4:	c9                   	leave  
    4ba5:	c3                   	ret    

00004ba6 <exp>:

// 求e^x 用于Pow( double, double )调用
// e^x = 1+x+(x^2)/2!+(x^3)/3!+...
// 精度为7位
double exp( double x )
{
    4ba6:	55                   	push   %ebp
    4ba7:	89 e5                	mov    %esp,%ebp
    4ba9:	83 ec 78             	sub    $0x78,%esp
    4bac:	8b 45 08             	mov    0x8(%ebp),%eax
    4baf:	89 45 a0             	mov    %eax,-0x60(%ebp)
    4bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
    4bb5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	double y=x,ex_p1=0,ex_p2=0,ex_p3=0,ex_px=0,ex_tmp=1,dex_px=1,tmp;
    4bb8:	dd 45 a0             	fldl   -0x60(%ebp)
    4bbb:	dd 5d c0             	fstpl  -0x40(%ebp)
    4bbe:	d9 ee                	fldz   
    4bc0:	dd 5d f0             	fstpl  -0x10(%ebp)
    4bc3:	d9 ee                	fldz   
    4bc5:	dd 5d b8             	fstpl  -0x48(%ebp)
    4bc8:	d9 ee                	fldz   
    4bca:	dd 5d b0             	fstpl  -0x50(%ebp)
    4bcd:	d9 ee                	fldz   
    4bcf:	dd 5d e8             	fstpl  -0x18(%ebp)
    4bd2:	d9 e8                	fld1   
    4bd4:	dd 5d e0             	fstpl  -0x20(%ebp)
    4bd7:	d9 e8                	fld1   
    4bd9:	dd 5d d8             	fstpl  -0x28(%ebp)
	int l;
	if(x==0) return 1;
    4bdc:	dd 45 a0             	fldl   -0x60(%ebp)
    4bdf:	d9 ee                	fldz   
    4be1:	df e9                	fucomip %st(1),%st
    4be3:	dd d8                	fstp   %st(0)
    4be5:	7a 12                	jp     4bf9 <exp+0x53>
    4be7:	dd 45 a0             	fldl   -0x60(%ebp)
    4bea:	d9 ee                	fldz   
    4bec:	df e9                	fucomip %st(1),%st
    4bee:	dd d8                	fstp   %st(0)
    4bf0:	75 07                	jne    4bf9 <exp+0x53>
    4bf2:	d9 e8                	fld1   
    4bf4:	e9 08 01 00 00       	jmp    4d01 <exp+0x15b>
	if(x<0) return 1/exp(-x); 
    4bf9:	d9 ee                	fldz   
    4bfb:	dd 45 a0             	fldl   -0x60(%ebp)
    4bfe:	d9 c9                	fxch   %st(1)
    4c00:	df e9                	fucomip %st(1),%st
    4c02:	dd d8                	fstp   %st(0)
    4c04:	76 16                	jbe    4c1c <exp+0x76>
    4c06:	dd 45 a0             	fldl   -0x60(%ebp)
    4c09:	d9 e0                	fchs   
    4c0b:	dd 1c 24             	fstpl  (%esp)
    4c0e:	e8 93 ff ff ff       	call   4ba6 <exp>
    4c13:	d9 e8                	fld1   
    4c15:	de f1                	fdivp  %st,%st(1)
    4c17:	e9 e5 00 00 00       	jmp    4d01 <exp+0x15b>
	for(l=1,tmp=1;((ex_px-ex_tmp)>1e-10 || (ex_px-ex_tmp)<-1e-10) && dex_px>1e-10;l++)
    4c1c:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
    4c23:	d9 e8                	fld1   
    4c25:	dd 5d d0             	fstpl  -0x30(%ebp)
    4c28:	e9 92 00 00 00       	jmp    4cbf <exp+0x119>
	{
		ex_tmp=ex_px;
    4c2d:	dd 45 e8             	fldl   -0x18(%ebp)
    4c30:	dd 5d e0             	fstpl  -0x20(%ebp)
		tmp*=y;
    4c33:	dd 45 d0             	fldl   -0x30(%ebp)
    4c36:	dc 4d c0             	fmull  -0x40(%ebp)
    4c39:	dd 5d d0             	fstpl  -0x30(%ebp)
		tmp=tmp/l;
    4c3c:	db 45 cc             	fildl  -0x34(%ebp)
    4c3f:	dd 45 d0             	fldl   -0x30(%ebp)
    4c42:	de f1                	fdivp  %st,%st(1)
    4c44:	dd 5d d0             	fstpl  -0x30(%ebp)
		ex_p1+=tmp;
    4c47:	dd 45 f0             	fldl   -0x10(%ebp)
    4c4a:	dc 45 d0             	faddl  -0x30(%ebp)
    4c4d:	dd 5d f0             	fstpl  -0x10(%ebp)
		ex_p2=ex_p1+tmp*y/(l+1);
    4c50:	dd 45 d0             	fldl   -0x30(%ebp)
    4c53:	dc 4d c0             	fmull  -0x40(%ebp)
    4c56:	8b 45 cc             	mov    -0x34(%ebp),%eax
    4c59:	83 c0 01             	add    $0x1,%eax
    4c5c:	89 45 9c             	mov    %eax,-0x64(%ebp)
    4c5f:	db 45 9c             	fildl  -0x64(%ebp)
    4c62:	de f9                	fdivrp %st,%st(1)
    4c64:	dc 45 f0             	faddl  -0x10(%ebp)
    4c67:	dd 5d b8             	fstpl  -0x48(%ebp)
		ex_p3=ex_p2+tmp*y*y/(l+1)/(l+2);
    4c6a:	dd 45 d0             	fldl   -0x30(%ebp)
    4c6d:	dc 4d c0             	fmull  -0x40(%ebp)
    4c70:	dc 4d c0             	fmull  -0x40(%ebp)
    4c73:	8b 45 cc             	mov    -0x34(%ebp),%eax
    4c76:	83 c0 01             	add    $0x1,%eax
    4c79:	89 45 9c             	mov    %eax,-0x64(%ebp)
    4c7c:	db 45 9c             	fildl  -0x64(%ebp)
    4c7f:	de f9                	fdivrp %st,%st(1)
    4c81:	8b 45 cc             	mov    -0x34(%ebp),%eax
    4c84:	83 c0 02             	add    $0x2,%eax
    4c87:	89 45 9c             	mov    %eax,-0x64(%ebp)
    4c8a:	db 45 9c             	fildl  -0x64(%ebp)
    4c8d:	de f9                	fdivrp %st,%st(1)
    4c8f:	dc 45 b8             	faddl  -0x48(%ebp)
    4c92:	dd 5d b0             	fstpl  -0x50(%ebp)
		dex_px=ex_p3-ex_p2;
    4c95:	dd 45 b0             	fldl   -0x50(%ebp)
    4c98:	dc 65 b8             	fsubl  -0x48(%ebp)
    4c9b:	dd 5d d8             	fstpl  -0x28(%ebp)
		ex_px=ex_p3-dex_px*dex_px/(ex_p3-2*ex_p2+ex_p1);
    4c9e:	dd 45 d8             	fldl   -0x28(%ebp)
    4ca1:	dc 4d d8             	fmull  -0x28(%ebp)
    4ca4:	dd 45 b8             	fldl   -0x48(%ebp)
    4ca7:	d8 c0                	fadd   %st(0),%st
    4ca9:	dd 45 b0             	fldl   -0x50(%ebp)
    4cac:	de e1                	fsubp  %st,%st(1)
    4cae:	dc 45 f0             	faddl  -0x10(%ebp)
    4cb1:	de f9                	fdivrp %st,%st(1)
    4cb3:	dd 45 b0             	fldl   -0x50(%ebp)
    4cb6:	de e1                	fsubp  %st,%st(1)
    4cb8:	dd 5d e8             	fstpl  -0x18(%ebp)
{
	double y=x,ex_p1=0,ex_p2=0,ex_p3=0,ex_px=0,ex_tmp=1,dex_px=1,tmp;
	int l;
	if(x==0) return 1;
	if(x<0) return 1/exp(-x); 
	for(l=1,tmp=1;((ex_px-ex_tmp)>1e-10 || (ex_px-ex_tmp)<-1e-10) && dex_px>1e-10;l++)
    4cbb:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
    4cbf:	dd 45 e8             	fldl   -0x18(%ebp)
    4cc2:	dc 65 e0             	fsubl  -0x20(%ebp)
    4cc5:	dd 05 58 af 00 00    	fldl   0xaf58
    4ccb:	d9 c9                	fxch   %st(1)
    4ccd:	df e9                	fucomip %st(1),%st
    4ccf:	dd d8                	fstp   %st(0)
    4cd1:	77 12                	ja     4ce5 <exp+0x13f>
    4cd3:	dd 45 e8             	fldl   -0x18(%ebp)
    4cd6:	dc 65 e0             	fsubl  -0x20(%ebp)
    4cd9:	dd 05 60 af 00 00    	fldl   0xaf60
    4cdf:	df e9                	fucomip %st(1),%st
    4ce1:	dd d8                	fstp   %st(0)
    4ce3:	76 15                	jbe    4cfa <exp+0x154>
    4ce5:	dd 45 d8             	fldl   -0x28(%ebp)
    4ce8:	dd 05 58 af 00 00    	fldl   0xaf58
    4cee:	d9 c9                	fxch   %st(1)
    4cf0:	df e9                	fucomip %st(1),%st
    4cf2:	dd d8                	fstp   %st(0)
    4cf4:	0f 87 33 ff ff ff    	ja     4c2d <exp+0x87>
		ex_p2=ex_p1+tmp*y/(l+1);
		ex_p3=ex_p2+tmp*y*y/(l+1)/(l+2);
		dex_px=ex_p3-ex_p2;
		ex_px=ex_p3-dex_px*dex_px/(ex_p3-2*ex_p2+ex_p1);
	}
	return ex_px+1;
    4cfa:	dd 45 e8             	fldl   -0x18(%ebp)
    4cfd:	d9 e8                	fld1   
    4cff:	de c1                	faddp  %st,%st(1)
    4d01:	c9                   	leave  
    4d02:	c3                   	ret    

00004d03 <OpenTableFile>:
};
double  s_freq[4] = {44.1, 48, 32, 0};
char *mode_names[4] = { "stereo", "j-stereo", "dual-ch", "single-ch" };

int OpenTableFile(char *name)
{
    4d03:	55                   	push   %ebp
    4d04:	89 e5                	mov    %esp,%ebp
    4d06:	83 ec 78             	sub    $0x78,%esp
	char fulname[80];
	int f;

	fulname[0] = '\0';
    4d09:	c6 45 a4 00          	movb   $0x0,-0x5c(%ebp)
	strcpy(fulname, name);
    4d0d:	8b 45 08             	mov    0x8(%ebp),%eax
    4d10:	89 44 24 04          	mov    %eax,0x4(%esp)
    4d14:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    4d17:	89 04 24             	mov    %eax,(%esp)
    4d1a:	e8 f8 f1 ff ff       	call   3f17 <strcpy>
	//-1 ?
	if( (f=open(fulname,O_RDWR))==-1 ) {
    4d1f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    4d26:	00 
    4d27:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    4d2a:	89 04 24             	mov    %eax,(%esp)
    4d2d:	e8 68 f4 ff ff       	call   419a <open>
    4d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4d35:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    4d39:	75 1b                	jne    4d56 <OpenTableFile+0x53>
		printf(0,"\nOpenTable: could not find %s\n", fulname);
    4d3b:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    4d3e:	89 44 24 08          	mov    %eax,0x8(%esp)
    4d42:	c7 44 24 04 94 af 00 	movl   $0xaf94,0x4(%esp)
    4d49:	00 
    4d4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4d51:	e8 ec f5 ff ff       	call   4342 <printf>
    }
    return f;
    4d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    4d59:	c9                   	leave  
    4d5a:	c3                   	ret    

00004d5b <WriteHdr>:


void WriteHdr(struct frame_params *fr_ps)
{
    4d5b:	55                   	push   %ebp
    4d5c:	89 e5                	mov    %esp,%ebp
    4d5e:	57                   	push   %edi
    4d5f:	56                   	push   %esi
    4d60:	53                   	push   %ebx
    4d61:	83 ec 3c             	sub    $0x3c,%esp
	layer *info = fr_ps->header;
    4d64:	8b 45 08             	mov    0x8(%ebp),%eax
    4d67:	8b 00                	mov    (%eax),%eax
    4d69:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	printf(0, "HDR:  sync=FFF, id=%X, layer=%X, ep=%X, br=%X, sf=%X, pd=%X, ",
    4d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4d6f:	8b 78 14             	mov    0x14(%eax),%edi
    4d72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4d75:	8b 70 10             	mov    0x10(%eax),%esi
    4d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4d7b:	8b 58 0c             	mov    0xc(%eax),%ebx
		info->version, info->lay, !info->error_protection,
    4d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4d81:	8b 40 08             	mov    0x8(%eax),%eax

void WriteHdr(struct frame_params *fr_ps)
{
	layer *info = fr_ps->header;

	printf(0, "HDR:  sync=FFF, id=%X, layer=%X, ep=%X, br=%X, sf=%X, pd=%X, ",
    4d84:	85 c0                	test   %eax,%eax
    4d86:	0f 94 c0             	sete   %al
    4d89:	0f b6 c8             	movzbl %al,%ecx
    4d8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4d8f:	8b 50 04             	mov    0x4(%eax),%edx
    4d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4d95:	8b 00                	mov    (%eax),%eax
    4d97:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
    4d9b:	89 74 24 18          	mov    %esi,0x18(%esp)
    4d9f:	89 5c 24 14          	mov    %ebx,0x14(%esp)
    4da3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    4da7:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4dab:	89 44 24 08          	mov    %eax,0x8(%esp)
    4daf:	c7 44 24 04 b4 af 00 	movl   $0xafb4,0x4(%esp)
    4db6:	00 
    4db7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4dbe:	e8 7f f5 ff ff       	call   4342 <printf>
		info->version, info->lay, !info->error_protection,
		info->bitrate_index, info->sampling_frequency, info->padding);

	printf(0, "pr=%X, m=%X, js=%X, c=%X, o=%X, e=%X\n",
    4dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4dc6:	8b 78 2c             	mov    0x2c(%eax),%edi
    4dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4dcc:	8b 70 28             	mov    0x28(%eax),%esi
    4dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4dd2:	8b 58 24             	mov    0x24(%eax),%ebx
    4dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4dd8:	8b 48 20             	mov    0x20(%eax),%ecx
    4ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4dde:	8b 50 1c             	mov    0x1c(%eax),%edx
    4de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4de4:	8b 40 18             	mov    0x18(%eax),%eax
    4de7:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
    4deb:	89 74 24 18          	mov    %esi,0x18(%esp)
    4def:	89 5c 24 14          	mov    %ebx,0x14(%esp)
    4df3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    4df7:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4dfb:	89 44 24 08          	mov    %eax,0x8(%esp)
    4dff:	c7 44 24 04 f4 af 00 	movl   $0xaff4,0x4(%esp)
    4e06:	00 
    4e07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4e0e:	e8 2f f5 ff ff       	call   4342 <printf>
		info->extension, info->mode, info->mode_ext,
		info->copyright, info->original, info->emphasis);

	printf(0, "layer=%s, tot bitrate=%d, sfrq=%.1f, mode=%s, ",
		layer_names[info->lay-1], bitrate[info->lay-1][info->bitrate_index],
		s_freq[info->sampling_frequency], mode_names[info->mode]);
    4e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4e16:	8b 40 1c             	mov    0x1c(%eax),%eax

	printf(0, "pr=%X, m=%X, js=%X, c=%X, o=%X, e=%X\n",
		info->extension, info->mode, info->mode_ext,
		info->copyright, info->original, info->emphasis);

	printf(0, "layer=%s, tot bitrate=%d, sfrq=%.1f, mode=%s, ",
    4e19:	8b 0c 85 20 e8 00 00 	mov    0xe820(,%eax,4),%ecx
		layer_names[info->lay-1], bitrate[info->lay-1][info->bitrate_index],
		s_freq[info->sampling_frequency], mode_names[info->mode]);
    4e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4e23:	8b 40 10             	mov    0x10(%eax),%eax

	printf(0, "pr=%X, m=%X, js=%X, c=%X, o=%X, e=%X\n",
		info->extension, info->mode, info->mode_ext,
		info->copyright, info->original, info->emphasis);

	printf(0, "layer=%s, tot bitrate=%d, sfrq=%.1f, mode=%s, ",
    4e26:	dd 04 c5 00 e8 00 00 	fldl   0xe800(,%eax,8)
		layer_names[info->lay-1], bitrate[info->lay-1][info->bitrate_index],
    4e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4e30:	8b 40 04             	mov    0x4(%eax),%eax
    4e33:	8d 50 ff             	lea    -0x1(%eax),%edx
    4e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4e39:	8b 58 0c             	mov    0xc(%eax),%ebx

	printf(0, "pr=%X, m=%X, js=%X, c=%X, o=%X, e=%X\n",
		info->extension, info->mode, info->mode_ext,
		info->copyright, info->original, info->emphasis);

	printf(0, "layer=%s, tot bitrate=%d, sfrq=%.1f, mode=%s, ",
    4e3c:	89 d0                	mov    %edx,%eax
    4e3e:	c1 e0 04             	shl    $0x4,%eax
    4e41:	29 d0                	sub    %edx,%eax
    4e43:	01 d8                	add    %ebx,%eax
    4e45:	8b 14 85 40 e7 00 00 	mov    0xe740(,%eax,4),%edx
		layer_names[info->lay-1], bitrate[info->lay-1][info->bitrate_index],
    4e4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4e4f:	8b 40 04             	mov    0x4(%eax),%eax
    4e52:	83 e8 01             	sub    $0x1,%eax

	printf(0, "pr=%X, m=%X, js=%X, c=%X, o=%X, e=%X\n",
		info->extension, info->mode, info->mode_ext,
		info->copyright, info->original, info->emphasis);

	printf(0, "layer=%s, tot bitrate=%d, sfrq=%.1f, mode=%s, ",
    4e55:	8b 04 85 20 e7 00 00 	mov    0xe720(,%eax,4),%eax
    4e5c:	89 4c 24 18          	mov    %ecx,0x18(%esp)
    4e60:	dd 5c 24 10          	fstpl  0x10(%esp)
    4e64:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4e68:	89 44 24 08          	mov    %eax,0x8(%esp)
    4e6c:	c7 44 24 04 1c b0 00 	movl   $0xb01c,0x4(%esp)
    4e73:	00 
    4e74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4e7b:	e8 c2 f4 ff ff       	call   4342 <printf>
		layer_names[info->lay-1], bitrate[info->lay-1][info->bitrate_index],
		s_freq[info->sampling_frequency], mode_names[info->mode]);

	printf(0, "sblim=%d, jsbd=%d, ch=%d\n",
    4e80:	8b 45 08             	mov    0x8(%ebp),%eax
    4e83:	8b 48 08             	mov    0x8(%eax),%ecx
    4e86:	8b 45 08             	mov    0x8(%ebp),%eax
    4e89:	8b 50 0c             	mov    0xc(%eax),%edx
    4e8c:	8b 45 08             	mov    0x8(%ebp),%eax
    4e8f:	8b 40 10             	mov    0x10(%eax),%eax
    4e92:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    4e96:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4e9a:	89 44 24 08          	mov    %eax,0x8(%esp)
    4e9e:	c7 44 24 04 4b b0 00 	movl   $0xb04b,0x4(%esp)
    4ea5:	00 
    4ea6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4ead:	e8 90 f4 ff ff       	call   4342 <printf>
		fr_ps->sblimit, fr_ps->jsbound, fr_ps->stereo);
}
    4eb2:	83 c4 3c             	add    $0x3c,%esp
    4eb5:	5b                   	pop    %ebx
    4eb6:	5e                   	pop    %esi
    4eb7:	5f                   	pop    %edi
    4eb8:	5d                   	pop    %ebp
    4eb9:	c3                   	ret    

00004eba <mem_alloc>:

void *mem_alloc(unsigned long block, char *item)
{
    4eba:	55                   	push   %ebp
    4ebb:	89 e5                	mov    %esp,%ebp
    4ebd:	83 ec 28             	sub    $0x28,%esp
	void *ptr;
	ptr = (void *)malloc((unsigned long)block);
    4ec0:	8b 45 08             	mov    0x8(%ebp),%eax
    4ec3:	89 04 24             	mov    %eax,(%esp)
    4ec6:	e8 63 f7 ff ff       	call   462e <malloc>
    4ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (ptr != 0)
    4ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4ed2:	74 1c                	je     4ef0 <mem_alloc+0x36>
		memset(ptr, 0, block);
    4ed4:	8b 45 08             	mov    0x8(%ebp),%eax
    4ed7:	89 44 24 08          	mov    %eax,0x8(%esp)
    4edb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    4ee2:	00 
    4ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4ee6:	89 04 24             	mov    %eax,(%esp)
    4ee9:	e8 bf f0 ff ff       	call   3fad <memset>
    4eee:	eb 20                	jmp    4f10 <mem_alloc+0x56>
	else{
		printf(0, "Unable to allocate %s\n", item);
    4ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
    4ef3:	89 44 24 08          	mov    %eax,0x8(%esp)
    4ef7:	c7 44 24 04 65 b0 00 	movl   $0xb065,0x4(%esp)
    4efe:	00 
    4eff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4f06:	e8 37 f4 ff ff       	call   4342 <printf>
		exit();
    4f0b:	e8 4a f2 ff ff       	call   415a <exit>
	}
	return ptr;
    4f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    4f13:	c9                   	leave  
    4f14:	c3                   	ret    

00004f15 <alloc_buffer>:

void alloc_buffer(Bit_stream_struc *bs, int size)
{
    4f15:	55                   	push   %ebp
    4f16:	89 e5                	mov    %esp,%ebp
    4f18:	83 ec 18             	sub    $0x18,%esp
	bs->buf = (unsigned char *) mem_alloc(size*sizeof(unsigned char), "buffer");
    4f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
    4f1e:	c7 44 24 04 7c b0 00 	movl   $0xb07c,0x4(%esp)
    4f25:	00 
    4f26:	89 04 24             	mov    %eax,(%esp)
    4f29:	e8 8c ff ff ff       	call   4eba <mem_alloc>
    4f2e:	8b 55 08             	mov    0x8(%ebp),%edx
    4f31:	89 42 04             	mov    %eax,0x4(%edx)
	bs->buf_size = size;
    4f34:	8b 45 08             	mov    0x8(%ebp),%eax
    4f37:	8b 55 0c             	mov    0xc(%ebp),%edx
    4f3a:	89 50 08             	mov    %edx,0x8(%eax)
}
    4f3d:	c9                   	leave  
    4f3e:	c3                   	ret    

00004f3f <desalloc_buffer>:

void desalloc_buffer(Bit_stream_struc *bs)
{
    4f3f:	55                   	push   %ebp
    4f40:	89 e5                	mov    %esp,%ebp
    4f42:	83 ec 18             	sub    $0x18,%esp
	free(bs->buf);
    4f45:	8b 45 08             	mov    0x8(%ebp),%eax
    4f48:	8b 40 04             	mov    0x4(%eax),%eax
    4f4b:	89 04 24             	mov    %eax,(%esp)
    4f4e:	e8 a2 f5 ff ff       	call   44f5 <free>
}
    4f53:	c9                   	leave  
    4f54:	c3                   	ret    

00004f55 <open_bit_stream_r>:

void open_bit_stream_r(Bit_stream_struc *bs, char *bs_filenam, int size)
{
    4f55:	55                   	push   %ebp
    4f56:	89 e5                	mov    %esp,%ebp
    4f58:	83 ec 18             	sub    $0x18,%esp
	//register unsigned char flag = 1;

	if ((bs->pt = open(bs_filenam, O_RDWR)) == -1) {
    4f5b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    4f62:	00 
    4f63:	8b 45 0c             	mov    0xc(%ebp),%eax
    4f66:	89 04 24             	mov    %eax,(%esp)
    4f69:	e8 2c f2 ff ff       	call   419a <open>
    4f6e:	8b 55 08             	mov    0x8(%ebp),%edx
    4f71:	89 02                	mov    %eax,(%edx)
    4f73:	8b 45 08             	mov    0x8(%ebp),%eax
    4f76:	8b 00                	mov    (%eax),%eax
    4f78:	83 f8 ff             	cmp    $0xffffffff,%eax
    4f7b:	75 20                	jne    4f9d <open_bit_stream_r+0x48>
		printf(0, "Could not find \"%s\".\n", bs_filenam);
    4f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
    4f80:	89 44 24 08          	mov    %eax,0x8(%esp)
    4f84:	c7 44 24 04 83 b0 00 	movl   $0xb083,0x4(%esp)
    4f8b:	00 
    4f8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4f93:	e8 aa f3 ff ff       	call   4342 <printf>
		exit();
    4f98:	e8 bd f1 ff ff       	call   415a <exit>
	}

	bs->format = BINARY;
    4f9d:	8b 45 08             	mov    0x8(%ebp),%eax
    4fa0:	c6 40 24 00          	movb   $0x0,0x24(%eax)
	alloc_buffer(bs, size);
    4fa4:	8b 45 10             	mov    0x10(%ebp),%eax
    4fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
    4fab:	8b 45 08             	mov    0x8(%ebp),%eax
    4fae:	89 04 24             	mov    %eax,(%esp)
    4fb1:	e8 5f ff ff ff       	call   4f15 <alloc_buffer>
	bs->buf_byte_idx=0;
    4fb6:	8b 45 08             	mov    0x8(%ebp),%eax
    4fb9:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
	bs->buf_bit_idx=0;
    4fc0:	8b 45 08             	mov    0x8(%ebp),%eax
    4fc3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	bs->totbit=0;
    4fca:	8b 45 08             	mov    0x8(%ebp),%eax
    4fcd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	bs->mode = READ_MODE;
    4fd4:	8b 45 08             	mov    0x8(%ebp),%eax
    4fd7:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
	bs->eob = FALSE;
    4fde:	8b 45 08             	mov    0x8(%ebp),%eax
    4fe1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	bs->eobs = FALSE;
    4fe8:	8b 45 08             	mov    0x8(%ebp),%eax
    4feb:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
}
    4ff2:	c9                   	leave  
    4ff3:	c3                   	ret    

00004ff4 <close_bit_stream_r>:

void close_bit_stream_r(Bit_stream_struc *bs)
{
    4ff4:	55                   	push   %ebp
    4ff5:	89 e5                	mov    %esp,%ebp
    4ff7:	83 ec 18             	sub    $0x18,%esp
	close(bs->pt);
    4ffa:	8b 45 08             	mov    0x8(%ebp),%eax
    4ffd:	8b 00                	mov    (%eax),%eax
    4fff:	89 04 24             	mov    %eax,(%esp)
    5002:	e8 7b f1 ff ff       	call   4182 <close>
	desalloc_buffer(bs);
    5007:	8b 45 08             	mov    0x8(%ebp),%eax
    500a:	89 04 24             	mov    %eax,(%esp)
    500d:	e8 2d ff ff ff       	call   4f3f <desalloc_buffer>
}
    5012:	c9                   	leave  
    5013:	c3                   	ret    

00005014 <end_bs>:

int end_bs(Bit_stream_struc *bs)
{
    5014:	55                   	push   %ebp
    5015:	89 e5                	mov    %esp,%ebp
  return(bs->eobs);
    5017:	8b 45 08             	mov    0x8(%ebp),%eax
    501a:	8b 40 20             	mov    0x20(%eax),%eax
}
    501d:	5d                   	pop    %ebp
    501e:	c3                   	ret    

0000501f <sstell>:


unsigned long sstell(Bit_stream_struc *bs)
{
    501f:	55                   	push   %ebp
    5020:	89 e5                	mov    %esp,%ebp
  return(bs->totbit);
    5022:	8b 45 08             	mov    0x8(%ebp),%eax
    5025:	8b 40 0c             	mov    0xc(%eax),%eax
}
    5028:	5d                   	pop    %ebp
    5029:	c3                   	ret    

0000502a <refill_buffer>:


void refill_buffer(Bit_stream_struc *bs)
{
    502a:	55                   	push   %ebp
    502b:	89 e5                	mov    %esp,%ebp
    502d:	56                   	push   %esi
    502e:	53                   	push   %ebx
    502f:	83 ec 10             	sub    $0x10,%esp
	register int i=bs->buf_size-2-bs->buf_byte_idx;
    5032:	8b 45 08             	mov    0x8(%ebp),%eax
    5035:	8b 40 08             	mov    0x8(%eax),%eax
    5038:	8d 50 fe             	lea    -0x2(%eax),%edx
    503b:	8b 45 08             	mov    0x8(%ebp),%eax
    503e:	8b 40 10             	mov    0x10(%eax),%eax
    5041:	89 d3                	mov    %edx,%ebx
    5043:	29 c3                	sub    %eax,%ebx
	register unsigned long n=1;
    5045:	be 01 00 00 00       	mov    $0x1,%esi

	while ((i>=0) && (!bs->eob)) {
    504a:	eb 35                	jmp    5081 <refill_buffer+0x57>
			n=read(bs->pt, &bs->buf[i--], sizeof(unsigned char));
    504c:	8b 45 08             	mov    0x8(%ebp),%eax
    504f:	8b 50 04             	mov    0x4(%eax),%edx
    5052:	89 d8                	mov    %ebx,%eax
    5054:	8d 58 ff             	lea    -0x1(%eax),%ebx
    5057:	01 c2                	add    %eax,%edx
    5059:	8b 45 08             	mov    0x8(%ebp),%eax
    505c:	8b 00                	mov    (%eax),%eax
    505e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    5065:	00 
    5066:	89 54 24 04          	mov    %edx,0x4(%esp)
    506a:	89 04 24             	mov    %eax,(%esp)
    506d:	e8 00 f1 ff ff       	call   4172 <read>
    5072:	89 c6                	mov    %eax,%esi
		if (!n)
    5074:	85 f6                	test   %esi,%esi
    5076:	75 09                	jne    5081 <refill_buffer+0x57>
		bs->eob= i+1;
    5078:	8d 53 01             	lea    0x1(%ebx),%edx
    507b:	8b 45 08             	mov    0x8(%ebp),%eax
    507e:	89 50 1c             	mov    %edx,0x1c(%eax)
void refill_buffer(Bit_stream_struc *bs)
{
	register int i=bs->buf_size-2-bs->buf_byte_idx;
	register unsigned long n=1;

	while ((i>=0) && (!bs->eob)) {
    5081:	85 db                	test   %ebx,%ebx
    5083:	78 0a                	js     508f <refill_buffer+0x65>
    5085:	8b 45 08             	mov    0x8(%ebp),%eax
    5088:	8b 40 1c             	mov    0x1c(%eax),%eax
    508b:	85 c0                	test   %eax,%eax
    508d:	74 bd                	je     504c <refill_buffer+0x22>
			n=read(bs->pt, &bs->buf[i--], sizeof(unsigned char));
		if (!n)
		bs->eob= i+1;
	}
}
    508f:	83 c4 10             	add    $0x10,%esp
    5092:	5b                   	pop    %ebx
    5093:	5e                   	pop    %esi
    5094:	5d                   	pop    %ebp
    5095:	c3                   	ret    

00005096 <get1bit>:


int mask[8]={0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80};

unsigned int get1bit(Bit_stream_struc *bs)
{
    5096:	55                   	push   %ebp
    5097:	89 e5                	mov    %esp,%ebp
    5099:	53                   	push   %ebx
    509a:	83 ec 24             	sub    $0x24,%esp
   unsigned int bit;
   register int i;

   bs->totbit++;
    509d:	8b 45 08             	mov    0x8(%ebp),%eax
    50a0:	8b 40 0c             	mov    0xc(%eax),%eax
    50a3:	8d 50 01             	lea    0x1(%eax),%edx
    50a6:	8b 45 08             	mov    0x8(%ebp),%eax
    50a9:	89 50 0c             	mov    %edx,0xc(%eax)

   if (!bs->buf_bit_idx) {
    50ac:	8b 45 08             	mov    0x8(%ebp),%eax
    50af:	8b 40 14             	mov    0x14(%eax),%eax
    50b2:	85 c0                	test   %eax,%eax
    50b4:	0f 85 9f 00 00 00    	jne    5159 <get1bit+0xc3>
        bs->buf_bit_idx = 8;
    50ba:	8b 45 08             	mov    0x8(%ebp),%eax
    50bd:	c7 40 14 08 00 00 00 	movl   $0x8,0x14(%eax)
        bs->buf_byte_idx--;
    50c4:	8b 45 08             	mov    0x8(%ebp),%eax
    50c7:	8b 40 10             	mov    0x10(%eax),%eax
    50ca:	8d 50 ff             	lea    -0x1(%eax),%edx
    50cd:	8b 45 08             	mov    0x8(%ebp),%eax
    50d0:	89 50 10             	mov    %edx,0x10(%eax)
        if ((bs->buf_byte_idx < MINIMUM) || (bs->buf_byte_idx < bs->eob)) {
    50d3:	8b 45 08             	mov    0x8(%ebp),%eax
    50d6:	8b 40 10             	mov    0x10(%eax),%eax
    50d9:	83 f8 03             	cmp    $0x3,%eax
    50dc:	7e 10                	jle    50ee <get1bit+0x58>
    50de:	8b 45 08             	mov    0x8(%ebp),%eax
    50e1:	8b 50 10             	mov    0x10(%eax),%edx
    50e4:	8b 45 08             	mov    0x8(%ebp),%eax
    50e7:	8b 40 1c             	mov    0x1c(%eax),%eax
    50ea:	39 c2                	cmp    %eax,%edx
    50ec:	7d 6b                	jge    5159 <get1bit+0xc3>
             if (bs->eob)
    50ee:	8b 45 08             	mov    0x8(%ebp),%eax
    50f1:	8b 40 1c             	mov    0x1c(%eax),%eax
    50f4:	85 c0                	test   %eax,%eax
    50f6:	74 0c                	je     5104 <get1bit+0x6e>
                bs->eobs = TRUE;
    50f8:	8b 45 08             	mov    0x8(%ebp),%eax
    50fb:	c7 40 20 01 00 00 00 	movl   $0x1,0x20(%eax)
    5102:	eb 55                	jmp    5159 <get1bit+0xc3>
             else {
                for (i=bs->buf_byte_idx; i>=0;i--)
    5104:	8b 45 08             	mov    0x8(%ebp),%eax
    5107:	8b 58 10             	mov    0x10(%eax),%ebx
    510a:	eb 2f                	jmp    513b <get1bit+0xa5>
                  bs->buf[bs->buf_size-1-bs->buf_byte_idx+i] = bs->buf[i];
    510c:	8b 45 08             	mov    0x8(%ebp),%eax
    510f:	8b 50 04             	mov    0x4(%eax),%edx
    5112:	8b 45 08             	mov    0x8(%ebp),%eax
    5115:	8b 40 08             	mov    0x8(%eax),%eax
    5118:	8d 48 ff             	lea    -0x1(%eax),%ecx
    511b:	8b 45 08             	mov    0x8(%ebp),%eax
    511e:	8b 40 10             	mov    0x10(%eax),%eax
    5121:	29 c1                	sub    %eax,%ecx
    5123:	89 c8                	mov    %ecx,%eax
    5125:	01 d8                	add    %ebx,%eax
    5127:	01 c2                	add    %eax,%edx
    5129:	8b 45 08             	mov    0x8(%ebp),%eax
    512c:	8b 48 04             	mov    0x4(%eax),%ecx
    512f:	89 d8                	mov    %ebx,%eax
    5131:	01 c8                	add    %ecx,%eax
    5133:	0f b6 00             	movzbl (%eax),%eax
    5136:	88 02                	mov    %al,(%edx)
        bs->buf_byte_idx--;
        if ((bs->buf_byte_idx < MINIMUM) || (bs->buf_byte_idx < bs->eob)) {
             if (bs->eob)
                bs->eobs = TRUE;
             else {
                for (i=bs->buf_byte_idx; i>=0;i--)
    5138:	83 eb 01             	sub    $0x1,%ebx
    513b:	85 db                	test   %ebx,%ebx
    513d:	79 cd                	jns    510c <get1bit+0x76>
                  bs->buf[bs->buf_size-1-bs->buf_byte_idx+i] = bs->buf[i];
                refill_buffer(bs);
    513f:	8b 45 08             	mov    0x8(%ebp),%eax
    5142:	89 04 24             	mov    %eax,(%esp)
    5145:	e8 e0 fe ff ff       	call   502a <refill_buffer>
                bs->buf_byte_idx = bs->buf_size-1;
    514a:	8b 45 08             	mov    0x8(%ebp),%eax
    514d:	8b 40 08             	mov    0x8(%eax),%eax
    5150:	8d 50 ff             	lea    -0x1(%eax),%edx
    5153:	8b 45 08             	mov    0x8(%ebp),%eax
    5156:	89 50 10             	mov    %edx,0x10(%eax)
             }
        }
   }
   bit = bs->buf[bs->buf_byte_idx]&mask[bs->buf_bit_idx-1];
    5159:	8b 45 08             	mov    0x8(%ebp),%eax
    515c:	8b 50 04             	mov    0x4(%eax),%edx
    515f:	8b 45 08             	mov    0x8(%ebp),%eax
    5162:	8b 40 10             	mov    0x10(%eax),%eax
    5165:	01 d0                	add    %edx,%eax
    5167:	0f b6 00             	movzbl (%eax),%eax
    516a:	0f b6 d0             	movzbl %al,%edx
    516d:	8b 45 08             	mov    0x8(%ebp),%eax
    5170:	8b 40 14             	mov    0x14(%eax),%eax
    5173:	83 e8 01             	sub    $0x1,%eax
    5176:	8b 04 85 40 e8 00 00 	mov    0xe840(,%eax,4),%eax
    517d:	21 d0                	and    %edx,%eax
    517f:	89 45 f4             	mov    %eax,-0xc(%ebp)
   bit = bit >> (bs->buf_bit_idx-1);
    5182:	8b 45 08             	mov    0x8(%ebp),%eax
    5185:	8b 40 14             	mov    0x14(%eax),%eax
    5188:	83 e8 01             	sub    $0x1,%eax
    518b:	89 c1                	mov    %eax,%ecx
    518d:	d3 6d f4             	shrl   %cl,-0xc(%ebp)
   bs->buf_bit_idx--;
    5190:	8b 45 08             	mov    0x8(%ebp),%eax
    5193:	8b 40 14             	mov    0x14(%eax),%eax
    5196:	8d 50 ff             	lea    -0x1(%eax),%edx
    5199:	8b 45 08             	mov    0x8(%ebp),%eax
    519c:	89 50 14             	mov    %edx,0x14(%eax)
   return(bit);
    519f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    51a2:	83 c4 24             	add    $0x24,%esp
    51a5:	5b                   	pop    %ebx
    51a6:	5d                   	pop    %ebp
    51a7:	c3                   	ret    

000051a8 <getbits>:

int putmask[9]={0x0, 0x1, 0x3, 0x7, 0xf, 0x1f, 0x3f, 0x7f, 0xff};

unsigned long getbits(Bit_stream_struc *bs, int N)
{
    51a8:	55                   	push   %ebp
    51a9:	89 e5                	mov    %esp,%ebp
    51ab:	57                   	push   %edi
    51ac:	56                   	push   %esi
    51ad:	53                   	push   %ebx
    51ae:	83 ec 2c             	sub    $0x2c,%esp
	unsigned long val=0;
    51b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	register int i;
	register int j = N;
    51b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	register int k, tmp;

	if (N > MAX_LENGTH)
    51bb:	83 7d 0c 20          	cmpl   $0x20,0xc(%ebp)
    51bf:	7e 1c                	jle    51dd <getbits+0x35>
		printf(0,"Cannot read or write more than %d bits at a time.\n", MAX_LENGTH);
    51c1:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    51c8:	00 
    51c9:	c7 44 24 04 9c b0 00 	movl   $0xb09c,0x4(%esp)
    51d0:	00 
    51d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    51d8:	e8 65 f1 ff ff       	call   4342 <printf>

	bs->totbit += N;
    51dd:	8b 45 08             	mov    0x8(%ebp),%eax
    51e0:	8b 50 0c             	mov    0xc(%eax),%edx
    51e3:	8b 45 0c             	mov    0xc(%ebp),%eax
    51e6:	01 c2                	add    %eax,%edx
    51e8:	8b 45 08             	mov    0x8(%ebp),%eax
    51eb:	89 50 0c             	mov    %edx,0xc(%eax)
	while (j > 0) {
    51ee:	e9 0a 01 00 00       	jmp    52fd <getbits+0x155>
		if (!bs->buf_bit_idx) {
    51f3:	8b 45 08             	mov    0x8(%ebp),%eax
    51f6:	8b 40 14             	mov    0x14(%eax),%eax
    51f9:	85 c0                	test   %eax,%eax
    51fb:	0f 85 9f 00 00 00    	jne    52a0 <getbits+0xf8>
			bs->buf_bit_idx = 8;
    5201:	8b 45 08             	mov    0x8(%ebp),%eax
    5204:	c7 40 14 08 00 00 00 	movl   $0x8,0x14(%eax)
			bs->buf_byte_idx--;
    520b:	8b 45 08             	mov    0x8(%ebp),%eax
    520e:	8b 40 10             	mov    0x10(%eax),%eax
    5211:	8d 50 ff             	lea    -0x1(%eax),%edx
    5214:	8b 45 08             	mov    0x8(%ebp),%eax
    5217:	89 50 10             	mov    %edx,0x10(%eax)
			if ((bs->buf_byte_idx < MINIMUM) || (bs->buf_byte_idx < bs->eob)) {
    521a:	8b 45 08             	mov    0x8(%ebp),%eax
    521d:	8b 40 10             	mov    0x10(%eax),%eax
    5220:	83 f8 03             	cmp    $0x3,%eax
    5223:	7e 10                	jle    5235 <getbits+0x8d>
    5225:	8b 45 08             	mov    0x8(%ebp),%eax
    5228:	8b 50 10             	mov    0x10(%eax),%edx
    522b:	8b 45 08             	mov    0x8(%ebp),%eax
    522e:	8b 40 1c             	mov    0x1c(%eax),%eax
    5231:	39 c2                	cmp    %eax,%edx
    5233:	7d 6b                	jge    52a0 <getbits+0xf8>
				if (bs->eob)
    5235:	8b 45 08             	mov    0x8(%ebp),%eax
    5238:	8b 40 1c             	mov    0x1c(%eax),%eax
    523b:	85 c0                	test   %eax,%eax
    523d:	74 0c                	je     524b <getbits+0xa3>
					bs->eobs = TRUE;
    523f:	8b 45 08             	mov    0x8(%ebp),%eax
    5242:	c7 40 20 01 00 00 00 	movl   $0x1,0x20(%eax)
    5249:	eb 55                	jmp    52a0 <getbits+0xf8>
				else {
					for (i=bs->buf_byte_idx; i>=0;i--)
    524b:	8b 45 08             	mov    0x8(%ebp),%eax
    524e:	8b 70 10             	mov    0x10(%eax),%esi
    5251:	eb 2f                	jmp    5282 <getbits+0xda>
						bs->buf[bs->buf_size-1-bs->buf_byte_idx+i] = bs->buf[i];
    5253:	8b 45 08             	mov    0x8(%ebp),%eax
    5256:	8b 50 04             	mov    0x4(%eax),%edx
    5259:	8b 45 08             	mov    0x8(%ebp),%eax
    525c:	8b 40 08             	mov    0x8(%eax),%eax
    525f:	8d 48 ff             	lea    -0x1(%eax),%ecx
    5262:	8b 45 08             	mov    0x8(%ebp),%eax
    5265:	8b 40 10             	mov    0x10(%eax),%eax
    5268:	29 c1                	sub    %eax,%ecx
    526a:	89 c8                	mov    %ecx,%eax
    526c:	01 f0                	add    %esi,%eax
    526e:	01 c2                	add    %eax,%edx
    5270:	8b 45 08             	mov    0x8(%ebp),%eax
    5273:	8b 48 04             	mov    0x4(%eax),%ecx
    5276:	89 f0                	mov    %esi,%eax
    5278:	01 c8                	add    %ecx,%eax
    527a:	0f b6 00             	movzbl (%eax),%eax
    527d:	88 02                	mov    %al,(%edx)
			bs->buf_byte_idx--;
			if ((bs->buf_byte_idx < MINIMUM) || (bs->buf_byte_idx < bs->eob)) {
				if (bs->eob)
					bs->eobs = TRUE;
				else {
					for (i=bs->buf_byte_idx; i>=0;i--)
    527f:	83 ee 01             	sub    $0x1,%esi
    5282:	85 f6                	test   %esi,%esi
    5284:	79 cd                	jns    5253 <getbits+0xab>
						bs->buf[bs->buf_size-1-bs->buf_byte_idx+i] = bs->buf[i];
						refill_buffer(bs);
    5286:	8b 45 08             	mov    0x8(%ebp),%eax
    5289:	89 04 24             	mov    %eax,(%esp)
    528c:	e8 99 fd ff ff       	call   502a <refill_buffer>
					bs->buf_byte_idx = bs->buf_size-1;
    5291:	8b 45 08             	mov    0x8(%ebp),%eax
    5294:	8b 40 08             	mov    0x8(%eax),%eax
    5297:	8d 50 ff             	lea    -0x1(%eax),%edx
    529a:	8b 45 08             	mov    0x8(%ebp),%eax
    529d:	89 50 10             	mov    %edx,0x10(%eax)
				}
			}
		}
		k = MIN(j, bs->buf_bit_idx);
    52a0:	8b 45 08             	mov    0x8(%ebp),%eax
    52a3:	8b 40 14             	mov    0x14(%eax),%eax
    52a6:	39 d8                	cmp    %ebx,%eax
    52a8:	0f 4f c3             	cmovg  %ebx,%eax
    52ab:	89 c6                	mov    %eax,%esi
		tmp = bs->buf[bs->buf_byte_idx]&putmask[bs->buf_bit_idx];
    52ad:	8b 45 08             	mov    0x8(%ebp),%eax
    52b0:	8b 50 04             	mov    0x4(%eax),%edx
    52b3:	8b 45 08             	mov    0x8(%ebp),%eax
    52b6:	8b 40 10             	mov    0x10(%eax),%eax
    52b9:	01 d0                	add    %edx,%eax
    52bb:	0f b6 00             	movzbl (%eax),%eax
    52be:	0f b6 d0             	movzbl %al,%edx
    52c1:	8b 45 08             	mov    0x8(%ebp),%eax
    52c4:	8b 40 14             	mov    0x14(%eax),%eax
    52c7:	8b 04 85 60 e8 00 00 	mov    0xe860(,%eax,4),%eax
    52ce:	89 d7                	mov    %edx,%edi
    52d0:	21 c7                	and    %eax,%edi
		tmp = tmp >> (bs->buf_bit_idx-k);
    52d2:	8b 45 08             	mov    0x8(%ebp),%eax
    52d5:	8b 40 14             	mov    0x14(%eax),%eax
    52d8:	29 f0                	sub    %esi,%eax
    52da:	89 c1                	mov    %eax,%ecx
    52dc:	d3 ff                	sar    %cl,%edi
		val |= tmp << (j-k);
    52de:	89 d8                	mov    %ebx,%eax
    52e0:	29 f0                	sub    %esi,%eax
    52e2:	89 c1                	mov    %eax,%ecx
    52e4:	d3 e7                	shl    %cl,%edi
    52e6:	89 f8                	mov    %edi,%eax
    52e8:	09 45 e4             	or     %eax,-0x1c(%ebp)
		bs->buf_bit_idx -= k;
    52eb:	8b 45 08             	mov    0x8(%ebp),%eax
    52ee:	8b 40 14             	mov    0x14(%eax),%eax
    52f1:	29 f0                	sub    %esi,%eax
    52f3:	89 c2                	mov    %eax,%edx
    52f5:	8b 45 08             	mov    0x8(%ebp),%eax
    52f8:	89 50 14             	mov    %edx,0x14(%eax)
		j -= k;
    52fb:	29 f3                	sub    %esi,%ebx

	if (N > MAX_LENGTH)
		printf(0,"Cannot read or write more than %d bits at a time.\n", MAX_LENGTH);

	bs->totbit += N;
	while (j > 0) {
    52fd:	85 db                	test   %ebx,%ebx
    52ff:	0f 8f ee fe ff ff    	jg     51f3 <getbits+0x4b>
		tmp = tmp >> (bs->buf_bit_idx-k);
		val |= tmp << (j-k);
		bs->buf_bit_idx -= k;
		j -= k;
	}
	return val;
    5305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
    5308:	83 c4 2c             	add    $0x2c,%esp
    530b:	5b                   	pop    %ebx
    530c:	5e                   	pop    %esi
    530d:	5f                   	pop    %edi
    530e:	5d                   	pop    %ebp
    530f:	c3                   	ret    

00005310 <seek_sync>:


int seek_sync(Bit_stream_struc *bs, unsigned long sync, int N)
{
    5310:	55                   	push   %ebp
    5311:	89 e5                	mov    %esp,%ebp
    5313:	83 ec 38             	sub    $0x38,%esp
	unsigned long aligning;
	unsigned long val;
	long maxi = (int)pow(2.0, (double)N) - 1;
    5316:	db 45 10             	fildl  0x10(%ebp)
    5319:	dd 5c 24 08          	fstpl  0x8(%esp)
    531d:	dd 05 08 b1 00 00    	fldl   0xb108
    5323:	dd 1c 24             	fstpl  (%esp)
    5326:	e8 ec f4 ff ff       	call   4817 <pow>
    532b:	d9 7d e6             	fnstcw -0x1a(%ebp)
    532e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
    5332:	b4 0c                	mov    $0xc,%ah
    5334:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
    5338:	d9 6d e4             	fldcw  -0x1c(%ebp)
    533b:	db 5d e0             	fistpl -0x20(%ebp)
    533e:	d9 6d e6             	fldcw  -0x1a(%ebp)
    5341:	8b 45 e0             	mov    -0x20(%ebp),%eax
    5344:	83 e8 01             	sub    $0x1,%eax
    5347:	89 45 f0             	mov    %eax,-0x10(%ebp)

	aligning = sstell(bs)%ALIGNING;
    534a:	8b 45 08             	mov    0x8(%ebp),%eax
    534d:	89 04 24             	mov    %eax,(%esp)
    5350:	e8 ca fc ff ff       	call   501f <sstell>
    5355:	83 e0 07             	and    $0x7,%eax
    5358:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (aligning)
    535b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    535f:	74 17                	je     5378 <seek_sync+0x68>
		getbits(bs, (int)(ALIGNING-aligning));
    5361:	b8 08 00 00 00       	mov    $0x8,%eax
    5366:	2b 45 ec             	sub    -0x14(%ebp),%eax
    5369:	89 44 24 04          	mov    %eax,0x4(%esp)
    536d:	8b 45 08             	mov    0x8(%ebp),%eax
    5370:	89 04 24             	mov    %eax,(%esp)
    5373:	e8 30 fe ff ff       	call   51a8 <getbits>

	val = getbits(bs, N);
    5378:	8b 45 10             	mov    0x10(%ebp),%eax
    537b:	89 44 24 04          	mov    %eax,0x4(%esp)
    537f:	8b 45 08             	mov    0x8(%ebp),%eax
    5382:	89 04 24             	mov    %eax,(%esp)
    5385:	e8 1e fe ff ff       	call   51a8 <getbits>
    538a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (((val&maxi) != sync) && (!end_bs(bs))) {
    538d:	eb 1a                	jmp    53a9 <seek_sync+0x99>
		val <<= ALIGNING;
    538f:	c1 65 f4 08          	shll   $0x8,-0xc(%ebp)
		val |= getbits(bs, ALIGNING);
    5393:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
    539a:	00 
    539b:	8b 45 08             	mov    0x8(%ebp),%eax
    539e:	89 04 24             	mov    %eax,(%esp)
    53a1:	e8 02 fe ff ff       	call   51a8 <getbits>
    53a6:	09 45 f4             	or     %eax,-0xc(%ebp)
	aligning = sstell(bs)%ALIGNING;
	if (aligning)
		getbits(bs, (int)(ALIGNING-aligning));

	val = getbits(bs, N);
	while (((val&maxi) != sync) && (!end_bs(bs))) {
    53a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    53ac:	23 45 f4             	and    -0xc(%ebp),%eax
    53af:	3b 45 0c             	cmp    0xc(%ebp),%eax
    53b2:	74 0f                	je     53c3 <seek_sync+0xb3>
    53b4:	8b 45 08             	mov    0x8(%ebp),%eax
    53b7:	89 04 24             	mov    %eax,(%esp)
    53ba:	e8 55 fc ff ff       	call   5014 <end_bs>
    53bf:	85 c0                	test   %eax,%eax
    53c1:	74 cc                	je     538f <seek_sync+0x7f>
		val <<= ALIGNING;
		val |= getbits(bs, ALIGNING);
	}

	if (end_bs(bs))
    53c3:	8b 45 08             	mov    0x8(%ebp),%eax
    53c6:	89 04 24             	mov    %eax,(%esp)
    53c9:	e8 46 fc ff ff       	call   5014 <end_bs>
    53ce:	85 c0                	test   %eax,%eax
    53d0:	74 07                	je     53d9 <seek_sync+0xc9>
		return(0);
    53d2:	b8 00 00 00 00       	mov    $0x0,%eax
    53d7:	eb 05                	jmp    53de <seek_sync+0xce>
	else
		return(1);
    53d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
    53de:	c9                   	leave  
    53df:	c3                   	ret    

000053e0 <js_bound>:

int js_bound(int lay, int m_ext)
{
    53e0:	55                   	push   %ebp
    53e1:	89 e5                	mov    %esp,%ebp
    53e3:	83 ec 18             	sub    $0x18,%esp
		{ 4, 8, 12, 16 },
		{ 4, 8, 12, 16},
		{ 0, 4, 8, 16}
	};  /* lay+m_e -> jsbound */

    if(lay<1 || lay >3 || m_ext<0 || m_ext>3) {
    53e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    53ea:	7e 12                	jle    53fe <js_bound+0x1e>
    53ec:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
    53f0:	7f 0c                	jg     53fe <js_bound+0x1e>
    53f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    53f6:	78 06                	js     53fe <js_bound+0x1e>
    53f8:	83 7d 0c 03          	cmpl   $0x3,0xc(%ebp)
    53fc:	7e 27                	jle    5425 <js_bound+0x45>
        printf(0, "js_bound bad layer/modext (%d/%d)\n", lay, m_ext);
    53fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    5401:	89 44 24 0c          	mov    %eax,0xc(%esp)
    5405:	8b 45 08             	mov    0x8(%ebp),%eax
    5408:	89 44 24 08          	mov    %eax,0x8(%esp)
    540c:	c7 44 24 04 d0 b0 00 	movl   $0xb0d0,0x4(%esp)
    5413:	00 
    5414:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    541b:	e8 22 ef ff ff       	call   4342 <printf>
        exit();
    5420:	e8 35 ed ff ff       	call   415a <exit>
    }
	return(jsb_table[lay-1][m_ext]);
    5425:	8b 45 08             	mov    0x8(%ebp),%eax
    5428:	83 e8 01             	sub    $0x1,%eax
    542b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    5432:	8b 45 0c             	mov    0xc(%ebp),%eax
    5435:	01 d0                	add    %edx,%eax
    5437:	8b 04 85 a0 e8 00 00 	mov    0xe8a0(,%eax,4),%eax
}
    543e:	c9                   	leave  
    543f:	c3                   	ret    

00005440 <hdr_to_frps>:

void hdr_to_frps(struct frame_params *fr_ps)
{
    5440:	55                   	push   %ebp
    5441:	89 e5                	mov    %esp,%ebp
    5443:	83 ec 28             	sub    $0x28,%esp
	layer *hdr = fr_ps->header;     /* (or pass in as arg?) */
    5446:	8b 45 08             	mov    0x8(%ebp),%eax
    5449:	8b 00                	mov    (%eax),%eax
    544b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	fr_ps->actual_mode = hdr->mode;
    544e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5451:	8b 50 1c             	mov    0x1c(%eax),%edx
    5454:	8b 45 08             	mov    0x8(%ebp),%eax
    5457:	89 50 04             	mov    %edx,0x4(%eax)
	fr_ps->stereo = (hdr->mode == MPG_MD_MONO) ? 1 : 2;
    545a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    545d:	8b 40 1c             	mov    0x1c(%eax),%eax
    5460:	83 f8 03             	cmp    $0x3,%eax
    5463:	75 07                	jne    546c <hdr_to_frps+0x2c>
    5465:	b8 01 00 00 00       	mov    $0x1,%eax
    546a:	eb 05                	jmp    5471 <hdr_to_frps+0x31>
    546c:	b8 02 00 00 00       	mov    $0x2,%eax
    5471:	8b 55 08             	mov    0x8(%ebp),%edx
    5474:	89 42 08             	mov    %eax,0x8(%edx)
	fr_ps->sblimit = SBLIMIT;
    5477:	8b 45 08             	mov    0x8(%ebp),%eax
    547a:	c7 40 10 20 00 00 00 	movl   $0x20,0x10(%eax)
	if(hdr->mode == MPG_MD_JOINT_STEREO)
    5481:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5484:	8b 40 1c             	mov    0x1c(%eax),%eax
    5487:	83 f8 01             	cmp    $0x1,%eax
    548a:	75 20                	jne    54ac <hdr_to_frps+0x6c>
		fr_ps->jsbound = js_bound(hdr->lay, hdr->mode_ext);
    548c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    548f:	8b 50 20             	mov    0x20(%eax),%edx
    5492:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5495:	8b 40 04             	mov    0x4(%eax),%eax
    5498:	89 54 24 04          	mov    %edx,0x4(%esp)
    549c:	89 04 24             	mov    %eax,(%esp)
    549f:	e8 3c ff ff ff       	call   53e0 <js_bound>
    54a4:	8b 55 08             	mov    0x8(%ebp),%edx
    54a7:	89 42 0c             	mov    %eax,0xc(%edx)
    54aa:	eb 0c                	jmp    54b8 <hdr_to_frps+0x78>
	else
		fr_ps->jsbound = fr_ps->sblimit;
    54ac:	8b 45 08             	mov    0x8(%ebp),%eax
    54af:	8b 50 10             	mov    0x10(%eax),%edx
    54b2:	8b 45 08             	mov    0x8(%ebp),%eax
    54b5:	89 50 0c             	mov    %edx,0xc(%eax)
}
    54b8:	c9                   	leave  
    54b9:	c3                   	ret    

000054ba <hputbuf>:

void hputbuf(unsigned int val, int N)
{
    54ba:	55                   	push   %ebp
    54bb:	89 e5                	mov    %esp,%ebp
    54bd:	83 ec 18             	sub    $0x18,%esp
	if (N != 8) {
    54c0:	83 7d 0c 08          	cmpl   $0x8,0xc(%ebp)
    54c4:	74 19                	je     54df <hputbuf+0x25>
		printf(0,"Not Supported yet!!\n");
    54c6:	c7 44 24 04 f3 b0 00 	movl   $0xb0f3,0x4(%esp)
    54cd:	00 
    54ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    54d5:	e8 68 ee ff ff       	call   4342 <printf>
		exit();
    54da:	e8 7b ec ff ff       	call   415a <exit>
	}
	getCoreBuf(1, val);
    54df:	8b 45 08             	mov    0x8(%ebp),%eax
    54e2:	89 44 24 04          	mov    %eax,0x4(%esp)
    54e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    54ed:	e8 68 ed ff ff       	call   425a <getCoreBuf>
//	buf[offset % BUFSIZE] = val;
//	offset++;
}
    54f2:	c9                   	leave  
    54f3:	c3                   	ret    

000054f4 <hsstell>:

unsigned long hsstell()
{
    54f4:	55                   	push   %ebp
    54f5:	89 e5                	mov    %esp,%ebp
    54f7:	83 ec 18             	sub    $0x18,%esp
	return getCoreBuf(2, 0);
    54fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    5501:	00 
    5502:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    5509:	e8 4c ed ff ff       	call   425a <getCoreBuf>
//	return(totbit);
}
    550e:	c9                   	leave  
    550f:	c3                   	ret    

00005510 <hgetbits>:

unsigned long hgetbits(int N)
{
    5510:	55                   	push   %ebp
    5511:	89 e5                	mov    %esp,%ebp
    5513:	83 ec 18             	sub    $0x18,%esp

	return getCoreBuf(3, N);
    5516:	8b 45 08             	mov    0x8(%ebp),%eax
    5519:	89 44 24 04          	mov    %eax,0x4(%esp)
    551d:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
    5524:	e8 31 ed ff ff       	call   425a <getCoreBuf>
}
    5529:	c9                   	leave  
    552a:	c3                   	ret    

0000552b <hget1bit>:


unsigned int hget1bit()
{
    552b:	55                   	push   %ebp
    552c:	89 e5                	mov    %esp,%ebp
    552e:	83 ec 18             	sub    $0x18,%esp
	return(hgetbits(1));
    5531:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    5538:	e8 d3 ff ff ff       	call   5510 <hgetbits>
}
    553d:	c9                   	leave  
    553e:	c3                   	ret    

0000553f <rewindNbits>:


void rewindNbits(int N)
{
    553f:	55                   	push   %ebp
    5540:	89 e5                	mov    %esp,%ebp
    5542:	83 ec 18             	sub    $0x18,%esp
	getCoreBuf(4, N);
    5545:	8b 45 08             	mov    0x8(%ebp),%eax
    5548:	89 44 24 04          	mov    %eax,0x4(%esp)
    554c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    5553:	e8 02 ed ff ff       	call   425a <getCoreBuf>
}
    5558:	c9                   	leave  
    5559:	c3                   	ret    

0000555a <rewindNbytes>:


void rewindNbytes(int N)
{
    555a:	55                   	push   %ebp
    555b:	89 e5                	mov    %esp,%ebp
    555d:	83 ec 18             	sub    $0x18,%esp
	getCoreBuf(5, N);
    5560:	8b 45 08             	mov    0x8(%ebp),%eax
    5563:	89 44 24 04          	mov    %eax,0x4(%esp)
    5567:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
    556e:	e8 e7 ec ff ff       	call   425a <getCoreBuf>
}
    5573:	c9                   	leave  
    5574:	c3                   	ret    

00005575 <read_decoder_table>:
				/* 0..31 Huffman code table 0..31	*/
				/* 32,33 count1-tables			*/

/* ��ȡ huffman ����� */
void read_decoder_table() 
{
    5575:	55                   	push   %ebp
    5576:	89 e5                	mov    %esp,%ebp
    5578:	57                   	push   %edi
    5579:	56                   	push   %esi
    557a:	53                   	push   %ebx
    557b:	81 ec 40 1b 00 00    	sub    $0x1b40,%esp
	unsigned char h1[7][2] = {{0x2,0x1},{0x0,0x0},{0x2,0x1},{0x0,0x10},{0x2,0x1},{0x0,0x1},{0x0,0x11}};
    5581:	c6 45 e6 02          	movb   $0x2,-0x1a(%ebp)
    5585:	c6 45 e7 01          	movb   $0x1,-0x19(%ebp)
    5589:	c6 45 e8 00          	movb   $0x0,-0x18(%ebp)
    558d:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    5591:	c6 45 ea 02          	movb   $0x2,-0x16(%ebp)
    5595:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
    5599:	c6 45 ec 00          	movb   $0x0,-0x14(%ebp)
    559d:	c6 45 ed 10          	movb   $0x10,-0x13(%ebp)
    55a1:	c6 45 ee 02          	movb   $0x2,-0x12(%ebp)
    55a5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
    55a9:	c6 45 f0 00          	movb   $0x0,-0x10(%ebp)
    55ad:	c6 45 f1 01          	movb   $0x1,-0xf(%ebp)
    55b1:	c6 45 f2 00          	movb   $0x0,-0xe(%ebp)
    55b5:	c6 45 f3 11          	movb   $0x11,-0xd(%ebp)

	unsigned char h2[17][2] = {{0x2,0x1},{0x0,0x0},{0x4,0x1},{0x2,0x1},{0x0,0x10},{0x0,0x1},{0x2,0x1},{0x0,0x11},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x21},{0x2,0x1},{0x0,0x12},{0x2,0x1},{0x0,0x2},{0x0,0x22}};
    55b9:	c6 45 c4 02          	movb   $0x2,-0x3c(%ebp)
    55bd:	c6 45 c5 01          	movb   $0x1,-0x3b(%ebp)
    55c1:	c6 45 c6 00          	movb   $0x0,-0x3a(%ebp)
    55c5:	c6 45 c7 00          	movb   $0x0,-0x39(%ebp)
    55c9:	c6 45 c8 04          	movb   $0x4,-0x38(%ebp)
    55cd:	c6 45 c9 01          	movb   $0x1,-0x37(%ebp)
    55d1:	c6 45 ca 02          	movb   $0x2,-0x36(%ebp)
    55d5:	c6 45 cb 01          	movb   $0x1,-0x35(%ebp)
    55d9:	c6 45 cc 00          	movb   $0x0,-0x34(%ebp)
    55dd:	c6 45 cd 10          	movb   $0x10,-0x33(%ebp)
    55e1:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
    55e5:	c6 45 cf 01          	movb   $0x1,-0x31(%ebp)
    55e9:	c6 45 d0 02          	movb   $0x2,-0x30(%ebp)
    55ed:	c6 45 d1 01          	movb   $0x1,-0x2f(%ebp)
    55f1:	c6 45 d2 00          	movb   $0x0,-0x2e(%ebp)
    55f5:	c6 45 d3 11          	movb   $0x11,-0x2d(%ebp)
    55f9:	c6 45 d4 04          	movb   $0x4,-0x2c(%ebp)
    55fd:	c6 45 d5 01          	movb   $0x1,-0x2b(%ebp)
    5601:	c6 45 d6 02          	movb   $0x2,-0x2a(%ebp)
    5605:	c6 45 d7 01          	movb   $0x1,-0x29(%ebp)
    5609:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
    560d:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
    5611:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
    5615:	c6 45 db 21          	movb   $0x21,-0x25(%ebp)
    5619:	c6 45 dc 02          	movb   $0x2,-0x24(%ebp)
    561d:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
    5621:	c6 45 de 00          	movb   $0x0,-0x22(%ebp)
    5625:	c6 45 df 12          	movb   $0x12,-0x21(%ebp)
    5629:	c6 45 e0 02          	movb   $0x2,-0x20(%ebp)
    562d:	c6 45 e1 01          	movb   $0x1,-0x1f(%ebp)
    5631:	c6 45 e2 00          	movb   $0x0,-0x1e(%ebp)
    5635:	c6 45 e3 02          	movb   $0x2,-0x1d(%ebp)
    5639:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
    563d:	c6 45 e5 22          	movb   $0x22,-0x1b(%ebp)

	unsigned char h3[17][2] = {{0x4,0x1},{0x2,0x1},{0x0,0x0},{0x0,0x1},{0x2,0x1},{0x0,0x11},{0x2,0x1},{0x0,0x10},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x21},{0x2,0x1},{0x0,0x12},{0x2,0x1},{0x0,0x2},{0x0,0x22}};
    5641:	c6 45 a2 04          	movb   $0x4,-0x5e(%ebp)
    5645:	c6 45 a3 01          	movb   $0x1,-0x5d(%ebp)
    5649:	c6 45 a4 02          	movb   $0x2,-0x5c(%ebp)
    564d:	c6 45 a5 01          	movb   $0x1,-0x5b(%ebp)
    5651:	c6 45 a6 00          	movb   $0x0,-0x5a(%ebp)
    5655:	c6 45 a7 00          	movb   $0x0,-0x59(%ebp)
    5659:	c6 45 a8 00          	movb   $0x0,-0x58(%ebp)
    565d:	c6 45 a9 01          	movb   $0x1,-0x57(%ebp)
    5661:	c6 45 aa 02          	movb   $0x2,-0x56(%ebp)
    5665:	c6 45 ab 01          	movb   $0x1,-0x55(%ebp)
    5669:	c6 45 ac 00          	movb   $0x0,-0x54(%ebp)
    566d:	c6 45 ad 11          	movb   $0x11,-0x53(%ebp)
    5671:	c6 45 ae 02          	movb   $0x2,-0x52(%ebp)
    5675:	c6 45 af 01          	movb   $0x1,-0x51(%ebp)
    5679:	c6 45 b0 00          	movb   $0x0,-0x50(%ebp)
    567d:	c6 45 b1 10          	movb   $0x10,-0x4f(%ebp)
    5681:	c6 45 b2 04          	movb   $0x4,-0x4e(%ebp)
    5685:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
    5689:	c6 45 b4 02          	movb   $0x2,-0x4c(%ebp)
    568d:	c6 45 b5 01          	movb   $0x1,-0x4b(%ebp)
    5691:	c6 45 b6 00          	movb   $0x0,-0x4a(%ebp)
    5695:	c6 45 b7 20          	movb   $0x20,-0x49(%ebp)
    5699:	c6 45 b8 00          	movb   $0x0,-0x48(%ebp)
    569d:	c6 45 b9 21          	movb   $0x21,-0x47(%ebp)
    56a1:	c6 45 ba 02          	movb   $0x2,-0x46(%ebp)
    56a5:	c6 45 bb 01          	movb   $0x1,-0x45(%ebp)
    56a9:	c6 45 bc 00          	movb   $0x0,-0x44(%ebp)
    56ad:	c6 45 bd 12          	movb   $0x12,-0x43(%ebp)
    56b1:	c6 45 be 02          	movb   $0x2,-0x42(%ebp)
    56b5:	c6 45 bf 01          	movb   $0x1,-0x41(%ebp)
    56b9:	c6 45 c0 00          	movb   $0x0,-0x40(%ebp)
    56bd:	c6 45 c1 02          	movb   $0x2,-0x3f(%ebp)
    56c1:	c6 45 c2 00          	movb   $0x0,-0x3e(%ebp)
    56c5:	c6 45 c3 22          	movb   $0x22,-0x3d(%ebp)

	unsigned char h5[31][2] = {{0x2,0x1},{0x0,0x0},{0x4,0x1},{0x2,0x1},{0x0,0x10},{0x0,0x1},{0x2,0x1},{0x0,0x11},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x2},{0x2,0x1},{0x0,0x21},{0x0,0x12},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x22},{0x0,0x30},{0x2,0x1},{0x0,0x3},{0x0,0x13},{0x2,0x1},{0x0,0x31},{0x2,0x1},{0x0,0x32},{0x2,0x1},{0x0,0x23},{0x0,0x33}};
    56c9:	c6 85 64 ff ff ff 02 	movb   $0x2,-0x9c(%ebp)
    56d0:	c6 85 65 ff ff ff 01 	movb   $0x1,-0x9b(%ebp)
    56d7:	c6 85 66 ff ff ff 00 	movb   $0x0,-0x9a(%ebp)
    56de:	c6 85 67 ff ff ff 00 	movb   $0x0,-0x99(%ebp)
    56e5:	c6 85 68 ff ff ff 04 	movb   $0x4,-0x98(%ebp)
    56ec:	c6 85 69 ff ff ff 01 	movb   $0x1,-0x97(%ebp)
    56f3:	c6 85 6a ff ff ff 02 	movb   $0x2,-0x96(%ebp)
    56fa:	c6 85 6b ff ff ff 01 	movb   $0x1,-0x95(%ebp)
    5701:	c6 85 6c ff ff ff 00 	movb   $0x0,-0x94(%ebp)
    5708:	c6 85 6d ff ff ff 10 	movb   $0x10,-0x93(%ebp)
    570f:	c6 85 6e ff ff ff 00 	movb   $0x0,-0x92(%ebp)
    5716:	c6 85 6f ff ff ff 01 	movb   $0x1,-0x91(%ebp)
    571d:	c6 85 70 ff ff ff 02 	movb   $0x2,-0x90(%ebp)
    5724:	c6 85 71 ff ff ff 01 	movb   $0x1,-0x8f(%ebp)
    572b:	c6 85 72 ff ff ff 00 	movb   $0x0,-0x8e(%ebp)
    5732:	c6 85 73 ff ff ff 11 	movb   $0x11,-0x8d(%ebp)
    5739:	c6 85 74 ff ff ff 08 	movb   $0x8,-0x8c(%ebp)
    5740:	c6 85 75 ff ff ff 01 	movb   $0x1,-0x8b(%ebp)
    5747:	c6 85 76 ff ff ff 04 	movb   $0x4,-0x8a(%ebp)
    574e:	c6 85 77 ff ff ff 01 	movb   $0x1,-0x89(%ebp)
    5755:	c6 85 78 ff ff ff 02 	movb   $0x2,-0x88(%ebp)
    575c:	c6 85 79 ff ff ff 01 	movb   $0x1,-0x87(%ebp)
    5763:	c6 85 7a ff ff ff 00 	movb   $0x0,-0x86(%ebp)
    576a:	c6 85 7b ff ff ff 20 	movb   $0x20,-0x85(%ebp)
    5771:	c6 85 7c ff ff ff 00 	movb   $0x0,-0x84(%ebp)
    5778:	c6 85 7d ff ff ff 02 	movb   $0x2,-0x83(%ebp)
    577f:	c6 85 7e ff ff ff 02 	movb   $0x2,-0x82(%ebp)
    5786:	c6 85 7f ff ff ff 01 	movb   $0x1,-0x81(%ebp)
    578d:	c6 45 80 00          	movb   $0x0,-0x80(%ebp)
    5791:	c6 45 81 21          	movb   $0x21,-0x7f(%ebp)
    5795:	c6 45 82 00          	movb   $0x0,-0x7e(%ebp)
    5799:	c6 45 83 12          	movb   $0x12,-0x7d(%ebp)
    579d:	c6 45 84 08          	movb   $0x8,-0x7c(%ebp)
    57a1:	c6 45 85 01          	movb   $0x1,-0x7b(%ebp)
    57a5:	c6 45 86 04          	movb   $0x4,-0x7a(%ebp)
    57a9:	c6 45 87 01          	movb   $0x1,-0x79(%ebp)
    57ad:	c6 45 88 02          	movb   $0x2,-0x78(%ebp)
    57b1:	c6 45 89 01          	movb   $0x1,-0x77(%ebp)
    57b5:	c6 45 8a 00          	movb   $0x0,-0x76(%ebp)
    57b9:	c6 45 8b 22          	movb   $0x22,-0x75(%ebp)
    57bd:	c6 45 8c 00          	movb   $0x0,-0x74(%ebp)
    57c1:	c6 45 8d 30          	movb   $0x30,-0x73(%ebp)
    57c5:	c6 45 8e 02          	movb   $0x2,-0x72(%ebp)
    57c9:	c6 45 8f 01          	movb   $0x1,-0x71(%ebp)
    57cd:	c6 45 90 00          	movb   $0x0,-0x70(%ebp)
    57d1:	c6 45 91 03          	movb   $0x3,-0x6f(%ebp)
    57d5:	c6 45 92 00          	movb   $0x0,-0x6e(%ebp)
    57d9:	c6 45 93 13          	movb   $0x13,-0x6d(%ebp)
    57dd:	c6 45 94 02          	movb   $0x2,-0x6c(%ebp)
    57e1:	c6 45 95 01          	movb   $0x1,-0x6b(%ebp)
    57e5:	c6 45 96 00          	movb   $0x0,-0x6a(%ebp)
    57e9:	c6 45 97 31          	movb   $0x31,-0x69(%ebp)
    57ed:	c6 45 98 02          	movb   $0x2,-0x68(%ebp)
    57f1:	c6 45 99 01          	movb   $0x1,-0x67(%ebp)
    57f5:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
    57f9:	c6 45 9b 32          	movb   $0x32,-0x65(%ebp)
    57fd:	c6 45 9c 02          	movb   $0x2,-0x64(%ebp)
    5801:	c6 45 9d 01          	movb   $0x1,-0x63(%ebp)
    5805:	c6 45 9e 00          	movb   $0x0,-0x62(%ebp)
    5809:	c6 45 9f 23          	movb   $0x23,-0x61(%ebp)
    580d:	c6 45 a0 00          	movb   $0x0,-0x60(%ebp)
    5811:	c6 45 a1 33          	movb   $0x33,-0x5f(%ebp)

	unsigned char h6[31][2] = {{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x0},{0x0,0x10},{0x0,0x11},{0x6,0x1},{0x2,0x1},{0x0,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x21},{0x6,0x1},{0x2,0x1},{0x0,0x12},{0x2,0x1},{0x0,0x2},{0x0,0x22},{0x4,0x1},{0x2,0x1},{0x0,0x31},{0x0,0x13},{0x4,0x1},{0x2,0x1},{0x0,0x30},{0x0,0x32},{0x2,0x1},{0x0,0x23},{0x2,0x1},{0x0,0x3},{0x0,0x33}};
    5815:	c6 85 26 ff ff ff 06 	movb   $0x6,-0xda(%ebp)
    581c:	c6 85 27 ff ff ff 01 	movb   $0x1,-0xd9(%ebp)
    5823:	c6 85 28 ff ff ff 04 	movb   $0x4,-0xd8(%ebp)
    582a:	c6 85 29 ff ff ff 01 	movb   $0x1,-0xd7(%ebp)
    5831:	c6 85 2a ff ff ff 02 	movb   $0x2,-0xd6(%ebp)
    5838:	c6 85 2b ff ff ff 01 	movb   $0x1,-0xd5(%ebp)
    583f:	c6 85 2c ff ff ff 00 	movb   $0x0,-0xd4(%ebp)
    5846:	c6 85 2d ff ff ff 00 	movb   $0x0,-0xd3(%ebp)
    584d:	c6 85 2e ff ff ff 00 	movb   $0x0,-0xd2(%ebp)
    5854:	c6 85 2f ff ff ff 10 	movb   $0x10,-0xd1(%ebp)
    585b:	c6 85 30 ff ff ff 00 	movb   $0x0,-0xd0(%ebp)
    5862:	c6 85 31 ff ff ff 11 	movb   $0x11,-0xcf(%ebp)
    5869:	c6 85 32 ff ff ff 06 	movb   $0x6,-0xce(%ebp)
    5870:	c6 85 33 ff ff ff 01 	movb   $0x1,-0xcd(%ebp)
    5877:	c6 85 34 ff ff ff 02 	movb   $0x2,-0xcc(%ebp)
    587e:	c6 85 35 ff ff ff 01 	movb   $0x1,-0xcb(%ebp)
    5885:	c6 85 36 ff ff ff 00 	movb   $0x0,-0xca(%ebp)
    588c:	c6 85 37 ff ff ff 01 	movb   $0x1,-0xc9(%ebp)
    5893:	c6 85 38 ff ff ff 02 	movb   $0x2,-0xc8(%ebp)
    589a:	c6 85 39 ff ff ff 01 	movb   $0x1,-0xc7(%ebp)
    58a1:	c6 85 3a ff ff ff 00 	movb   $0x0,-0xc6(%ebp)
    58a8:	c6 85 3b ff ff ff 20 	movb   $0x20,-0xc5(%ebp)
    58af:	c6 85 3c ff ff ff 00 	movb   $0x0,-0xc4(%ebp)
    58b6:	c6 85 3d ff ff ff 21 	movb   $0x21,-0xc3(%ebp)
    58bd:	c6 85 3e ff ff ff 06 	movb   $0x6,-0xc2(%ebp)
    58c4:	c6 85 3f ff ff ff 01 	movb   $0x1,-0xc1(%ebp)
    58cb:	c6 85 40 ff ff ff 02 	movb   $0x2,-0xc0(%ebp)
    58d2:	c6 85 41 ff ff ff 01 	movb   $0x1,-0xbf(%ebp)
    58d9:	c6 85 42 ff ff ff 00 	movb   $0x0,-0xbe(%ebp)
    58e0:	c6 85 43 ff ff ff 12 	movb   $0x12,-0xbd(%ebp)
    58e7:	c6 85 44 ff ff ff 02 	movb   $0x2,-0xbc(%ebp)
    58ee:	c6 85 45 ff ff ff 01 	movb   $0x1,-0xbb(%ebp)
    58f5:	c6 85 46 ff ff ff 00 	movb   $0x0,-0xba(%ebp)
    58fc:	c6 85 47 ff ff ff 02 	movb   $0x2,-0xb9(%ebp)
    5903:	c6 85 48 ff ff ff 00 	movb   $0x0,-0xb8(%ebp)
    590a:	c6 85 49 ff ff ff 22 	movb   $0x22,-0xb7(%ebp)
    5911:	c6 85 4a ff ff ff 04 	movb   $0x4,-0xb6(%ebp)
    5918:	c6 85 4b ff ff ff 01 	movb   $0x1,-0xb5(%ebp)
    591f:	c6 85 4c ff ff ff 02 	movb   $0x2,-0xb4(%ebp)
    5926:	c6 85 4d ff ff ff 01 	movb   $0x1,-0xb3(%ebp)
    592d:	c6 85 4e ff ff ff 00 	movb   $0x0,-0xb2(%ebp)
    5934:	c6 85 4f ff ff ff 31 	movb   $0x31,-0xb1(%ebp)
    593b:	c6 85 50 ff ff ff 00 	movb   $0x0,-0xb0(%ebp)
    5942:	c6 85 51 ff ff ff 13 	movb   $0x13,-0xaf(%ebp)
    5949:	c6 85 52 ff ff ff 04 	movb   $0x4,-0xae(%ebp)
    5950:	c6 85 53 ff ff ff 01 	movb   $0x1,-0xad(%ebp)
    5957:	c6 85 54 ff ff ff 02 	movb   $0x2,-0xac(%ebp)
    595e:	c6 85 55 ff ff ff 01 	movb   $0x1,-0xab(%ebp)
    5965:	c6 85 56 ff ff ff 00 	movb   $0x0,-0xaa(%ebp)
    596c:	c6 85 57 ff ff ff 30 	movb   $0x30,-0xa9(%ebp)
    5973:	c6 85 58 ff ff ff 00 	movb   $0x0,-0xa8(%ebp)
    597a:	c6 85 59 ff ff ff 32 	movb   $0x32,-0xa7(%ebp)
    5981:	c6 85 5a ff ff ff 02 	movb   $0x2,-0xa6(%ebp)
    5988:	c6 85 5b ff ff ff 01 	movb   $0x1,-0xa5(%ebp)
    598f:	c6 85 5c ff ff ff 00 	movb   $0x0,-0xa4(%ebp)
    5996:	c6 85 5d ff ff ff 23 	movb   $0x23,-0xa3(%ebp)
    599d:	c6 85 5e ff ff ff 02 	movb   $0x2,-0xa2(%ebp)
    59a4:	c6 85 5f ff ff ff 01 	movb   $0x1,-0xa1(%ebp)
    59ab:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%ebp)
    59b2:	c6 85 61 ff ff ff 03 	movb   $0x3,-0x9f(%ebp)
    59b9:	c6 85 62 ff ff ff 00 	movb   $0x0,-0x9e(%ebp)
    59c0:	c6 85 63 ff ff ff 33 	movb   $0x33,-0x9d(%ebp)

	unsigned char h7[71][2] = {{0x2,0x1},{0x0,0x0},{0x4,0x1},{0x2,0x1},{0x0,0x10},{0x0,0x1},{0x8,0x1},{0x2,0x1},{0x0,0x11},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x2},{0x0,0x21},{0x12,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x12},{0x2,0x1},{0x0,0x22},{0x0,0x30},{0x4,0x1},{0x2,0x1},{0x0,0x31},{0x0,0x13},{0x4,0x1},{0x2,0x1},{0x0,0x3},{0x0,0x32},{0x2,0x1},{0x0,0x23},{0x0,0x4},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x40},{0x0,0x41},{0x2,0x1},{0x0,0x14},{0x2,0x1},{0x0,0x42},{0x0,0x24},{0xc,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x33},{0x0,0x43},{0x0,0x50},{0x4,0x1},{0x2,0x1},{0x0,0x34},{0x0,0x5},{0x0,0x51},{0x6,0x1},{0x2,0x1},{0x0,0x15},{0x2,0x1},{0x0,0x52},{0x0,0x25},{0x4,0x1},{0x2,0x1},{0x0,0x44},{0x0,0x35},{0x4,0x1},{0x2,0x1},{0x0,0x53},{0x0,0x54},{0x2,0x1},{0x0,0x45},{0x0,0x55}};
    59c7:	8d 95 98 fe ff ff    	lea    -0x168(%ebp),%edx
    59cd:	b8 20 b1 00 00       	mov    $0xb120,%eax
    59d2:	b9 23 00 00 00       	mov    $0x23,%ecx
    59d7:	89 d7                	mov    %edx,%edi
    59d9:	89 c6                	mov    %eax,%esi
    59db:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    59dd:	89 f0                	mov    %esi,%eax
    59df:	89 fa                	mov    %edi,%edx
    59e1:	0f b7 08             	movzwl (%eax),%ecx
    59e4:	66 89 0a             	mov    %cx,(%edx)
    59e7:	83 c2 02             	add    $0x2,%edx
    59ea:	83 c0 02             	add    $0x2,%eax

	unsigned char h8[71][2] = {{0x6,0x1},{0x2,0x1},{0x0,0x0},{0x2,0x1},{0x0,0x10},{0x0,0x1},{0x2,0x1},{0x0,0x11},{0x4,0x1},{0x2,0x1},{0x0,0x21},{0x0,0x12},{0xe,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x2},{0x2,0x1},{0x0,0x22},{0x4,0x1},{0x2,0x1},{0x0,0x30},{0x0,0x3},{0x2,0x1},{0x0,0x31},{0x0,0x13},{0xe,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x32},{0x0,0x23},{0x2,0x1},{0x0,0x40},{0x0,0x4},{0x2,0x1},{0x0,0x41},{0x2,0x1},{0x0,0x14},{0x0,0x42},{0xc,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x24},{0x2,0x1},{0x0,0x33},{0x0,0x50},{0x4,0x1},{0x2,0x1},{0x0,0x43},{0x0,0x34},{0x0,0x51},{0x6,0x1},{0x2,0x1},{0x0,0x15},{0x2,0x1},{0x0,0x5},{0x0,0x52},{0x6,0x1},{0x2,0x1},{0x0,0x25},{0x2,0x1},{0x0,0x44},{0x0,0x35},{0x2,0x1},{0x0,0x53},{0x2,0x1},{0x0,0x45},{0x2,0x1},{0x0,0x54},{0x0,0x55}};
    59ed:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
    59f3:	ba c0 b1 00 00       	mov    $0xb1c0,%edx
    59f8:	bb 8e 00 00 00       	mov    $0x8e,%ebx
    59fd:	89 c1                	mov    %eax,%ecx
    59ff:	83 e1 02             	and    $0x2,%ecx
    5a02:	85 c9                	test   %ecx,%ecx
    5a04:	74 0f                	je     5a15 <read_decoder_table+0x4a0>
    5a06:	0f b7 0a             	movzwl (%edx),%ecx
    5a09:	66 89 08             	mov    %cx,(%eax)
    5a0c:	83 c0 02             	add    $0x2,%eax
    5a0f:	83 c2 02             	add    $0x2,%edx
    5a12:	83 eb 02             	sub    $0x2,%ebx
    5a15:	89 d9                	mov    %ebx,%ecx
    5a17:	c1 e9 02             	shr    $0x2,%ecx
    5a1a:	89 c7                	mov    %eax,%edi
    5a1c:	89 d6                	mov    %edx,%esi
    5a1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    5a20:	89 f2                	mov    %esi,%edx
    5a22:	89 f8                	mov    %edi,%eax
    5a24:	b9 00 00 00 00       	mov    $0x0,%ecx
    5a29:	89 de                	mov    %ebx,%esi
    5a2b:	83 e6 02             	and    $0x2,%esi
    5a2e:	85 f6                	test   %esi,%esi
    5a30:	74 0b                	je     5a3d <read_decoder_table+0x4c8>
    5a32:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
    5a36:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
    5a3a:	83 c1 02             	add    $0x2,%ecx
    5a3d:	83 e3 01             	and    $0x1,%ebx
    5a40:	85 db                	test   %ebx,%ebx
    5a42:	74 07                	je     5a4b <read_decoder_table+0x4d6>
    5a44:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
    5a48:	88 14 08             	mov    %dl,(%eax,%ecx,1)

	unsigned char h9[71][2] = {{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x0},{0x0,0x10},{0x2,0x1},{0x0,0x1},{0x0,0x11},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x21},{0x2,0x1},{0x0,0x12},{0x2,0x1},{0x0,0x2},{0x0,0x22},{0xc,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x30},{0x0,0x3},{0x0,0x31},{0x2,0x1},{0x0,0x13},{0x2,0x1},{0x0,0x32},{0x0,0x23},{0xc,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x41},{0x0,0x14},{0x4,0x1},{0x2,0x1},{0x0,0x40},{0x0,0x33},{0x2,0x1},{0x0,0x42},{0x0,0x24},{0xa,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x4},{0x0,0x50},{0x0,0x43},{0x2,0x1},{0x0,0x34},{0x0,0x51},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x15},{0x0,0x52},{0x2,0x1},{0x0,0x25},{0x0,0x44},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x5},{0x0,0x54},{0x0,0x53},{0x2,0x1},{0x0,0x35},{0x2,0x1},{0x0,0x45},{0x0,0x55}};
    5a4b:	8d 95 7c fd ff ff    	lea    -0x284(%ebp),%edx
    5a51:	b8 60 b2 00 00       	mov    $0xb260,%eax
    5a56:	b9 23 00 00 00       	mov    $0x23,%ecx
    5a5b:	89 d7                	mov    %edx,%edi
    5a5d:	89 c6                	mov    %eax,%esi
    5a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    5a61:	89 f0                	mov    %esi,%eax
    5a63:	89 fa                	mov    %edi,%edx
    5a65:	0f b7 08             	movzwl (%eax),%ecx
    5a68:	66 89 0a             	mov    %cx,(%edx)
    5a6b:	83 c2 02             	add    $0x2,%edx
    5a6e:	83 c0 02             	add    $0x2,%eax

	unsigned char h10[127][2] = {{0x2,0x1},{0x0,0x0},{0x4,0x1},{0x2,0x1},{0x0,0x10},{0x0,0x1},{0xa,0x1},{0x2,0x1},{0x0,0x11},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x2},{0x2,0x1},{0x0,0x21},{0x0,0x12},{0x1c,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x22},{0x0,0x30},{0x2,0x1},{0x0,0x31},{0x0,0x13},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x3},{0x0,0x32},{0x2,0x1},{0x0,0x23},{0x0,0x40},{0x4,0x1},{0x2,0x1},{0x0,0x41},{0x0,0x14},{0x4,0x1},{0x2,0x1},{0x0,0x4},{0x0,0x33},{0x2,0x1},{0x0,0x42},{0x0,0x24},{0x1c,0x1},{0xa,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x50},{0x0,0x5},{0x0,0x60},{0x2,0x1},{0x0,0x61},{0x0,0x16},{0xc,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x43},{0x0,0x34},{0x0,0x51},{0x2,0x1},{0x0,0x15},{0x2,0x1},{0x0,0x52},{0x0,0x25},{0x4,0x1},{0x2,0x1},{0x0,0x26},{0x0,0x36},{0x0,0x71},{0x14,0x1},{0x8,0x1},{0x2,0x1},{0x0,0x17},{0x4,0x1},{0x2,0x1},{0x0,0x44},{0x0,0x53},{0x0,0x6},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x35},{0x0,0x45},{0x0,0x62},{0x2,0x1},{0x0,0x70},{0x2,0x1},{0x0,0x7},{0x0,0x64},{0xe,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x72},{0x0,0x27},{0x6,0x1},{0x2,0x1},{0x0,0x63},{0x2,0x1},{0x0,0x54},{0x0,0x55},{0x2,0x1},{0x0,0x46},{0x0,0x73},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x37},{0x0,0x65},{0x2,0x1},{0x0,0x56},{0x0,0x74},{0x6,0x1},{0x2,0x1},{0x0,0x47},{0x2,0x1},{0x0,0x66},{0x0,0x75},{0x4,0x1},{0x2,0x1},{0x0,0x57},{0x0,0x76},{0x2,0x1},{0x0,0x67},{0x0,0x77}};
    5a71:	8d 85 7e fc ff ff    	lea    -0x382(%ebp),%eax
    5a77:	ba 00 b3 00 00       	mov    $0xb300,%edx
    5a7c:	bb fe 00 00 00       	mov    $0xfe,%ebx
    5a81:	89 c1                	mov    %eax,%ecx
    5a83:	83 e1 02             	and    $0x2,%ecx
    5a86:	85 c9                	test   %ecx,%ecx
    5a88:	74 0f                	je     5a99 <read_decoder_table+0x524>
    5a8a:	0f b7 0a             	movzwl (%edx),%ecx
    5a8d:	66 89 08             	mov    %cx,(%eax)
    5a90:	83 c0 02             	add    $0x2,%eax
    5a93:	83 c2 02             	add    $0x2,%edx
    5a96:	83 eb 02             	sub    $0x2,%ebx
    5a99:	89 d9                	mov    %ebx,%ecx
    5a9b:	c1 e9 02             	shr    $0x2,%ecx
    5a9e:	89 c7                	mov    %eax,%edi
    5aa0:	89 d6                	mov    %edx,%esi
    5aa2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    5aa4:	89 f2                	mov    %esi,%edx
    5aa6:	89 f8                	mov    %edi,%eax
    5aa8:	b9 00 00 00 00       	mov    $0x0,%ecx
    5aad:	89 de                	mov    %ebx,%esi
    5aaf:	83 e6 02             	and    $0x2,%esi
    5ab2:	85 f6                	test   %esi,%esi
    5ab4:	74 0b                	je     5ac1 <read_decoder_table+0x54c>
    5ab6:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
    5aba:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
    5abe:	83 c1 02             	add    $0x2,%ecx
    5ac1:	83 e3 01             	and    $0x1,%ebx
    5ac4:	85 db                	test   %ebx,%ebx
    5ac6:	74 07                	je     5acf <read_decoder_table+0x55a>
    5ac8:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
    5acc:	88 14 08             	mov    %dl,(%eax,%ecx,1)

	unsigned char h11[127][2] = {{0x6,0x1},{0x2,0x1},{0x0,0x0},{0x2,0x1},{0x0,0x10},{0x0,0x1},{0x8,0x1},{0x2,0x1},{0x0,0x11},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x2},{0x0,0x12},{0x18,0x1},{0x8,0x1},{0x2,0x1},{0x0,0x21},{0x2,0x1},{0x0,0x22},{0x2,0x1},{0x0,0x30},{0x0,0x3},{0x4,0x1},{0x2,0x1},{0x0,0x31},{0x0,0x13},{0x4,0x1},{0x2,0x1},{0x0,0x32},{0x0,0x23},{0x4,0x1},{0x2,0x1},{0x0,0x40},{0x0,0x4},{0x2,0x1},{0x0,0x41},{0x0,0x14},{0x1e,0x1},{0x10,0x1},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x42},{0x0,0x24},{0x4,0x1},{0x2,0x1},{0x0,0x33},{0x0,0x43},{0x0,0x50},{0x4,0x1},{0x2,0x1},{0x0,0x34},{0x0,0x51},{0x0,0x61},{0x6,0x1},{0x2,0x1},{0x0,0x16},{0x2,0x1},{0x0,0x6},{0x0,0x26},{0x2,0x1},{0x0,0x62},{0x2,0x1},{0x0,0x15},{0x2,0x1},{0x0,0x5},{0x0,0x52},{0x10,0x1},{0xa,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x25},{0x0,0x44},{0x0,0x60},{0x2,0x1},{0x0,0x63},{0x0,0x36},{0x4,0x1},{0x2,0x1},{0x0,0x70},{0x0,0x17},{0x0,0x71},{0x10,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x7},{0x0,0x64},{0x0,0x72},{0x2,0x1},{0x0,0x27},{0x4,0x1},{0x2,0x1},{0x0,0x53},{0x0,0x35},{0x2,0x1},{0x0,0x54},{0x0,0x45},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x46},{0x0,0x73},{0x2,0x1},{0x0,0x37},{0x2,0x1},{0x0,0x65},{0x0,0x56},{0xa,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x55},{0x0,0x57},{0x0,0x74},{0x2,0x1},{0x0,0x47},{0x0,0x66},{0x4,0x1},{0x2,0x1},{0x0,0x75},{0x0,0x76},{0x2,0x1},{0x0,0x67},{0x0,0x77}};
    5acf:	8d 95 80 fb ff ff    	lea    -0x480(%ebp),%edx
    5ad5:	b8 00 b4 00 00       	mov    $0xb400,%eax
    5ada:	b9 3f 00 00 00       	mov    $0x3f,%ecx
    5adf:	89 d7                	mov    %edx,%edi
    5ae1:	89 c6                	mov    %eax,%esi
    5ae3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    5ae5:	89 f0                	mov    %esi,%eax
    5ae7:	89 fa                	mov    %edi,%edx
    5ae9:	0f b7 08             	movzwl (%eax),%ecx
    5aec:	66 89 0a             	mov    %cx,(%edx)
    5aef:	83 c2 02             	add    $0x2,%edx
    5af2:	83 c0 02             	add    $0x2,%eax

	unsigned char h12[127][2] = {{0xc,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x10},{0x0,0x1},{0x2,0x1},{0x0,0x11},{0x2,0x1},{0x0,0x0},{0x2,0x1},{0x0,0x20},{0x0,0x2},{0x10,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x21},{0x0,0x12},{0x4,0x1},{0x2,0x1},{0x0,0x22},{0x0,0x31},{0x2,0x1},{0x0,0x13},{0x2,0x1},{0x0,0x30},{0x2,0x1},{0x0,0x3},{0x0,0x40},{0x1a,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x32},{0x0,0x23},{0x2,0x1},{0x0,0x41},{0x0,0x33},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x14},{0x0,0x42},{0x2,0x1},{0x0,0x24},{0x2,0x1},{0x0,0x4},{0x0,0x50},{0x4,0x1},{0x2,0x1},{0x0,0x43},{0x0,0x34},{0x2,0x1},{0x0,0x51},{0x0,0x15},{0x1c,0x1},{0xe,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x52},{0x0,0x25},{0x2,0x1},{0x0,0x53},{0x0,0x35},{0x4,0x1},{0x2,0x1},{0x0,0x60},{0x0,0x16},{0x0,0x61},{0x4,0x1},{0x2,0x1},{0x0,0x62},{0x0,0x26},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x5},{0x0,0x6},{0x0,0x44},{0x2,0x1},{0x0,0x54},{0x0,0x45},{0x12,0x1},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x63},{0x0,0x36},{0x4,0x1},{0x2,0x1},{0x0,0x70},{0x0,0x7},{0x0,0x71},{0x4,0x1},{0x2,0x1},{0x0,0x17},{0x0,0x64},{0x2,0x1},{0x0,0x46},{0x0,0x72},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x27},{0x2,0x1},{0x0,0x55},{0x0,0x73},{0x2,0x1},{0x0,0x37},{0x0,0x56},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x65},{0x0,0x74},{0x2,0x1},{0x0,0x47},{0x0,0x66},{0x4,0x1},{0x2,0x1},{0x0,0x75},{0x0,0x57},{0x2,0x1},{0x0,0x76},{0x2,0x1},{0x0,0x67},{0x0,0x77}};
    5af5:	8d 85 82 fa ff ff    	lea    -0x57e(%ebp),%eax
    5afb:	ba 00 b5 00 00       	mov    $0xb500,%edx
    5b00:	bb fe 00 00 00       	mov    $0xfe,%ebx
    5b05:	89 c1                	mov    %eax,%ecx
    5b07:	83 e1 02             	and    $0x2,%ecx
    5b0a:	85 c9                	test   %ecx,%ecx
    5b0c:	74 0f                	je     5b1d <read_decoder_table+0x5a8>
    5b0e:	0f b7 0a             	movzwl (%edx),%ecx
    5b11:	66 89 08             	mov    %cx,(%eax)
    5b14:	83 c0 02             	add    $0x2,%eax
    5b17:	83 c2 02             	add    $0x2,%edx
    5b1a:	83 eb 02             	sub    $0x2,%ebx
    5b1d:	89 d9                	mov    %ebx,%ecx
    5b1f:	c1 e9 02             	shr    $0x2,%ecx
    5b22:	89 c7                	mov    %eax,%edi
    5b24:	89 d6                	mov    %edx,%esi
    5b26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    5b28:	89 f2                	mov    %esi,%edx
    5b2a:	89 f8                	mov    %edi,%eax
    5b2c:	b9 00 00 00 00       	mov    $0x0,%ecx
    5b31:	89 de                	mov    %ebx,%esi
    5b33:	83 e6 02             	and    $0x2,%esi
    5b36:	85 f6                	test   %esi,%esi
    5b38:	74 0b                	je     5b45 <read_decoder_table+0x5d0>
    5b3a:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
    5b3e:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
    5b42:	83 c1 02             	add    $0x2,%ecx
    5b45:	83 e3 01             	and    $0x1,%ebx
    5b48:	85 db                	test   %ebx,%ebx
    5b4a:	74 07                	je     5b53 <read_decoder_table+0x5de>
    5b4c:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
    5b50:	88 14 08             	mov    %dl,(%eax,%ecx,1)

	unsigned char h13[511][2] = {{0x2,0x1},{0x0,0x0},{0x6,0x1},{0x2,0x1},{0x0,0x10},{0x2,0x1},{0x0,0x1},{0x0,0x11},{0x1c,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x2},{0x2,0x1},{0x0,0x21},{0x0,0x12},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x22},{0x0,0x30},{0x2,0x1},{0x0,0x3},{0x0,0x31},{0x6,0x1},{0x2,0x1},{0x0,0x13},{0x2,0x1},{0x0,0x32},{0x0,0x23},{0x4,0x1},{0x2,0x1},{0x0,0x40},{0x0,0x4},{0x0,0x41},{0x46,0x1},{0x1c,0x1},{0xe,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x14},{0x2,0x1},{0x0,0x33},{0x0,0x42},{0x4,0x1},{0x2,0x1},{0x0,0x24},{0x0,0x50},{0x2,0x1},{0x0,0x43},{0x0,0x34},{0x4,0x1},{0x2,0x1},{0x0,0x51},{0x0,0x15},{0x4,0x1},{0x2,0x1},{0x0,0x5},{0x0,0x52},{0x2,0x1},{0x0,0x25},{0x2,0x1},{0x0,0x44},{0x0,0x53},{0xe,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x60},{0x0,0x6},{0x2,0x1},{0x0,0x61},{0x0,0x16},{0x4,0x1},{0x2,0x1},{0x0,0x80},{0x0,0x8},{0x0,0x81},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x35},{0x0,0x62},{0x2,0x1},{0x0,0x26},{0x0,0x54},{0x4,0x1},{0x2,0x1},{0x0,0x45},{0x0,0x63},{0x2,0x1},{0x0,0x36},{0x0,0x70},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x7},{0x0,0x55},{0x0,0x71},{0x2,0x1},{0x0,0x17},{0x2,0x1},{0x0,0x27},{0x0,0x37},{0x48,0x1},{0x18,0x1},{0xc,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x18},{0x0,0x82},{0x2,0x1},{0x0,0x28},{0x4,0x1},{0x2,0x1},{0x0,0x64},{0x0,0x46},{0x0,0x72},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x84},{0x0,0x48},{0x2,0x1},{0x0,0x90},{0x0,0x9},{0x2,0x1},{0x0,0x91},{0x0,0x19},{0x18,0x1},{0xe,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x73},{0x0,0x65},{0x2,0x1},{0x0,0x56},{0x0,0x74},{0x4,0x1},{0x2,0x1},{0x0,0x47},{0x0,0x66},{0x0,0x83},{0x6,0x1},{0x2,0x1},{0x0,0x38},{0x2,0x1},{0x0,0x75},{0x0,0x57},{0x2,0x1},{0x0,0x92},{0x0,0x29},{0xe,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x67},{0x0,0x85},{0x2,0x1},{0x0,0x58},{0x0,0x39},{0x2,0x1},{0x0,0x93},{0x2,0x1},{0x0,0x49},{0x0,0x86},{0x6,0x1},{0x2,0x1},{0x0,0xa0},{0x2,0x1},{0x0,0x68},{0x0,0xa},{0x2,0x1},{0x0,0xa1},{0x0,0x1a},{0x44,0x1},{0x18,0x1},{0xc,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xa2},{0x0,0x2a},{0x4,0x1},{0x2,0x1},{0x0,0x95},{0x0,0x59},{0x2,0x1},{0x0,0xa3},{0x0,0x3a},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x4a},{0x0,0x96},{0x2,0x1},{0x0,0xb0},{0x0,0xb},{0x2,0x1},{0x0,0xb1},{0x0,0x1b},{0x14,0x1},{0x8,0x1},{0x2,0x1},{0x0,0xb2},{0x4,0x1},{0x2,0x1},{0x0,0x76},{0x0,0x77},{0x0,0x94},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x87},{0x0,0x78},{0x0,0xa4},{0x4,0x1},{0x2,0x1},{0x0,0x69},{0x0,0xa5},{0x0,0x2b},{0xc,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x5a},{0x0,0x88},{0x0,0xb3},{0x2,0x1},{0x0,0x3b},{0x2,0x1},{0x0,0x79},{0x0,0xa6},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x6a},{0x0,0xb4},{0x0,0xc0},{0x4,0x1},{0x2,0x1},{0x0,0xc},{0x0,0x98},{0x0,0xc1},{0x3c,0x1},{0x16,0x1},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x1c},{0x2,0x1},{0x0,0x89},{0x0,0xb5},{0x2,0x1},{0x0,0x5b},{0x0,0xc2},{0x4,0x1},{0x2,0x1},{0x0,0x2c},{0x0,0x3c},{0x4,0x1},{0x2,0x1},{0x0,0xb6},{0x0,0x6b},{0x2,0x1},{0x0,0xc4},{0x0,0x4c},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xa8},{0x0,0x8a},{0x2,0x1},{0x0,0xd0},{0x0,0xd},{0x2,0x1},{0x0,0xd1},{0x2,0x1},{0x0,0x4b},{0x2,0x1},{0x0,0x97},{0x0,0xa7},{0xc,0x1},{0x6,0x1},{0x2,0x1},{0x0,0xc3},{0x2,0x1},{0x0,0x7a},{0x0,0x99},{0x4,0x1},{0x2,0x1},{0x0,0xc5},{0x0,0x5c},{0x0,0xb7},{0x4,0x1},{0x2,0x1},{0x0,0x1d},{0x0,0xd2},{0x2,0x1},{0x0,0x2d},{0x2,0x1},{0x0,0x7b},{0x0,0xd3},{0x34,0x1},{0x1c,0x1},{0xc,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x3d},{0x0,0xc6},{0x4,0x1},{0x2,0x1},{0x0,0x6c},{0x0,0xa9},{0x2,0x1},{0x0,0x9a},{0x0,0xd4},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xb8},{0x0,0x8b},{0x2,0x1},{0x0,0x4d},{0x0,0xc7},{0x4,0x1},{0x2,0x1},{0x0,0x7c},{0x0,0xd5},{0x2,0x1},{0x0,0x5d},{0x0,0xe0},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xe1},{0x0,0x1e},{0x4,0x1},{0x2,0x1},{0x0,0xe},{0x0,0x2e},{0x0,0xe2},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xe3},{0x0,0x6d},{0x2,0x1},{0x0,0x8c},{0x0,0xe4},{0x4,0x1},{0x2,0x1},{0x0,0xe5},{0x0,0xba},{0x0,0xf0},{0x26,0x1},{0x10,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xf1},{0x0,0x1f},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xaa},{0x0,0x9b},{0x0,0xb9},{0x2,0x1},{0x0,0x3e},{0x2,0x1},{0x0,0xd6},{0x0,0xc8},{0xc,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x4e},{0x2,0x1},{0x0,0xd7},{0x0,0x7d},{0x2,0x1},{0x0,0xab},{0x2,0x1},{0x0,0x5e},{0x0,0xc9},{0x6,0x1},{0x2,0x1},{0x0,0xf},{0x2,0x1},{0x0,0x9c},{0x0,0x6e},{0x2,0x1},{0x0,0xf2},{0x0,0x2f},{0x20,0x1},{0x10,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xd8},{0x0,0x8d},{0x0,0x3f},{0x6,0x1},{0x2,0x1},{0x0,0xf3},{0x2,0x1},{0x0,0xe6},{0x0,0xca},{0x2,0x1},{0x0,0xf4},{0x0,0x4f},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xbb},{0x0,0xac},{0x2,0x1},{0x0,0xe7},{0x0,0xf5},{0x4,0x1},{0x2,0x1},{0x0,0xd9},{0x0,0x9d},{0x2,0x1},{0x0,0x5f},{0x0,0xe8},{0x1e,0x1},{0xc,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x6f},{0x2,0x1},{0x0,0xf6},{0x0,0xcb},{0x4,0x1},{0x2,0x1},{0x0,0xbc},{0x0,0xad},{0x0,0xda},{0x8,0x1},{0x2,0x1},{0x0,0xf7},{0x4,0x1},{0x2,0x1},{0x0,0x7e},{0x0,0x7f},{0x0,0x8e},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x9e},{0x0,0xae},{0x0,0xcc},{0x2,0x1},{0x0,0xf8},{0x0,0x8f},{0x12,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xdb},{0x0,0xbd},{0x2,0x1},{0x0,0xea},{0x0,0xf9},{0x4,0x1},{0x2,0x1},{0x0,0x9f},{0x0,0xeb},{0x2,0x1},{0x0,0xbe},{0x2,0x1},{0x0,0xcd},{0x0,0xfa},{0xe,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xdd},{0x0,0xec},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xe9},{0x0,0xaf},{0x0,0xdc},{0x2,0x1},{0x0,0xce},{0x0,0xfb},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xbf},{0x0,0xde},{0x2,0x1},{0x0,0xcf},{0x0,0xee},{0x4,0x1},{0x2,0x1},{0x0,0xdf},{0x0,0xef},{0x2,0x1},{0x0,0xff},{0x2,0x1},{0x0,0xed},{0x2,0x1},{0x0,0xfd},{0x2,0x1},{0x0,0xfc},{0x0,0xfe}};
    5b53:	8d 95 84 f6 ff ff    	lea    -0x97c(%ebp),%edx
    5b59:	b8 00 b6 00 00       	mov    $0xb600,%eax
    5b5e:	b9 ff 00 00 00       	mov    $0xff,%ecx
    5b63:	89 d7                	mov    %edx,%edi
    5b65:	89 c6                	mov    %eax,%esi
    5b67:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    5b69:	89 f0                	mov    %esi,%eax
    5b6b:	89 fa                	mov    %edi,%edx
    5b6d:	0f b7 08             	movzwl (%eax),%ecx
    5b70:	66 89 0a             	mov    %cx,(%edx)
    5b73:	83 c2 02             	add    $0x2,%edx
    5b76:	83 c0 02             	add    $0x2,%eax

	unsigned char h15[511][2] = {{0x10,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x0},{0x2,0x1},{0x0,0x10},{0x0,0x1},{0x2,0x1},{0x0,0x11},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x2},{0x2,0x1},{0x0,0x21},{0x0,0x12},{0x32,0x1},{0x10,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x22},{0x2,0x1},{0x0,0x30},{0x0,0x31},{0x6,0x1},{0x2,0x1},{0x0,0x13},{0x2,0x1},{0x0,0x3},{0x0,0x40},{0x2,0x1},{0x0,0x32},{0x0,0x23},{0xe,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x4},{0x0,0x14},{0x0,0x41},{0x4,0x1},{0x2,0x1},{0x0,0x33},{0x0,0x42},{0x2,0x1},{0x0,0x24},{0x0,0x43},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x34},{0x2,0x1},{0x0,0x50},{0x0,0x5},{0x2,0x1},{0x0,0x51},{0x0,0x15},{0x4,0x1},{0x2,0x1},{0x0,0x52},{0x0,0x25},{0x4,0x1},{0x2,0x1},{0x0,0x44},{0x0,0x53},{0x0,0x61},{0x5a,0x1},{0x24,0x1},{0x12,0x1},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x35},{0x2,0x1},{0x0,0x60},{0x0,0x6},{0x2,0x1},{0x0,0x16},{0x0,0x62},{0x4,0x1},{0x2,0x1},{0x0,0x26},{0x0,0x54},{0x2,0x1},{0x0,0x45},{0x0,0x63},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x36},{0x2,0x1},{0x0,0x70},{0x0,0x7},{0x2,0x1},{0x0,0x71},{0x0,0x55},{0x4,0x1},{0x2,0x1},{0x0,0x17},{0x0,0x64},{0x2,0x1},{0x0,0x72},{0x0,0x27},{0x18,0x1},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x46},{0x0,0x73},{0x2,0x1},{0x0,0x37},{0x0,0x65},{0x4,0x1},{0x2,0x1},{0x0,0x56},{0x0,0x80},{0x2,0x1},{0x0,0x8},{0x0,0x74},{0x4,0x1},{0x2,0x1},{0x0,0x81},{0x0,0x18},{0x2,0x1},{0x0,0x82},{0x0,0x28},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x47},{0x0,0x66},{0x2,0x1},{0x0,0x83},{0x0,0x38},{0x4,0x1},{0x2,0x1},{0x0,0x75},{0x0,0x57},{0x2,0x1},{0x0,0x84},{0x0,0x48},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x90},{0x0,0x19},{0x0,0x91},{0x4,0x1},{0x2,0x1},{0x0,0x92},{0x0,0x76},{0x2,0x1},{0x0,0x67},{0x0,0x29},{0x5c,0x1},{0x24,0x1},{0x12,0x1},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x85},{0x0,0x58},{0x4,0x1},{0x2,0x1},{0x0,0x9},{0x0,0x77},{0x0,0x93},{0x4,0x1},{0x2,0x1},{0x0,0x39},{0x0,0x94},{0x2,0x1},{0x0,0x49},{0x0,0x86},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x68},{0x2,0x1},{0x0,0xa0},{0x0,0xa},{0x2,0x1},{0x0,0xa1},{0x0,0x1a},{0x4,0x1},{0x2,0x1},{0x0,0xa2},{0x0,0x2a},{0x2,0x1},{0x0,0x95},{0x0,0x59},{0x1a,0x1},{0xe,0x1},{0x6,0x1},{0x2,0x1},{0x0,0xa3},{0x2,0x1},{0x0,0x3a},{0x0,0x87},{0x4,0x1},{0x2,0x1},{0x0,0x78},{0x0,0xa4},{0x2,0x1},{0x0,0x4a},{0x0,0x96},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x69},{0x0,0xb0},{0x0,0xb1},{0x4,0x1},{0x2,0x1},{0x0,0x1b},{0x0,0xa5},{0x0,0xb2},{0xe,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x5a},{0x0,0x2b},{0x2,0x1},{0x0,0x88},{0x0,0x97},{0x2,0x1},{0x0,0xb3},{0x2,0x1},{0x0,0x79},{0x0,0x3b},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x6a},{0x0,0xb4},{0x2,0x1},{0x0,0x4b},{0x0,0xc1},{0x4,0x1},{0x2,0x1},{0x0,0x98},{0x0,0x89},{0x2,0x1},{0x0,0x1c},{0x0,0xb5},{0x50,0x1},{0x22,0x1},{0x10,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x5b},{0x0,0x2c},{0x0,0xc2},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xb},{0x0,0xc0},{0x0,0xa6},{0x2,0x1},{0x0,0xa7},{0x0,0x7a},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xc3},{0x0,0x3c},{0x4,0x1},{0x2,0x1},{0x0,0xc},{0x0,0x99},{0x0,0xb6},{0x4,0x1},{0x2,0x1},{0x0,0x6b},{0x0,0xc4},{0x2,0x1},{0x0,0x4c},{0x0,0xa8},{0x14,0x1},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x8a},{0x0,0xc5},{0x4,0x1},{0x2,0x1},{0x0,0xd0},{0x0,0x5c},{0x0,0xd1},{0x4,0x1},{0x2,0x1},{0x0,0xb7},{0x0,0x7b},{0x2,0x1},{0x0,0x1d},{0x2,0x1},{0x0,0xd},{0x0,0x2d},{0xc,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xd2},{0x0,0xd3},{0x4,0x1},{0x2,0x1},{0x0,0x3d},{0x0,0xc6},{0x2,0x1},{0x0,0x6c},{0x0,0xa9},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x9a},{0x0,0xb8},{0x0,0xd4},{0x4,0x1},{0x2,0x1},{0x0,0x8b},{0x0,0x4d},{0x2,0x1},{0x0,0xc7},{0x0,0x7c},{0x44,0x1},{0x22,0x1},{0x12,0x1},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xd5},{0x0,0x5d},{0x4,0x1},{0x2,0x1},{0x0,0xe0},{0x0,0xe},{0x0,0xe1},{0x4,0x1},{0x2,0x1},{0x0,0x1e},{0x0,0xe2},{0x2,0x1},{0x0,0xaa},{0x0,0x2e},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xb9},{0x0,0x9b},{0x2,0x1},{0x0,0xe3},{0x0,0xd6},{0x4,0x1},{0x2,0x1},{0x0,0x6d},{0x0,0x3e},{0x2,0x1},{0x0,0xc8},{0x0,0x8c},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xe4},{0x0,0x4e},{0x2,0x1},{0x0,0xd7},{0x0,0x7d},{0x4,0x1},{0x2,0x1},{0x0,0xe5},{0x0,0xba},{0x2,0x1},{0x0,0xab},{0x0,0x5e},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xc9},{0x0,0x9c},{0x2,0x1},{0x0,0xf1},{0x0,0x1f},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xf0},{0x0,0x6e},{0x0,0xf2},{0x2,0x1},{0x0,0x2f},{0x0,0xe6},{0x26,0x1},{0x12,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xd8},{0x0,0xf3},{0x2,0x1},{0x0,0x3f},{0x0,0xf4},{0x6,0x1},{0x2,0x1},{0x0,0x4f},{0x2,0x1},{0x0,0x8d},{0x0,0xd9},{0x2,0x1},{0x0,0xbb},{0x0,0xca},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xac},{0x0,0xe7},{0x2,0x1},{0x0,0x7e},{0x0,0xf5},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x9d},{0x0,0x5f},{0x2,0x1},{0x0,0xe8},{0x0,0x8e},{0x2,0x1},{0x0,0xf6},{0x0,0xcb},{0x22,0x1},{0x12,0x1},{0xa,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xf},{0x0,0xae},{0x0,0x6f},{0x2,0x1},{0x0,0xbc},{0x0,0xda},{0x4,0x1},{0x2,0x1},{0x0,0xad},{0x0,0xf7},{0x2,0x1},{0x0,0x7f},{0x0,0xe9},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x9e},{0x0,0xcc},{0x2,0x1},{0x0,0xf8},{0x0,0x8f},{0x4,0x1},{0x2,0x1},{0x0,0xdb},{0x0,0xbd},{0x2,0x1},{0x0,0xea},{0x0,0xf9},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x9f},{0x0,0xdc},{0x2,0x1},{0x0,0xcd},{0x0,0xeb},{0x4,0x1},{0x2,0x1},{0x0,0xbe},{0x0,0xfa},{0x2,0x1},{0x0,0xaf},{0x0,0xdd},{0xe,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xec},{0x0,0xce},{0x0,0xfb},{0x4,0x1},{0x2,0x1},{0x0,0xbf},{0x0,0xed},{0x2,0x1},{0x0,0xde},{0x0,0xfc},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xcf},{0x0,0xfd},{0x0,0xee},{0x4,0x1},{0x2,0x1},{0x0,0xdf},{0x0,0xfe},{0x2,0x1},{0x0,0xef},{0x0,0xff}};
    5b79:	8d 85 86 f2 ff ff    	lea    -0xd7a(%ebp),%eax
    5b7f:	ba 00 ba 00 00       	mov    $0xba00,%edx
    5b84:	bb fe 03 00 00       	mov    $0x3fe,%ebx
    5b89:	89 c1                	mov    %eax,%ecx
    5b8b:	83 e1 02             	and    $0x2,%ecx
    5b8e:	85 c9                	test   %ecx,%ecx
    5b90:	74 0f                	je     5ba1 <read_decoder_table+0x62c>
    5b92:	0f b7 0a             	movzwl (%edx),%ecx
    5b95:	66 89 08             	mov    %cx,(%eax)
    5b98:	83 c0 02             	add    $0x2,%eax
    5b9b:	83 c2 02             	add    $0x2,%edx
    5b9e:	83 eb 02             	sub    $0x2,%ebx
    5ba1:	89 d9                	mov    %ebx,%ecx
    5ba3:	c1 e9 02             	shr    $0x2,%ecx
    5ba6:	89 c7                	mov    %eax,%edi
    5ba8:	89 d6                	mov    %edx,%esi
    5baa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    5bac:	89 f2                	mov    %esi,%edx
    5bae:	89 f8                	mov    %edi,%eax
    5bb0:	b9 00 00 00 00       	mov    $0x0,%ecx
    5bb5:	89 de                	mov    %ebx,%esi
    5bb7:	83 e6 02             	and    $0x2,%esi
    5bba:	85 f6                	test   %esi,%esi
    5bbc:	74 0b                	je     5bc9 <read_decoder_table+0x654>
    5bbe:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
    5bc2:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
    5bc6:	83 c1 02             	add    $0x2,%ecx
    5bc9:	83 e3 01             	and    $0x1,%ebx
    5bcc:	85 db                	test   %ebx,%ebx
    5bce:	74 07                	je     5bd7 <read_decoder_table+0x662>
    5bd0:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
    5bd4:	88 14 08             	mov    %dl,(%eax,%ecx,1)

	unsigned char h16[511][2] = {{0x2,0x1},{0x0,0x0},{0x6,0x1},{0x2,0x1},{0x0,0x10},{0x2,0x1},{0x0,0x1},{0x0,0x11},{0x2a,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x2},{0x2,0x1},{0x0,0x21},{0x0,0x12},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x22},{0x2,0x1},{0x0,0x30},{0x0,0x3},{0x2,0x1},{0x0,0x31},{0x0,0x13},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x32},{0x0,0x23},{0x4,0x1},{0x2,0x1},{0x0,0x40},{0x0,0x4},{0x0,0x41},{0x6,0x1},{0x2,0x1},{0x0,0x14},{0x2,0x1},{0x0,0x33},{0x0,0x42},{0x4,0x1},{0x2,0x1},{0x0,0x24},{0x0,0x50},{0x2,0x1},{0x0,0x43},{0x0,0x34},{0x8a,0x1},{0x28,0x1},{0x10,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x5},{0x0,0x15},{0x0,0x51},{0x4,0x1},{0x2,0x1},{0x0,0x52},{0x0,0x25},{0x4,0x1},{0x2,0x1},{0x0,0x44},{0x0,0x35},{0x0,0x53},{0xa,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x60},{0x0,0x6},{0x0,0x61},{0x2,0x1},{0x0,0x16},{0x0,0x62},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x26},{0x0,0x54},{0x2,0x1},{0x0,0x45},{0x0,0x63},{0x4,0x1},{0x2,0x1},{0x0,0x36},{0x0,0x70},{0x0,0x71},{0x28,0x1},{0x12,0x1},{0x8,0x1},{0x2,0x1},{0x0,0x17},{0x2,0x1},{0x0,0x7},{0x2,0x1},{0x0,0x55},{0x0,0x64},{0x4,0x1},{0x2,0x1},{0x0,0x72},{0x0,0x27},{0x4,0x1},{0x2,0x1},{0x0,0x46},{0x0,0x65},{0x0,0x73},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x37},{0x2,0x1},{0x0,0x56},{0x0,0x8},{0x2,0x1},{0x0,0x80},{0x0,0x81},{0x6,0x1},{0x2,0x1},{0x0,0x18},{0x2,0x1},{0x0,0x74},{0x0,0x47},{0x2,0x1},{0x0,0x82},{0x2,0x1},{0x0,0x28},{0x0,0x66},{0x18,0x1},{0xe,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x83},{0x0,0x38},{0x2,0x1},{0x0,0x75},{0x0,0x84},{0x4,0x1},{0x2,0x1},{0x0,0x48},{0x0,0x90},{0x0,0x91},{0x6,0x1},{0x2,0x1},{0x0,0x19},{0x2,0x1},{0x0,0x9},{0x0,0x76},{0x2,0x1},{0x0,0x92},{0x0,0x29},{0xe,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x85},{0x0,0x58},{0x2,0x1},{0x0,0x93},{0x0,0x39},{0x4,0x1},{0x2,0x1},{0x0,0xa0},{0x0,0xa},{0x0,0x1a},{0x8,0x1},{0x2,0x1},{0x0,0xa2},{0x2,0x1},{0x0,0x67},{0x2,0x1},{0x0,0x57},{0x0,0x49},{0x6,0x1},{0x2,0x1},{0x0,0x94},{0x2,0x1},{0x0,0x77},{0x0,0x86},{0x2,0x1},{0x0,0xa1},{0x2,0x1},{0x0,0x68},{0x0,0x95},{0xdc,0x1},{0x7e,0x1},{0x32,0x1},{0x1a,0x1},{0xc,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x2a},{0x2,0x1},{0x0,0x59},{0x0,0x3a},{0x2,0x1},{0x0,0xa3},{0x2,0x1},{0x0,0x87},{0x0,0x78},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xa4},{0x0,0x4a},{0x2,0x1},{0x0,0x96},{0x0,0x69},{0x4,0x1},{0x2,0x1},{0x0,0xb0},{0x0,0xb},{0x0,0xb1},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x1b},{0x0,0xb2},{0x2,0x1},{0x0,0x2b},{0x2,0x1},{0x0,0xa5},{0x0,0x5a},{0x6,0x1},{0x2,0x1},{0x0,0xb3},{0x2,0x1},{0x0,0xa6},{0x0,0x6a},{0x4,0x1},{0x2,0x1},{0x0,0xb4},{0x0,0x4b},{0x2,0x1},{0x0,0xc},{0x0,0xc1},{0x1e,0x1},{0xe,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xb5},{0x0,0xc2},{0x0,0x2c},{0x4,0x1},{0x2,0x1},{0x0,0xa7},{0x0,0xc3},{0x2,0x1},{0x0,0x6b},{0x0,0xc4},{0x8,0x1},{0x2,0x1},{0x0,0x1d},{0x4,0x1},{0x2,0x1},{0x0,0x88},{0x0,0x97},{0x0,0x3b},{0x4,0x1},{0x2,0x1},{0x0,0xd1},{0x0,0xd2},{0x2,0x1},{0x0,0x2d},{0x0,0xd3},{0x12,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x1e},{0x0,0x2e},{0x0,0xe2},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x79},{0x0,0x98},{0x0,0xc0},{0x2,0x1},{0x0,0x1c},{0x2,0x1},{0x0,0x89},{0x0,0x5b},{0xe,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x3c},{0x2,0x1},{0x0,0x7a},{0x0,0xb6},{0x4,0x1},{0x2,0x1},{0x0,0x4c},{0x0,0x99},{0x2,0x1},{0x0,0xa8},{0x0,0x8a},{0x6,0x1},{0x2,0x1},{0x0,0xd},{0x2,0x1},{0x0,0xc5},{0x0,0x5c},{0x4,0x1},{0x2,0x1},{0x0,0x3d},{0x0,0xc6},{0x2,0x1},{0x0,0x6c},{0x0,0x9a},{0x58,0x1},{0x56,0x1},{0x24,0x1},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x8b},{0x0,0x4d},{0x2,0x1},{0x0,0xc7},{0x0,0x7c},{0x4,0x1},{0x2,0x1},{0x0,0xd5},{0x0,0x5d},{0x2,0x1},{0x0,0xe0},{0x0,0xe},{0x8,0x1},{0x2,0x1},{0x0,0xe3},{0x4,0x1},{0x2,0x1},{0x0,0xd0},{0x0,0xb7},{0x0,0x7b},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xa9},{0x0,0xb8},{0x0,0xd4},{0x2,0x1},{0x0,0xe1},{0x2,0x1},{0x0,0xaa},{0x0,0xb9},{0x18,0x1},{0xa,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x9b},{0x0,0xd6},{0x0,0x6d},{0x2,0x1},{0x0,0x3e},{0x0,0xc8},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x8c},{0x0,0xe4},{0x0,0x4e},{0x4,0x1},{0x2,0x1},{0x0,0xd7},{0x0,0xe5},{0x2,0x1},{0x0,0xba},{0x0,0xab},{0xc,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x9c},{0x0,0xe6},{0x4,0x1},{0x2,0x1},{0x0,0x6e},{0x0,0xd8},{0x2,0x1},{0x0,0x8d},{0x0,0xbb},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xe7},{0x0,0x9d},{0x2,0x1},{0x0,0xe8},{0x0,0x8e},{0x4,0x1},{0x2,0x1},{0x0,0xcb},{0x0,0xbc},{0x0,0x9e},{0x0,0xf1},{0x2,0x1},{0x0,0x1f},{0x2,0x1},{0x0,0xf},{0x0,0x2f},{0x42,0x1},{0x38,0x1},{0x2,0x1},{0x0,0xf2},{0x34,0x1},{0x32,0x1},{0x14,0x1},{0x8,0x1},{0x2,0x1},{0x0,0xbd},{0x2,0x1},{0x0,0x5e},{0x2,0x1},{0x0,0x7d},{0x0,0xc9},{0x6,0x1},{0x2,0x1},{0x0,0xca},{0x2,0x1},{0x0,0xac},{0x0,0x7e},{0x4,0x1},{0x2,0x1},{0x0,0xda},{0x0,0xad},{0x0,0xcc},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0xae},{0x2,0x1},{0x0,0xdb},{0x0,0xdc},{0x2,0x1},{0x0,0xcd},{0x0,0xbe},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xeb},{0x0,0xed},{0x0,0xee},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xd9},{0x0,0xea},{0x0,0xe9},{0x2,0x1},{0x0,0xde},{0x4,0x1},{0x2,0x1},{0x0,0xdd},{0x0,0xec},{0x0,0xce},{0x0,0x3f},{0x0,0xf0},{0x4,0x1},{0x2,0x1},{0x0,0xf3},{0x0,0xf4},{0x2,0x1},{0x0,0x4f},{0x2,0x1},{0x0,0xf5},{0x0,0x5f},{0xa,0x1},{0x2,0x1},{0x0,0xff},{0x4,0x1},{0x2,0x1},{0x0,0xf6},{0x0,0x6f},{0x2,0x1},{0x0,0xf7},{0x0,0x7f},{0xc,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x8f},{0x2,0x1},{0x0,0xf8},{0x0,0xf9},{0x4,0x1},{0x2,0x1},{0x0,0x9f},{0x0,0xfa},{0x0,0xaf},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xfb},{0x0,0xbf},{0x2,0x1},{0x0,0xfc},{0x0,0xcf},{0x4,0x1},{0x2,0x1},{0x0,0xfd},{0x0,0xdf},{0x2,0x1},{0x0,0xfe},{0x0,0xef}};
    5bd7:	8d 95 88 ee ff ff    	lea    -0x1178(%ebp),%edx
    5bdd:	b8 00 be 00 00       	mov    $0xbe00,%eax
    5be2:	b9 ff 00 00 00       	mov    $0xff,%ecx
    5be7:	89 d7                	mov    %edx,%edi
    5be9:	89 c6                	mov    %eax,%esi
    5beb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    5bed:	89 f0                	mov    %esi,%eax
    5bef:	89 fa                	mov    %edi,%edx
    5bf1:	0f b7 08             	movzwl (%eax),%ecx
    5bf4:	66 89 0a             	mov    %cx,(%edx)
    5bf7:	83 c2 02             	add    $0x2,%edx
    5bfa:	83 c0 02             	add    $0x2,%eax

	unsigned char h24[512][2] = {{0x3c,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x0},{0x0,0x10},{0x2,0x1},{0x0,0x1},{0x0,0x11},{0xe,0x1},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x20},{0x0,0x2},{0x0,0x21},{0x2,0x1},{0x0,0x12},{0x2,0x1},{0x0,0x22},{0x2,0x1},{0x0,0x30},{0x0,0x3},{0xe,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x31},{0x0,0x13},{0x4,0x1},{0x2,0x1},{0x0,0x32},{0x0,0x23},{0x4,0x1},{0x2,0x1},{0x0,0x40},{0x0,0x4},{0x0,0x41},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x14},{0x0,0x33},{0x2,0x1},{0x0,0x42},{0x0,0x24},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x43},{0x0,0x34},{0x0,0x51},{0x6,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x50},{0x0,0x5},{0x0,0x15},{0x2,0x1},{0x0,0x52},{0x0,0x25},{0xfa,0x1},{0x62,0x1},{0x22,0x1},{0x12,0x1},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x44},{0x0,0x53},{0x2,0x1},{0x0,0x35},{0x2,0x1},{0x0,0x60},{0x0,0x6},{0x4,0x1},{0x2,0x1},{0x0,0x61},{0x0,0x16},{0x2,0x1},{0x0,0x62},{0x0,0x26},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x54},{0x0,0x45},{0x2,0x1},{0x0,0x63},{0x0,0x36},{0x4,0x1},{0x2,0x1},{0x0,0x71},{0x0,0x55},{0x2,0x1},{0x0,0x64},{0x0,0x46},{0x20,0x1},{0xe,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x72},{0x2,0x1},{0x0,0x27},{0x0,0x37},{0x2,0x1},{0x0,0x73},{0x4,0x1},{0x2,0x1},{0x0,0x70},{0x0,0x7},{0x0,0x17},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x65},{0x0,0x56},{0x4,0x1},{0x2,0x1},{0x0,0x80},{0x0,0x8},{0x0,0x81},{0x4,0x1},{0x2,0x1},{0x0,0x74},{0x0,0x47},{0x2,0x1},{0x0,0x18},{0x0,0x82},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x28},{0x0,0x66},{0x2,0x1},{0x0,0x83},{0x0,0x38},{0x4,0x1},{0x2,0x1},{0x0,0x75},{0x0,0x57},{0x2,0x1},{0x0,0x84},{0x0,0x48},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x91},{0x0,0x19},{0x2,0x1},{0x0,0x92},{0x0,0x76},{0x4,0x1},{0x2,0x1},{0x0,0x67},{0x0,0x29},{0x2,0x1},{0x0,0x85},{0x0,0x58},{0x5c,0x1},{0x22,0x1},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x93},{0x0,0x39},{0x2,0x1},{0x0,0x94},{0x0,0x49},{0x4,0x1},{0x2,0x1},{0x0,0x77},{0x0,0x86},{0x2,0x1},{0x0,0x68},{0x0,0xa1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xa2},{0x0,0x2a},{0x2,0x1},{0x0,0x95},{0x0,0x59},{0x4,0x1},{0x2,0x1},{0x0,0xa3},{0x0,0x3a},{0x2,0x1},{0x0,0x87},{0x2,0x1},{0x0,0x78},{0x0,0x4a},{0x16,0x1},{0xc,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xa4},{0x0,0x96},{0x4,0x1},{0x2,0x1},{0x0,0x69},{0x0,0xb1},{0x2,0x1},{0x0,0x1b},{0x0,0xa5},{0x6,0x1},{0x2,0x1},{0x0,0xb2},{0x2,0x1},{0x0,0x5a},{0x0,0x2b},{0x2,0x1},{0x0,0x88},{0x0,0xb3},{0x10,0x1},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x90},{0x2,0x1},{0x0,0x9},{0x0,0xa0},{0x2,0x1},{0x0,0x97},{0x0,0x79},{0x4,0x1},{0x2,0x1},{0x0,0xa6},{0x0,0x6a},{0x0,0xb4},{0xc,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x1a},{0x2,0x1},{0x0,0xa},{0x0,0xb0},{0x2,0x1},{0x0,0x3b},{0x2,0x1},{0x0,0xb},{0x0,0xc0},{0x4,0x1},{0x2,0x1},{0x0,0x4b},{0x0,0xc1},{0x2,0x1},{0x0,0x98},{0x0,0x89},{0x43,0x1},{0x22,0x1},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x1c},{0x0,0xb5},{0x2,0x1},{0x0,0x5b},{0x0,0xc2},{0x4,0x1},{0x2,0x1},{0x0,0x2c},{0x0,0xa7},{0x2,0x1},{0x0,0x7a},{0x0,0xc3},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x3c},{0x2,0x1},{0x0,0xc},{0x0,0xd0},{0x2,0x1},{0x0,0xb6},{0x0,0x6b},{0x4,0x1},{0x2,0x1},{0x0,0xc4},{0x0,0x4c},{0x2,0x1},{0x0,0x99},{0x0,0xa8},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x8a},{0x0,0xc5},{0x2,0x1},{0x0,0x5c},{0x0,0xd1},{0x4,0x1},{0x2,0x1},{0x0,0xb7},{0x0,0x7b},{0x2,0x1},{0x0,0x1d},{0x0,0xd2},{0x9,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x2d},{0x0,0xd3},{0x2,0x1},{0x0,0x3d},{0x0,0xc6},{0x55,0xfa},{0x4,0x1},{0x2,0x1},{0x0,0x6c},{0x0,0xa9},{0x2,0x1},{0x0,0x9a},{0x0,0xd4},{0x20,0x1},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xb8},{0x0,0x8b},{0x2,0x1},{0x0,0x4d},{0x0,0xc7},{0x4,0x1},{0x2,0x1},{0x0,0x7c},{0x0,0xd5},{0x2,0x1},{0x0,0x5d},{0x0,0xe1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x1e},{0x0,0xe2},{0x2,0x1},{0x0,0xaa},{0x0,0xb9},{0x4,0x1},{0x2,0x1},{0x0,0x9b},{0x0,0xe3},{0x2,0x1},{0x0,0xd6},{0x0,0x6d},{0x14,0x1},{0xa,0x1},{0x6,0x1},{0x2,0x1},{0x0,0x3e},{0x2,0x1},{0x0,0x2e},{0x0,0x4e},{0x2,0x1},{0x0,0xc8},{0x0,0x8c},{0x4,0x1},{0x2,0x1},{0x0,0xe4},{0x0,0xd7},{0x4,0x1},{0x2,0x1},{0x0,0x7d},{0x0,0xab},{0x0,0xe5},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xba},{0x0,0x5e},{0x2,0x1},{0x0,0xc9},{0x2,0x1},{0x0,0x9c},{0x0,0x6e},{0x8,0x1},{0x2,0x1},{0x0,0xe6},{0x2,0x1},{0x0,0xd},{0x2,0x1},{0x0,0xe0},{0x0,0xe},{0x4,0x1},{0x2,0x1},{0x0,0xd8},{0x0,0x8d},{0x2,0x1},{0x0,0xbb},{0x0,0xca},{0x4a,0x1},{0x2,0x1},{0x0,0xff},{0x40,0x1},{0x3a,0x1},{0x20,0x1},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xac},{0x0,0xe7},{0x2,0x1},{0x0,0x7e},{0x0,0xd9},{0x4,0x1},{0x2,0x1},{0x0,0x9d},{0x0,0xe8},{0x2,0x1},{0x0,0x8e},{0x0,0xcb},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xbc},{0x0,0xda},{0x2,0x1},{0x0,0xad},{0x0,0xe9},{0x4,0x1},{0x2,0x1},{0x0,0x9e},{0x0,0xcc},{0x2,0x1},{0x0,0xdb},{0x0,0xbd},{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xea},{0x0,0xae},{0x2,0x1},{0x0,0xdc},{0x0,0xcd},{0x4,0x1},{0x2,0x1},{0x0,0xeb},{0x0,0xbe},{0x2,0x1},{0x0,0xdd},{0x0,0xec},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xce},{0x0,0xed},{0x2,0x1},{0x0,0xde},{0x0,0xee},{0x0,0xf},{0x4,0x1},{0x2,0x1},{0x0,0xf0},{0x0,0x1f},{0x0,0xf1},{0x4,0x1},{0x2,0x1},{0x0,0xf2},{0x0,0x2f},{0x2,0x1},{0x0,0xf3},{0x0,0x3f},{0x12,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xf4},{0x0,0x4f},{0x2,0x1},{0x0,0xf5},{0x0,0x5f},{0x4,0x1},{0x2,0x1},{0x0,0xf6},{0x0,0x6f},{0x2,0x1},{0x0,0xf7},{0x2,0x1},{0x0,0x7f},{0x0,0x8f},{0xa,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xf8},{0x0,0xf9},{0x4,0x1},{0x2,0x1},{0x0,0x9f},{0x0,0xaf},{0x0,0xfa},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xfb},{0x0,0xbf},{0x2,0x1},{0x0,0xfc},{0x0,0xcf},{0x4,0x1},{0x2,0x1},{0x0,0xfd},{0x0,0xdf},{0x2,0x1},{0x0,0xfe},{0x0,0xef}};
    5bfd:	8d 95 88 ea ff ff    	lea    -0x1578(%ebp),%edx
    5c03:	bb 00 c2 00 00       	mov    $0xc200,%ebx
    5c08:	b8 00 01 00 00       	mov    $0x100,%eax
    5c0d:	89 d7                	mov    %edx,%edi
    5c0f:	89 de                	mov    %ebx,%esi
    5c11:	89 c1                	mov    %eax,%ecx
    5c13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	unsigned char hA[31][2] = {{0x2,0x1},{0x0,0x0},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x8},{0x0,0x4},{0x2,0x1},{0x0,0x1},{0x0,0x2},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0xc},{0x0,0xa},{0x2,0x1},{0x0,0x3},{0x0,0x6},{0x6,0x1},{0x2,0x1},{0x0,0x9},{0x2,0x1},{0x0,0x5},{0x0,0x7},{0x4,0x1},{0x2,0x1},{0x0,0xe},{0x0,0xd},{0x2,0x1},{0x0,0xf},{0x0,0xb}};
    5c15:	c6 85 4a ea ff ff 02 	movb   $0x2,-0x15b6(%ebp)
    5c1c:	c6 85 4b ea ff ff 01 	movb   $0x1,-0x15b5(%ebp)
    5c23:	c6 85 4c ea ff ff 00 	movb   $0x0,-0x15b4(%ebp)
    5c2a:	c6 85 4d ea ff ff 00 	movb   $0x0,-0x15b3(%ebp)
    5c31:	c6 85 4e ea ff ff 08 	movb   $0x8,-0x15b2(%ebp)
    5c38:	c6 85 4f ea ff ff 01 	movb   $0x1,-0x15b1(%ebp)
    5c3f:	c6 85 50 ea ff ff 04 	movb   $0x4,-0x15b0(%ebp)
    5c46:	c6 85 51 ea ff ff 01 	movb   $0x1,-0x15af(%ebp)
    5c4d:	c6 85 52 ea ff ff 02 	movb   $0x2,-0x15ae(%ebp)
    5c54:	c6 85 53 ea ff ff 01 	movb   $0x1,-0x15ad(%ebp)
    5c5b:	c6 85 54 ea ff ff 00 	movb   $0x0,-0x15ac(%ebp)
    5c62:	c6 85 55 ea ff ff 08 	movb   $0x8,-0x15ab(%ebp)
    5c69:	c6 85 56 ea ff ff 00 	movb   $0x0,-0x15aa(%ebp)
    5c70:	c6 85 57 ea ff ff 04 	movb   $0x4,-0x15a9(%ebp)
    5c77:	c6 85 58 ea ff ff 02 	movb   $0x2,-0x15a8(%ebp)
    5c7e:	c6 85 59 ea ff ff 01 	movb   $0x1,-0x15a7(%ebp)
    5c85:	c6 85 5a ea ff ff 00 	movb   $0x0,-0x15a6(%ebp)
    5c8c:	c6 85 5b ea ff ff 01 	movb   $0x1,-0x15a5(%ebp)
    5c93:	c6 85 5c ea ff ff 00 	movb   $0x0,-0x15a4(%ebp)
    5c9a:	c6 85 5d ea ff ff 02 	movb   $0x2,-0x15a3(%ebp)
    5ca1:	c6 85 5e ea ff ff 08 	movb   $0x8,-0x15a2(%ebp)
    5ca8:	c6 85 5f ea ff ff 01 	movb   $0x1,-0x15a1(%ebp)
    5caf:	c6 85 60 ea ff ff 04 	movb   $0x4,-0x15a0(%ebp)
    5cb6:	c6 85 61 ea ff ff 01 	movb   $0x1,-0x159f(%ebp)
    5cbd:	c6 85 62 ea ff ff 02 	movb   $0x2,-0x159e(%ebp)
    5cc4:	c6 85 63 ea ff ff 01 	movb   $0x1,-0x159d(%ebp)
    5ccb:	c6 85 64 ea ff ff 00 	movb   $0x0,-0x159c(%ebp)
    5cd2:	c6 85 65 ea ff ff 0c 	movb   $0xc,-0x159b(%ebp)
    5cd9:	c6 85 66 ea ff ff 00 	movb   $0x0,-0x159a(%ebp)
    5ce0:	c6 85 67 ea ff ff 0a 	movb   $0xa,-0x1599(%ebp)
    5ce7:	c6 85 68 ea ff ff 02 	movb   $0x2,-0x1598(%ebp)
    5cee:	c6 85 69 ea ff ff 01 	movb   $0x1,-0x1597(%ebp)
    5cf5:	c6 85 6a ea ff ff 00 	movb   $0x0,-0x1596(%ebp)
    5cfc:	c6 85 6b ea ff ff 03 	movb   $0x3,-0x1595(%ebp)
    5d03:	c6 85 6c ea ff ff 00 	movb   $0x0,-0x1594(%ebp)
    5d0a:	c6 85 6d ea ff ff 06 	movb   $0x6,-0x1593(%ebp)
    5d11:	c6 85 6e ea ff ff 06 	movb   $0x6,-0x1592(%ebp)
    5d18:	c6 85 6f ea ff ff 01 	movb   $0x1,-0x1591(%ebp)
    5d1f:	c6 85 70 ea ff ff 02 	movb   $0x2,-0x1590(%ebp)
    5d26:	c6 85 71 ea ff ff 01 	movb   $0x1,-0x158f(%ebp)
    5d2d:	c6 85 72 ea ff ff 00 	movb   $0x0,-0x158e(%ebp)
    5d34:	c6 85 73 ea ff ff 09 	movb   $0x9,-0x158d(%ebp)
    5d3b:	c6 85 74 ea ff ff 02 	movb   $0x2,-0x158c(%ebp)
    5d42:	c6 85 75 ea ff ff 01 	movb   $0x1,-0x158b(%ebp)
    5d49:	c6 85 76 ea ff ff 00 	movb   $0x0,-0x158a(%ebp)
    5d50:	c6 85 77 ea ff ff 05 	movb   $0x5,-0x1589(%ebp)
    5d57:	c6 85 78 ea ff ff 00 	movb   $0x0,-0x1588(%ebp)
    5d5e:	c6 85 79 ea ff ff 07 	movb   $0x7,-0x1587(%ebp)
    5d65:	c6 85 7a ea ff ff 04 	movb   $0x4,-0x1586(%ebp)
    5d6c:	c6 85 7b ea ff ff 01 	movb   $0x1,-0x1585(%ebp)
    5d73:	c6 85 7c ea ff ff 02 	movb   $0x2,-0x1584(%ebp)
    5d7a:	c6 85 7d ea ff ff 01 	movb   $0x1,-0x1583(%ebp)
    5d81:	c6 85 7e ea ff ff 00 	movb   $0x0,-0x1582(%ebp)
    5d88:	c6 85 7f ea ff ff 0e 	movb   $0xe,-0x1581(%ebp)
    5d8f:	c6 85 80 ea ff ff 00 	movb   $0x0,-0x1580(%ebp)
    5d96:	c6 85 81 ea ff ff 0d 	movb   $0xd,-0x157f(%ebp)
    5d9d:	c6 85 82 ea ff ff 02 	movb   $0x2,-0x157e(%ebp)
    5da4:	c6 85 83 ea ff ff 01 	movb   $0x1,-0x157d(%ebp)
    5dab:	c6 85 84 ea ff ff 00 	movb   $0x0,-0x157c(%ebp)
    5db2:	c6 85 85 ea ff ff 0f 	movb   $0xf,-0x157b(%ebp)
    5db9:	c6 85 86 ea ff ff 00 	movb   $0x0,-0x157a(%ebp)
    5dc0:	c6 85 87 ea ff ff 0b 	movb   $0xb,-0x1579(%ebp)

	unsigned char hB[31][2] = {{0x10,0x1},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x0},{0x0,0x1},{0x2,0x1},{0x0,0x2},{0x0,0x3},{0x4,0x1},{0x2,0x1},{0x0,0x4},{0x0,0x5},{0x2,0x1},{0x0,0x6},{0x0,0x7},{0x8,0x1},{0x4,0x1},{0x2,0x1},{0x0,0x8},{0x0,0x9},{0x2,0x1},{0x0,0xa},{0x0,0xb},{0x4,0x1},{0x2,0x1},{0x0,0xc},{0x0,0xd},{0x2,0x1},{0x0,0xe},{0x0,0xf}};
    5dc7:	c6 85 0c ea ff ff 10 	movb   $0x10,-0x15f4(%ebp)
    5dce:	c6 85 0d ea ff ff 01 	movb   $0x1,-0x15f3(%ebp)
    5dd5:	c6 85 0e ea ff ff 08 	movb   $0x8,-0x15f2(%ebp)
    5ddc:	c6 85 0f ea ff ff 01 	movb   $0x1,-0x15f1(%ebp)
    5de3:	c6 85 10 ea ff ff 04 	movb   $0x4,-0x15f0(%ebp)
    5dea:	c6 85 11 ea ff ff 01 	movb   $0x1,-0x15ef(%ebp)
    5df1:	c6 85 12 ea ff ff 02 	movb   $0x2,-0x15ee(%ebp)
    5df8:	c6 85 13 ea ff ff 01 	movb   $0x1,-0x15ed(%ebp)
    5dff:	c6 85 14 ea ff ff 00 	movb   $0x0,-0x15ec(%ebp)
    5e06:	c6 85 15 ea ff ff 00 	movb   $0x0,-0x15eb(%ebp)
    5e0d:	c6 85 16 ea ff ff 00 	movb   $0x0,-0x15ea(%ebp)
    5e14:	c6 85 17 ea ff ff 01 	movb   $0x1,-0x15e9(%ebp)
    5e1b:	c6 85 18 ea ff ff 02 	movb   $0x2,-0x15e8(%ebp)
    5e22:	c6 85 19 ea ff ff 01 	movb   $0x1,-0x15e7(%ebp)
    5e29:	c6 85 1a ea ff ff 00 	movb   $0x0,-0x15e6(%ebp)
    5e30:	c6 85 1b ea ff ff 02 	movb   $0x2,-0x15e5(%ebp)
    5e37:	c6 85 1c ea ff ff 00 	movb   $0x0,-0x15e4(%ebp)
    5e3e:	c6 85 1d ea ff ff 03 	movb   $0x3,-0x15e3(%ebp)
    5e45:	c6 85 1e ea ff ff 04 	movb   $0x4,-0x15e2(%ebp)
    5e4c:	c6 85 1f ea ff ff 01 	movb   $0x1,-0x15e1(%ebp)
    5e53:	c6 85 20 ea ff ff 02 	movb   $0x2,-0x15e0(%ebp)
    5e5a:	c6 85 21 ea ff ff 01 	movb   $0x1,-0x15df(%ebp)
    5e61:	c6 85 22 ea ff ff 00 	movb   $0x0,-0x15de(%ebp)
    5e68:	c6 85 23 ea ff ff 04 	movb   $0x4,-0x15dd(%ebp)
    5e6f:	c6 85 24 ea ff ff 00 	movb   $0x0,-0x15dc(%ebp)
    5e76:	c6 85 25 ea ff ff 05 	movb   $0x5,-0x15db(%ebp)
    5e7d:	c6 85 26 ea ff ff 02 	movb   $0x2,-0x15da(%ebp)
    5e84:	c6 85 27 ea ff ff 01 	movb   $0x1,-0x15d9(%ebp)
    5e8b:	c6 85 28 ea ff ff 00 	movb   $0x0,-0x15d8(%ebp)
    5e92:	c6 85 29 ea ff ff 06 	movb   $0x6,-0x15d7(%ebp)
    5e99:	c6 85 2a ea ff ff 00 	movb   $0x0,-0x15d6(%ebp)
    5ea0:	c6 85 2b ea ff ff 07 	movb   $0x7,-0x15d5(%ebp)
    5ea7:	c6 85 2c ea ff ff 08 	movb   $0x8,-0x15d4(%ebp)
    5eae:	c6 85 2d ea ff ff 01 	movb   $0x1,-0x15d3(%ebp)
    5eb5:	c6 85 2e ea ff ff 04 	movb   $0x4,-0x15d2(%ebp)
    5ebc:	c6 85 2f ea ff ff 01 	movb   $0x1,-0x15d1(%ebp)
    5ec3:	c6 85 30 ea ff ff 02 	movb   $0x2,-0x15d0(%ebp)
    5eca:	c6 85 31 ea ff ff 01 	movb   $0x1,-0x15cf(%ebp)
    5ed1:	c6 85 32 ea ff ff 00 	movb   $0x0,-0x15ce(%ebp)
    5ed8:	c6 85 33 ea ff ff 08 	movb   $0x8,-0x15cd(%ebp)
    5edf:	c6 85 34 ea ff ff 00 	movb   $0x0,-0x15cc(%ebp)
    5ee6:	c6 85 35 ea ff ff 09 	movb   $0x9,-0x15cb(%ebp)
    5eed:	c6 85 36 ea ff ff 02 	movb   $0x2,-0x15ca(%ebp)
    5ef4:	c6 85 37 ea ff ff 01 	movb   $0x1,-0x15c9(%ebp)
    5efb:	c6 85 38 ea ff ff 00 	movb   $0x0,-0x15c8(%ebp)
    5f02:	c6 85 39 ea ff ff 0a 	movb   $0xa,-0x15c7(%ebp)
    5f09:	c6 85 3a ea ff ff 00 	movb   $0x0,-0x15c6(%ebp)
    5f10:	c6 85 3b ea ff ff 0b 	movb   $0xb,-0x15c5(%ebp)
    5f17:	c6 85 3c ea ff ff 04 	movb   $0x4,-0x15c4(%ebp)
    5f1e:	c6 85 3d ea ff ff 01 	movb   $0x1,-0x15c3(%ebp)
    5f25:	c6 85 3e ea ff ff 02 	movb   $0x2,-0x15c2(%ebp)
    5f2c:	c6 85 3f ea ff ff 01 	movb   $0x1,-0x15c1(%ebp)
    5f33:	c6 85 40 ea ff ff 00 	movb   $0x0,-0x15c0(%ebp)
    5f3a:	c6 85 41 ea ff ff 0c 	movb   $0xc,-0x15bf(%ebp)
    5f41:	c6 85 42 ea ff ff 00 	movb   $0x0,-0x15be(%ebp)
    5f48:	c6 85 43 ea ff ff 0d 	movb   $0xd,-0x15bd(%ebp)
    5f4f:	c6 85 44 ea ff ff 02 	movb   $0x2,-0x15bc(%ebp)
    5f56:	c6 85 45 ea ff ff 01 	movb   $0x1,-0x15bb(%ebp)
    5f5d:	c6 85 46 ea ff ff 00 	movb   $0x0,-0x15ba(%ebp)
    5f64:	c6 85 47 ea ff ff 0e 	movb   $0xe,-0x15b9(%ebp)
    5f6b:	c6 85 48 ea ff ff 00 	movb   $0x0,-0x15b8(%ebp)
    5f72:	c6 85 49 ea ff ff 0f 	movb   $0xf,-0x15b7(%ebp)
	
	struct huffcodetab ht[HTN] = {
    5f79:	66 c7 85 bc e4 ff ff 	movw   $0x30,-0x1b44(%ebp)
    5f80:	30 00 
    5f82:	c6 85 be e4 ff ff 00 	movb   $0x0,-0x1b42(%ebp)
    5f89:	c7 85 c0 e4 ff ff 00 	movl   $0x0,-0x1b40(%ebp)
    5f90:	00 00 00 
    5f93:	c7 85 c4 e4 ff ff 00 	movl   $0x0,-0x1b3c(%ebp)
    5f9a:	00 00 00 
    5f9d:	c7 85 c8 e4 ff ff 00 	movl   $0x0,-0x1b38(%ebp)
    5fa4:	00 00 00 
    5fa7:	c7 85 cc e4 ff ff 00 	movl   $0x0,-0x1b34(%ebp)
    5fae:	00 00 00 
    5fb1:	c7 85 d0 e4 ff ff ff 	movl   $0xffffffff,-0x1b30(%ebp)
    5fb8:	ff ff ff 
    5fbb:	c7 85 d4 e4 ff ff 00 	movl   $0x0,-0x1b2c(%ebp)
    5fc2:	00 00 00 
    5fc5:	c7 85 d8 e4 ff ff 00 	movl   $0x0,-0x1b28(%ebp)
    5fcc:	00 00 00 
    5fcf:	c7 85 dc e4 ff ff 00 	movl   $0x0,-0x1b24(%ebp)
    5fd6:	00 00 00 
    5fd9:	c7 85 e0 e4 ff ff 00 	movl   $0x0,-0x1b20(%ebp)
    5fe0:	00 00 00 
    5fe3:	66 c7 85 e4 e4 ff ff 	movw   $0x31,-0x1b1c(%ebp)
    5fea:	31 00 
    5fec:	c6 85 e6 e4 ff ff 00 	movb   $0x0,-0x1b1a(%ebp)
    5ff3:	c7 85 e8 e4 ff ff 02 	movl   $0x2,-0x1b18(%ebp)
    5ffa:	00 00 00 
    5ffd:	c7 85 ec e4 ff ff 02 	movl   $0x2,-0x1b14(%ebp)
    6004:	00 00 00 
    6007:	c7 85 f0 e4 ff ff 00 	movl   $0x0,-0x1b10(%ebp)
    600e:	00 00 00 
    6011:	c7 85 f4 e4 ff ff 00 	movl   $0x0,-0x1b0c(%ebp)
    6018:	00 00 00 
    601b:	c7 85 f8 e4 ff ff ff 	movl   $0xffffffff,-0x1b08(%ebp)
    6022:	ff ff ff 
    6025:	c7 85 fc e4 ff ff 00 	movl   $0x0,-0x1b04(%ebp)
    602c:	00 00 00 
    602f:	c7 85 00 e5 ff ff 00 	movl   $0x0,-0x1b00(%ebp)
    6036:	00 00 00 
    6039:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    603c:	89 85 04 e5 ff ff    	mov    %eax,-0x1afc(%ebp)
    6042:	c7 85 08 e5 ff ff 07 	movl   $0x7,-0x1af8(%ebp)
    6049:	00 00 00 
    604c:	66 c7 85 0c e5 ff ff 	movw   $0x32,-0x1af4(%ebp)
    6053:	32 00 
    6055:	c6 85 0e e5 ff ff 00 	movb   $0x0,-0x1af2(%ebp)
    605c:	c7 85 10 e5 ff ff 03 	movl   $0x3,-0x1af0(%ebp)
    6063:	00 00 00 
    6066:	c7 85 14 e5 ff ff 03 	movl   $0x3,-0x1aec(%ebp)
    606d:	00 00 00 
    6070:	c7 85 18 e5 ff ff 00 	movl   $0x0,-0x1ae8(%ebp)
    6077:	00 00 00 
    607a:	c7 85 1c e5 ff ff 00 	movl   $0x0,-0x1ae4(%ebp)
    6081:	00 00 00 
    6084:	c7 85 20 e5 ff ff ff 	movl   $0xffffffff,-0x1ae0(%ebp)
    608b:	ff ff ff 
    608e:	c7 85 24 e5 ff ff 00 	movl   $0x0,-0x1adc(%ebp)
    6095:	00 00 00 
    6098:	c7 85 28 e5 ff ff 00 	movl   $0x0,-0x1ad8(%ebp)
    609f:	00 00 00 
    60a2:	8d 45 c4             	lea    -0x3c(%ebp),%eax
    60a5:	89 85 2c e5 ff ff    	mov    %eax,-0x1ad4(%ebp)
    60ab:	c7 85 30 e5 ff ff 11 	movl   $0x11,-0x1ad0(%ebp)
    60b2:	00 00 00 
    60b5:	66 c7 85 34 e5 ff ff 	movw   $0x33,-0x1acc(%ebp)
    60bc:	33 00 
    60be:	c6 85 36 e5 ff ff 00 	movb   $0x0,-0x1aca(%ebp)
    60c5:	c7 85 38 e5 ff ff 03 	movl   $0x3,-0x1ac8(%ebp)
    60cc:	00 00 00 
    60cf:	c7 85 3c e5 ff ff 03 	movl   $0x3,-0x1ac4(%ebp)
    60d6:	00 00 00 
    60d9:	c7 85 40 e5 ff ff 00 	movl   $0x0,-0x1ac0(%ebp)
    60e0:	00 00 00 
    60e3:	c7 85 44 e5 ff ff 00 	movl   $0x0,-0x1abc(%ebp)
    60ea:	00 00 00 
    60ed:	c7 85 48 e5 ff ff ff 	movl   $0xffffffff,-0x1ab8(%ebp)
    60f4:	ff ff ff 
    60f7:	c7 85 4c e5 ff ff 00 	movl   $0x0,-0x1ab4(%ebp)
    60fe:	00 00 00 
    6101:	c7 85 50 e5 ff ff 00 	movl   $0x0,-0x1ab0(%ebp)
    6108:	00 00 00 
    610b:	8d 45 a2             	lea    -0x5e(%ebp),%eax
    610e:	89 85 54 e5 ff ff    	mov    %eax,-0x1aac(%ebp)
    6114:	c7 85 58 e5 ff ff 11 	movl   $0x11,-0x1aa8(%ebp)
    611b:	00 00 00 
    611e:	66 c7 85 5c e5 ff ff 	movw   $0x34,-0x1aa4(%ebp)
    6125:	34 00 
    6127:	c6 85 5e e5 ff ff 00 	movb   $0x0,-0x1aa2(%ebp)
    612e:	c7 85 60 e5 ff ff 00 	movl   $0x0,-0x1aa0(%ebp)
    6135:	00 00 00 
    6138:	c7 85 64 e5 ff ff 00 	movl   $0x0,-0x1a9c(%ebp)
    613f:	00 00 00 
    6142:	c7 85 68 e5 ff ff 00 	movl   $0x0,-0x1a98(%ebp)
    6149:	00 00 00 
    614c:	c7 85 6c e5 ff ff 00 	movl   $0x0,-0x1a94(%ebp)
    6153:	00 00 00 
    6156:	c7 85 70 e5 ff ff ff 	movl   $0xffffffff,-0x1a90(%ebp)
    615d:	ff ff ff 
    6160:	c7 85 74 e5 ff ff 00 	movl   $0x0,-0x1a8c(%ebp)
    6167:	00 00 00 
    616a:	c7 85 78 e5 ff ff 00 	movl   $0x0,-0x1a88(%ebp)
    6171:	00 00 00 
    6174:	c7 85 7c e5 ff ff 00 	movl   $0x0,-0x1a84(%ebp)
    617b:	00 00 00 
    617e:	c7 85 80 e5 ff ff 00 	movl   $0x0,-0x1a80(%ebp)
    6185:	00 00 00 
    6188:	66 c7 85 84 e5 ff ff 	movw   $0x35,-0x1a7c(%ebp)
    618f:	35 00 
    6191:	c6 85 86 e5 ff ff 00 	movb   $0x0,-0x1a7a(%ebp)
    6198:	c7 85 88 e5 ff ff 04 	movl   $0x4,-0x1a78(%ebp)
    619f:	00 00 00 
    61a2:	c7 85 8c e5 ff ff 04 	movl   $0x4,-0x1a74(%ebp)
    61a9:	00 00 00 
    61ac:	c7 85 90 e5 ff ff 00 	movl   $0x0,-0x1a70(%ebp)
    61b3:	00 00 00 
    61b6:	c7 85 94 e5 ff ff 00 	movl   $0x0,-0x1a6c(%ebp)
    61bd:	00 00 00 
    61c0:	c7 85 98 e5 ff ff ff 	movl   $0xffffffff,-0x1a68(%ebp)
    61c7:	ff ff ff 
    61ca:	c7 85 9c e5 ff ff 00 	movl   $0x0,-0x1a64(%ebp)
    61d1:	00 00 00 
    61d4:	c7 85 a0 e5 ff ff 00 	movl   $0x0,-0x1a60(%ebp)
    61db:	00 00 00 
    61de:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
    61e4:	89 85 a4 e5 ff ff    	mov    %eax,-0x1a5c(%ebp)
    61ea:	c7 85 a8 e5 ff ff 1f 	movl   $0x1f,-0x1a58(%ebp)
    61f1:	00 00 00 
    61f4:	66 c7 85 ac e5 ff ff 	movw   $0x36,-0x1a54(%ebp)
    61fb:	36 00 
    61fd:	c6 85 ae e5 ff ff 00 	movb   $0x0,-0x1a52(%ebp)
    6204:	c7 85 b0 e5 ff ff 04 	movl   $0x4,-0x1a50(%ebp)
    620b:	00 00 00 
    620e:	c7 85 b4 e5 ff ff 04 	movl   $0x4,-0x1a4c(%ebp)
    6215:	00 00 00 
    6218:	c7 85 b8 e5 ff ff 00 	movl   $0x0,-0x1a48(%ebp)
    621f:	00 00 00 
    6222:	c7 85 bc e5 ff ff 00 	movl   $0x0,-0x1a44(%ebp)
    6229:	00 00 00 
    622c:	c7 85 c0 e5 ff ff ff 	movl   $0xffffffff,-0x1a40(%ebp)
    6233:	ff ff ff 
    6236:	c7 85 c4 e5 ff ff 00 	movl   $0x0,-0x1a3c(%ebp)
    623d:	00 00 00 
    6240:	c7 85 c8 e5 ff ff 00 	movl   $0x0,-0x1a38(%ebp)
    6247:	00 00 00 
    624a:	8d 85 26 ff ff ff    	lea    -0xda(%ebp),%eax
    6250:	89 85 cc e5 ff ff    	mov    %eax,-0x1a34(%ebp)
    6256:	c7 85 d0 e5 ff ff 1f 	movl   $0x1f,-0x1a30(%ebp)
    625d:	00 00 00 
    6260:	66 c7 85 d4 e5 ff ff 	movw   $0x37,-0x1a2c(%ebp)
    6267:	37 00 
    6269:	c6 85 d6 e5 ff ff 00 	movb   $0x0,-0x1a2a(%ebp)
    6270:	c7 85 d8 e5 ff ff 06 	movl   $0x6,-0x1a28(%ebp)
    6277:	00 00 00 
    627a:	c7 85 dc e5 ff ff 06 	movl   $0x6,-0x1a24(%ebp)
    6281:	00 00 00 
    6284:	c7 85 e0 e5 ff ff 00 	movl   $0x0,-0x1a20(%ebp)
    628b:	00 00 00 
    628e:	c7 85 e4 e5 ff ff 00 	movl   $0x0,-0x1a1c(%ebp)
    6295:	00 00 00 
    6298:	c7 85 e8 e5 ff ff ff 	movl   $0xffffffff,-0x1a18(%ebp)
    629f:	ff ff ff 
    62a2:	c7 85 ec e5 ff ff 00 	movl   $0x0,-0x1a14(%ebp)
    62a9:	00 00 00 
    62ac:	c7 85 f0 e5 ff ff 00 	movl   $0x0,-0x1a10(%ebp)
    62b3:	00 00 00 
    62b6:	8d 85 98 fe ff ff    	lea    -0x168(%ebp),%eax
    62bc:	89 85 f4 e5 ff ff    	mov    %eax,-0x1a0c(%ebp)
    62c2:	c7 85 f8 e5 ff ff 47 	movl   $0x47,-0x1a08(%ebp)
    62c9:	00 00 00 
    62cc:	66 c7 85 fc e5 ff ff 	movw   $0x38,-0x1a04(%ebp)
    62d3:	38 00 
    62d5:	c6 85 fe e5 ff ff 00 	movb   $0x0,-0x1a02(%ebp)
    62dc:	c7 85 00 e6 ff ff 06 	movl   $0x6,-0x1a00(%ebp)
    62e3:	00 00 00 
    62e6:	c7 85 04 e6 ff ff 06 	movl   $0x6,-0x19fc(%ebp)
    62ed:	00 00 00 
    62f0:	c7 85 08 e6 ff ff 00 	movl   $0x0,-0x19f8(%ebp)
    62f7:	00 00 00 
    62fa:	c7 85 0c e6 ff ff 00 	movl   $0x0,-0x19f4(%ebp)
    6301:	00 00 00 
    6304:	c7 85 10 e6 ff ff ff 	movl   $0xffffffff,-0x19f0(%ebp)
    630b:	ff ff ff 
    630e:	c7 85 14 e6 ff ff 00 	movl   $0x0,-0x19ec(%ebp)
    6315:	00 00 00 
    6318:	c7 85 18 e6 ff ff 00 	movl   $0x0,-0x19e8(%ebp)
    631f:	00 00 00 
    6322:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
    6328:	89 85 1c e6 ff ff    	mov    %eax,-0x19e4(%ebp)
    632e:	c7 85 20 e6 ff ff 47 	movl   $0x47,-0x19e0(%ebp)
    6335:	00 00 00 
    6338:	66 c7 85 24 e6 ff ff 	movw   $0x39,-0x19dc(%ebp)
    633f:	39 00 
    6341:	c6 85 26 e6 ff ff 00 	movb   $0x0,-0x19da(%ebp)
    6348:	c7 85 28 e6 ff ff 06 	movl   $0x6,-0x19d8(%ebp)
    634f:	00 00 00 
    6352:	c7 85 2c e6 ff ff 06 	movl   $0x6,-0x19d4(%ebp)
    6359:	00 00 00 
    635c:	c7 85 30 e6 ff ff 00 	movl   $0x0,-0x19d0(%ebp)
    6363:	00 00 00 
    6366:	c7 85 34 e6 ff ff 00 	movl   $0x0,-0x19cc(%ebp)
    636d:	00 00 00 
    6370:	c7 85 38 e6 ff ff ff 	movl   $0xffffffff,-0x19c8(%ebp)
    6377:	ff ff ff 
    637a:	c7 85 3c e6 ff ff 00 	movl   $0x0,-0x19c4(%ebp)
    6381:	00 00 00 
    6384:	c7 85 40 e6 ff ff 00 	movl   $0x0,-0x19c0(%ebp)
    638b:	00 00 00 
    638e:	8d 85 7c fd ff ff    	lea    -0x284(%ebp),%eax
    6394:	89 85 44 e6 ff ff    	mov    %eax,-0x19bc(%ebp)
    639a:	c7 85 48 e6 ff ff 47 	movl   $0x47,-0x19b8(%ebp)
    63a1:	00 00 00 
    63a4:	66 c7 85 4c e6 ff ff 	movw   $0x3031,-0x19b4(%ebp)
    63ab:	31 30 
    63ad:	c6 85 4e e6 ff ff 00 	movb   $0x0,-0x19b2(%ebp)
    63b4:	c7 85 50 e6 ff ff 08 	movl   $0x8,-0x19b0(%ebp)
    63bb:	00 00 00 
    63be:	c7 85 54 e6 ff ff 08 	movl   $0x8,-0x19ac(%ebp)
    63c5:	00 00 00 
    63c8:	c7 85 58 e6 ff ff 00 	movl   $0x0,-0x19a8(%ebp)
    63cf:	00 00 00 
    63d2:	c7 85 5c e6 ff ff 00 	movl   $0x0,-0x19a4(%ebp)
    63d9:	00 00 00 
    63dc:	c7 85 60 e6 ff ff ff 	movl   $0xffffffff,-0x19a0(%ebp)
    63e3:	ff ff ff 
    63e6:	c7 85 64 e6 ff ff 00 	movl   $0x0,-0x199c(%ebp)
    63ed:	00 00 00 
    63f0:	c7 85 68 e6 ff ff 00 	movl   $0x0,-0x1998(%ebp)
    63f7:	00 00 00 
    63fa:	8d 85 7e fc ff ff    	lea    -0x382(%ebp),%eax
    6400:	89 85 6c e6 ff ff    	mov    %eax,-0x1994(%ebp)
    6406:	c7 85 70 e6 ff ff 7f 	movl   $0x7f,-0x1990(%ebp)
    640d:	00 00 00 
    6410:	66 c7 85 74 e6 ff ff 	movw   $0x3131,-0x198c(%ebp)
    6417:	31 31 
    6419:	c6 85 76 e6 ff ff 00 	movb   $0x0,-0x198a(%ebp)
    6420:	c7 85 78 e6 ff ff 08 	movl   $0x8,-0x1988(%ebp)
    6427:	00 00 00 
    642a:	c7 85 7c e6 ff ff 08 	movl   $0x8,-0x1984(%ebp)
    6431:	00 00 00 
    6434:	c7 85 80 e6 ff ff 00 	movl   $0x0,-0x1980(%ebp)
    643b:	00 00 00 
    643e:	c7 85 84 e6 ff ff 00 	movl   $0x0,-0x197c(%ebp)
    6445:	00 00 00 
    6448:	c7 85 88 e6 ff ff ff 	movl   $0xffffffff,-0x1978(%ebp)
    644f:	ff ff ff 
    6452:	c7 85 8c e6 ff ff 00 	movl   $0x0,-0x1974(%ebp)
    6459:	00 00 00 
    645c:	c7 85 90 e6 ff ff 00 	movl   $0x0,-0x1970(%ebp)
    6463:	00 00 00 
    6466:	8d 85 80 fb ff ff    	lea    -0x480(%ebp),%eax
    646c:	89 85 94 e6 ff ff    	mov    %eax,-0x196c(%ebp)
    6472:	c7 85 98 e6 ff ff 7f 	movl   $0x7f,-0x1968(%ebp)
    6479:	00 00 00 
    647c:	66 c7 85 9c e6 ff ff 	movw   $0x3231,-0x1964(%ebp)
    6483:	31 32 
    6485:	c6 85 9e e6 ff ff 00 	movb   $0x0,-0x1962(%ebp)
    648c:	c7 85 a0 e6 ff ff 08 	movl   $0x8,-0x1960(%ebp)
    6493:	00 00 00 
    6496:	c7 85 a4 e6 ff ff 08 	movl   $0x8,-0x195c(%ebp)
    649d:	00 00 00 
    64a0:	c7 85 a8 e6 ff ff 00 	movl   $0x0,-0x1958(%ebp)
    64a7:	00 00 00 
    64aa:	c7 85 ac e6 ff ff 00 	movl   $0x0,-0x1954(%ebp)
    64b1:	00 00 00 
    64b4:	c7 85 b0 e6 ff ff ff 	movl   $0xffffffff,-0x1950(%ebp)
    64bb:	ff ff ff 
    64be:	c7 85 b4 e6 ff ff 00 	movl   $0x0,-0x194c(%ebp)
    64c5:	00 00 00 
    64c8:	c7 85 b8 e6 ff ff 00 	movl   $0x0,-0x1948(%ebp)
    64cf:	00 00 00 
    64d2:	8d 85 82 fa ff ff    	lea    -0x57e(%ebp),%eax
    64d8:	89 85 bc e6 ff ff    	mov    %eax,-0x1944(%ebp)
    64de:	c7 85 c0 e6 ff ff 7f 	movl   $0x7f,-0x1940(%ebp)
    64e5:	00 00 00 
    64e8:	66 c7 85 c4 e6 ff ff 	movw   $0x3331,-0x193c(%ebp)
    64ef:	31 33 
    64f1:	c6 85 c6 e6 ff ff 00 	movb   $0x0,-0x193a(%ebp)
    64f8:	c7 85 c8 e6 ff ff 10 	movl   $0x10,-0x1938(%ebp)
    64ff:	00 00 00 
    6502:	c7 85 cc e6 ff ff 10 	movl   $0x10,-0x1934(%ebp)
    6509:	00 00 00 
    650c:	c7 85 d0 e6 ff ff 00 	movl   $0x0,-0x1930(%ebp)
    6513:	00 00 00 
    6516:	c7 85 d4 e6 ff ff 00 	movl   $0x0,-0x192c(%ebp)
    651d:	00 00 00 
    6520:	c7 85 d8 e6 ff ff ff 	movl   $0xffffffff,-0x1928(%ebp)
    6527:	ff ff ff 
    652a:	c7 85 dc e6 ff ff 00 	movl   $0x0,-0x1924(%ebp)
    6531:	00 00 00 
    6534:	c7 85 e0 e6 ff ff 00 	movl   $0x0,-0x1920(%ebp)
    653b:	00 00 00 
    653e:	8d 85 84 f6 ff ff    	lea    -0x97c(%ebp),%eax
    6544:	89 85 e4 e6 ff ff    	mov    %eax,-0x191c(%ebp)
    654a:	c7 85 e8 e6 ff ff ff 	movl   $0x1ff,-0x1918(%ebp)
    6551:	01 00 00 
    6554:	66 c7 85 ec e6 ff ff 	movw   $0x3431,-0x1914(%ebp)
    655b:	31 34 
    655d:	c6 85 ee e6 ff ff 00 	movb   $0x0,-0x1912(%ebp)
    6564:	c7 85 f0 e6 ff ff 00 	movl   $0x0,-0x1910(%ebp)
    656b:	00 00 00 
    656e:	c7 85 f4 e6 ff ff 00 	movl   $0x0,-0x190c(%ebp)
    6575:	00 00 00 
    6578:	c7 85 f8 e6 ff ff 00 	movl   $0x0,-0x1908(%ebp)
    657f:	00 00 00 
    6582:	c7 85 fc e6 ff ff 00 	movl   $0x0,-0x1904(%ebp)
    6589:	00 00 00 
    658c:	c7 85 00 e7 ff ff ff 	movl   $0xffffffff,-0x1900(%ebp)
    6593:	ff ff ff 
    6596:	c7 85 04 e7 ff ff 00 	movl   $0x0,-0x18fc(%ebp)
    659d:	00 00 00 
    65a0:	c7 85 08 e7 ff ff 00 	movl   $0x0,-0x18f8(%ebp)
    65a7:	00 00 00 
    65aa:	c7 85 0c e7 ff ff 00 	movl   $0x0,-0x18f4(%ebp)
    65b1:	00 00 00 
    65b4:	c7 85 10 e7 ff ff 00 	movl   $0x0,-0x18f0(%ebp)
    65bb:	00 00 00 
    65be:	66 c7 85 14 e7 ff ff 	movw   $0x3531,-0x18ec(%ebp)
    65c5:	31 35 
    65c7:	c6 85 16 e7 ff ff 00 	movb   $0x0,-0x18ea(%ebp)
    65ce:	c7 85 18 e7 ff ff 10 	movl   $0x10,-0x18e8(%ebp)
    65d5:	00 00 00 
    65d8:	c7 85 1c e7 ff ff 10 	movl   $0x10,-0x18e4(%ebp)
    65df:	00 00 00 
    65e2:	c7 85 20 e7 ff ff 00 	movl   $0x0,-0x18e0(%ebp)
    65e9:	00 00 00 
    65ec:	c7 85 24 e7 ff ff 00 	movl   $0x0,-0x18dc(%ebp)
    65f3:	00 00 00 
    65f6:	c7 85 28 e7 ff ff ff 	movl   $0xffffffff,-0x18d8(%ebp)
    65fd:	ff ff ff 
    6600:	c7 85 2c e7 ff ff 00 	movl   $0x0,-0x18d4(%ebp)
    6607:	00 00 00 
    660a:	c7 85 30 e7 ff ff 00 	movl   $0x0,-0x18d0(%ebp)
    6611:	00 00 00 
    6614:	8d 85 86 f2 ff ff    	lea    -0xd7a(%ebp),%eax
    661a:	89 85 34 e7 ff ff    	mov    %eax,-0x18cc(%ebp)
    6620:	c7 85 38 e7 ff ff ff 	movl   $0x1ff,-0x18c8(%ebp)
    6627:	01 00 00 
    662a:	66 c7 85 3c e7 ff ff 	movw   $0x3631,-0x18c4(%ebp)
    6631:	31 36 
    6633:	c6 85 3e e7 ff ff 00 	movb   $0x0,-0x18c2(%ebp)
    663a:	c7 85 40 e7 ff ff 10 	movl   $0x10,-0x18c0(%ebp)
    6641:	00 00 00 
    6644:	c7 85 44 e7 ff ff 10 	movl   $0x10,-0x18bc(%ebp)
    664b:	00 00 00 
    664e:	c7 85 48 e7 ff ff 01 	movl   $0x1,-0x18b8(%ebp)
    6655:	00 00 00 
    6658:	c7 85 4c e7 ff ff 01 	movl   $0x1,-0x18b4(%ebp)
    665f:	00 00 00 
    6662:	c7 85 50 e7 ff ff ff 	movl   $0xffffffff,-0x18b0(%ebp)
    6669:	ff ff ff 
    666c:	c7 85 54 e7 ff ff 00 	movl   $0x0,-0x18ac(%ebp)
    6673:	00 00 00 
    6676:	c7 85 58 e7 ff ff 00 	movl   $0x0,-0x18a8(%ebp)
    667d:	00 00 00 
    6680:	8d 85 88 ee ff ff    	lea    -0x1178(%ebp),%eax
    6686:	89 85 5c e7 ff ff    	mov    %eax,-0x18a4(%ebp)
    668c:	c7 85 60 e7 ff ff ff 	movl   $0x1ff,-0x18a0(%ebp)
    6693:	01 00 00 
    6696:	66 c7 85 64 e7 ff ff 	movw   $0x3731,-0x189c(%ebp)
    669d:	31 37 
    669f:	c6 85 66 e7 ff ff 00 	movb   $0x0,-0x189a(%ebp)
    66a6:	c7 85 68 e7 ff ff 10 	movl   $0x10,-0x1898(%ebp)
    66ad:	00 00 00 
    66b0:	c7 85 6c e7 ff ff 10 	movl   $0x10,-0x1894(%ebp)
    66b7:	00 00 00 
    66ba:	c7 85 70 e7 ff ff 02 	movl   $0x2,-0x1890(%ebp)
    66c1:	00 00 00 
    66c4:	c7 85 74 e7 ff ff 03 	movl   $0x3,-0x188c(%ebp)
    66cb:	00 00 00 
    66ce:	c7 85 78 e7 ff ff 10 	movl   $0x10,-0x1888(%ebp)
    66d5:	00 00 00 
    66d8:	c7 85 7c e7 ff ff 00 	movl   $0x0,-0x1884(%ebp)
    66df:	00 00 00 
    66e2:	c7 85 80 e7 ff ff 00 	movl   $0x0,-0x1880(%ebp)
    66e9:	00 00 00 
    66ec:	8d 85 88 ee ff ff    	lea    -0x1178(%ebp),%eax
    66f2:	89 85 84 e7 ff ff    	mov    %eax,-0x187c(%ebp)
    66f8:	c7 85 88 e7 ff ff ff 	movl   $0x1ff,-0x1878(%ebp)
    66ff:	01 00 00 
    6702:	66 c7 85 8c e7 ff ff 	movw   $0x3831,-0x1874(%ebp)
    6709:	31 38 
    670b:	c6 85 8e e7 ff ff 00 	movb   $0x0,-0x1872(%ebp)
    6712:	c7 85 90 e7 ff ff 10 	movl   $0x10,-0x1870(%ebp)
    6719:	00 00 00 
    671c:	c7 85 94 e7 ff ff 10 	movl   $0x10,-0x186c(%ebp)
    6723:	00 00 00 
    6726:	c7 85 98 e7 ff ff 03 	movl   $0x3,-0x1868(%ebp)
    672d:	00 00 00 
    6730:	c7 85 9c e7 ff ff 07 	movl   $0x7,-0x1864(%ebp)
    6737:	00 00 00 
    673a:	c7 85 a0 e7 ff ff 10 	movl   $0x10,-0x1860(%ebp)
    6741:	00 00 00 
    6744:	c7 85 a4 e7 ff ff 00 	movl   $0x0,-0x185c(%ebp)
    674b:	00 00 00 
    674e:	c7 85 a8 e7 ff ff 00 	movl   $0x0,-0x1858(%ebp)
    6755:	00 00 00 
    6758:	8d 85 88 ee ff ff    	lea    -0x1178(%ebp),%eax
    675e:	89 85 ac e7 ff ff    	mov    %eax,-0x1854(%ebp)
    6764:	c7 85 b0 e7 ff ff ff 	movl   $0x1ff,-0x1850(%ebp)
    676b:	01 00 00 
    676e:	66 c7 85 b4 e7 ff ff 	movw   $0x3931,-0x184c(%ebp)
    6775:	31 39 
    6777:	c6 85 b6 e7 ff ff 00 	movb   $0x0,-0x184a(%ebp)
    677e:	c7 85 b8 e7 ff ff 10 	movl   $0x10,-0x1848(%ebp)
    6785:	00 00 00 
    6788:	c7 85 bc e7 ff ff 10 	movl   $0x10,-0x1844(%ebp)
    678f:	00 00 00 
    6792:	c7 85 c0 e7 ff ff 04 	movl   $0x4,-0x1840(%ebp)
    6799:	00 00 00 
    679c:	c7 85 c4 e7 ff ff 0f 	movl   $0xf,-0x183c(%ebp)
    67a3:	00 00 00 
    67a6:	c7 85 c8 e7 ff ff 10 	movl   $0x10,-0x1838(%ebp)
    67ad:	00 00 00 
    67b0:	c7 85 cc e7 ff ff 00 	movl   $0x0,-0x1834(%ebp)
    67b7:	00 00 00 
    67ba:	c7 85 d0 e7 ff ff 00 	movl   $0x0,-0x1830(%ebp)
    67c1:	00 00 00 
    67c4:	8d 85 88 ee ff ff    	lea    -0x1178(%ebp),%eax
    67ca:	89 85 d4 e7 ff ff    	mov    %eax,-0x182c(%ebp)
    67d0:	c7 85 d8 e7 ff ff ff 	movl   $0x1ff,-0x1828(%ebp)
    67d7:	01 00 00 
    67da:	66 c7 85 dc e7 ff ff 	movw   $0x3032,-0x1824(%ebp)
    67e1:	32 30 
    67e3:	c6 85 de e7 ff ff 00 	movb   $0x0,-0x1822(%ebp)
    67ea:	c7 85 e0 e7 ff ff 10 	movl   $0x10,-0x1820(%ebp)
    67f1:	00 00 00 
    67f4:	c7 85 e4 e7 ff ff 10 	movl   $0x10,-0x181c(%ebp)
    67fb:	00 00 00 
    67fe:	c7 85 e8 e7 ff ff 06 	movl   $0x6,-0x1818(%ebp)
    6805:	00 00 00 
    6808:	c7 85 ec e7 ff ff 3f 	movl   $0x3f,-0x1814(%ebp)
    680f:	00 00 00 
    6812:	c7 85 f0 e7 ff ff 10 	movl   $0x10,-0x1810(%ebp)
    6819:	00 00 00 
    681c:	c7 85 f4 e7 ff ff 00 	movl   $0x0,-0x180c(%ebp)
    6823:	00 00 00 
    6826:	c7 85 f8 e7 ff ff 00 	movl   $0x0,-0x1808(%ebp)
    682d:	00 00 00 
    6830:	8d 85 88 ee ff ff    	lea    -0x1178(%ebp),%eax
    6836:	89 85 fc e7 ff ff    	mov    %eax,-0x1804(%ebp)
    683c:	c7 85 00 e8 ff ff ff 	movl   $0x1ff,-0x1800(%ebp)
    6843:	01 00 00 
    6846:	66 c7 85 04 e8 ff ff 	movw   $0x3132,-0x17fc(%ebp)
    684d:	32 31 
    684f:	c6 85 06 e8 ff ff 00 	movb   $0x0,-0x17fa(%ebp)
    6856:	c7 85 08 e8 ff ff 10 	movl   $0x10,-0x17f8(%ebp)
    685d:	00 00 00 
    6860:	c7 85 0c e8 ff ff 10 	movl   $0x10,-0x17f4(%ebp)
    6867:	00 00 00 
    686a:	c7 85 10 e8 ff ff 08 	movl   $0x8,-0x17f0(%ebp)
    6871:	00 00 00 
    6874:	c7 85 14 e8 ff ff ff 	movl   $0xff,-0x17ec(%ebp)
    687b:	00 00 00 
    687e:	c7 85 18 e8 ff ff 10 	movl   $0x10,-0x17e8(%ebp)
    6885:	00 00 00 
    6888:	c7 85 1c e8 ff ff 00 	movl   $0x0,-0x17e4(%ebp)
    688f:	00 00 00 
    6892:	c7 85 20 e8 ff ff 00 	movl   $0x0,-0x17e0(%ebp)
    6899:	00 00 00 
    689c:	8d 85 88 ee ff ff    	lea    -0x1178(%ebp),%eax
    68a2:	89 85 24 e8 ff ff    	mov    %eax,-0x17dc(%ebp)
    68a8:	c7 85 28 e8 ff ff ff 	movl   $0x1ff,-0x17d8(%ebp)
    68af:	01 00 00 
    68b2:	66 c7 85 2c e8 ff ff 	movw   $0x3232,-0x17d4(%ebp)
    68b9:	32 32 
    68bb:	c6 85 2e e8 ff ff 00 	movb   $0x0,-0x17d2(%ebp)
    68c2:	c7 85 30 e8 ff ff 10 	movl   $0x10,-0x17d0(%ebp)
    68c9:	00 00 00 
    68cc:	c7 85 34 e8 ff ff 10 	movl   $0x10,-0x17cc(%ebp)
    68d3:	00 00 00 
    68d6:	c7 85 38 e8 ff ff 0a 	movl   $0xa,-0x17c8(%ebp)
    68dd:	00 00 00 
    68e0:	c7 85 3c e8 ff ff ff 	movl   $0x3ff,-0x17c4(%ebp)
    68e7:	03 00 00 
    68ea:	c7 85 40 e8 ff ff 10 	movl   $0x10,-0x17c0(%ebp)
    68f1:	00 00 00 
    68f4:	c7 85 44 e8 ff ff 00 	movl   $0x0,-0x17bc(%ebp)
    68fb:	00 00 00 
    68fe:	c7 85 48 e8 ff ff 00 	movl   $0x0,-0x17b8(%ebp)
    6905:	00 00 00 
    6908:	8d 85 88 ee ff ff    	lea    -0x1178(%ebp),%eax
    690e:	89 85 4c e8 ff ff    	mov    %eax,-0x17b4(%ebp)
    6914:	c7 85 50 e8 ff ff ff 	movl   $0x1ff,-0x17b0(%ebp)
    691b:	01 00 00 
    691e:	66 c7 85 54 e8 ff ff 	movw   $0x3332,-0x17ac(%ebp)
    6925:	32 33 
    6927:	c6 85 56 e8 ff ff 00 	movb   $0x0,-0x17aa(%ebp)
    692e:	c7 85 58 e8 ff ff 10 	movl   $0x10,-0x17a8(%ebp)
    6935:	00 00 00 
    6938:	c7 85 5c e8 ff ff 10 	movl   $0x10,-0x17a4(%ebp)
    693f:	00 00 00 
    6942:	c7 85 60 e8 ff ff 0d 	movl   $0xd,-0x17a0(%ebp)
    6949:	00 00 00 
    694c:	c7 85 64 e8 ff ff ff 	movl   $0x1fff,-0x179c(%ebp)
    6953:	1f 00 00 
    6956:	c7 85 68 e8 ff ff 10 	movl   $0x10,-0x1798(%ebp)
    695d:	00 00 00 
    6960:	c7 85 6c e8 ff ff 00 	movl   $0x0,-0x1794(%ebp)
    6967:	00 00 00 
    696a:	c7 85 70 e8 ff ff 00 	movl   $0x0,-0x1790(%ebp)
    6971:	00 00 00 
    6974:	8d 85 88 ee ff ff    	lea    -0x1178(%ebp),%eax
    697a:	89 85 74 e8 ff ff    	mov    %eax,-0x178c(%ebp)
    6980:	c7 85 78 e8 ff ff ff 	movl   $0x1ff,-0x1788(%ebp)
    6987:	01 00 00 
    698a:	66 c7 85 7c e8 ff ff 	movw   $0x3432,-0x1784(%ebp)
    6991:	32 34 
    6993:	c6 85 7e e8 ff ff 00 	movb   $0x0,-0x1782(%ebp)
    699a:	c7 85 80 e8 ff ff 10 	movl   $0x10,-0x1780(%ebp)
    69a1:	00 00 00 
    69a4:	c7 85 84 e8 ff ff 10 	movl   $0x10,-0x177c(%ebp)
    69ab:	00 00 00 
    69ae:	c7 85 88 e8 ff ff 04 	movl   $0x4,-0x1778(%ebp)
    69b5:	00 00 00 
    69b8:	c7 85 8c e8 ff ff 0f 	movl   $0xf,-0x1774(%ebp)
    69bf:	00 00 00 
    69c2:	c7 85 90 e8 ff ff ff 	movl   $0xffffffff,-0x1770(%ebp)
    69c9:	ff ff ff 
    69cc:	c7 85 94 e8 ff ff 00 	movl   $0x0,-0x176c(%ebp)
    69d3:	00 00 00 
    69d6:	c7 85 98 e8 ff ff 00 	movl   $0x0,-0x1768(%ebp)
    69dd:	00 00 00 
    69e0:	8d 85 88 ea ff ff    	lea    -0x1578(%ebp),%eax
    69e6:	89 85 9c e8 ff ff    	mov    %eax,-0x1764(%ebp)
    69ec:	c7 85 a0 e8 ff ff 00 	movl   $0x200,-0x1760(%ebp)
    69f3:	02 00 00 
    69f6:	66 c7 85 a4 e8 ff ff 	movw   $0x3532,-0x175c(%ebp)
    69fd:	32 35 
    69ff:	c6 85 a6 e8 ff ff 00 	movb   $0x0,-0x175a(%ebp)
    6a06:	c7 85 a8 e8 ff ff 10 	movl   $0x10,-0x1758(%ebp)
    6a0d:	00 00 00 
    6a10:	c7 85 ac e8 ff ff 10 	movl   $0x10,-0x1754(%ebp)
    6a17:	00 00 00 
    6a1a:	c7 85 b0 e8 ff ff 05 	movl   $0x5,-0x1750(%ebp)
    6a21:	00 00 00 
    6a24:	c7 85 b4 e8 ff ff 1f 	movl   $0x1f,-0x174c(%ebp)
    6a2b:	00 00 00 
    6a2e:	c7 85 b8 e8 ff ff 18 	movl   $0x18,-0x1748(%ebp)
    6a35:	00 00 00 
    6a38:	c7 85 bc e8 ff ff 00 	movl   $0x0,-0x1744(%ebp)
    6a3f:	00 00 00 
    6a42:	c7 85 c0 e8 ff ff 00 	movl   $0x0,-0x1740(%ebp)
    6a49:	00 00 00 
    6a4c:	8d 85 88 ea ff ff    	lea    -0x1578(%ebp),%eax
    6a52:	89 85 c4 e8 ff ff    	mov    %eax,-0x173c(%ebp)
    6a58:	c7 85 c8 e8 ff ff 00 	movl   $0x200,-0x1738(%ebp)
    6a5f:	02 00 00 
    6a62:	66 c7 85 cc e8 ff ff 	movw   $0x3632,-0x1734(%ebp)
    6a69:	32 36 
    6a6b:	c6 85 ce e8 ff ff 00 	movb   $0x0,-0x1732(%ebp)
    6a72:	c7 85 d0 e8 ff ff 10 	movl   $0x10,-0x1730(%ebp)
    6a79:	00 00 00 
    6a7c:	c7 85 d4 e8 ff ff 10 	movl   $0x10,-0x172c(%ebp)
    6a83:	00 00 00 
    6a86:	c7 85 d8 e8 ff ff 06 	movl   $0x6,-0x1728(%ebp)
    6a8d:	00 00 00 
    6a90:	c7 85 dc e8 ff ff 3f 	movl   $0x3f,-0x1724(%ebp)
    6a97:	00 00 00 
    6a9a:	c7 85 e0 e8 ff ff 18 	movl   $0x18,-0x1720(%ebp)
    6aa1:	00 00 00 
    6aa4:	c7 85 e4 e8 ff ff 00 	movl   $0x0,-0x171c(%ebp)
    6aab:	00 00 00 
    6aae:	c7 85 e8 e8 ff ff 00 	movl   $0x0,-0x1718(%ebp)
    6ab5:	00 00 00 
    6ab8:	8d 85 88 ea ff ff    	lea    -0x1578(%ebp),%eax
    6abe:	89 85 ec e8 ff ff    	mov    %eax,-0x1714(%ebp)
    6ac4:	c7 85 f0 e8 ff ff 00 	movl   $0x200,-0x1710(%ebp)
    6acb:	02 00 00 
    6ace:	66 c7 85 f4 e8 ff ff 	movw   $0x3732,-0x170c(%ebp)
    6ad5:	32 37 
    6ad7:	c6 85 f6 e8 ff ff 00 	movb   $0x0,-0x170a(%ebp)
    6ade:	c7 85 f8 e8 ff ff 10 	movl   $0x10,-0x1708(%ebp)
    6ae5:	00 00 00 
    6ae8:	c7 85 fc e8 ff ff 10 	movl   $0x10,-0x1704(%ebp)
    6aef:	00 00 00 
    6af2:	c7 85 00 e9 ff ff 07 	movl   $0x7,-0x1700(%ebp)
    6af9:	00 00 00 
    6afc:	c7 85 04 e9 ff ff 7f 	movl   $0x7f,-0x16fc(%ebp)
    6b03:	00 00 00 
    6b06:	c7 85 08 e9 ff ff 18 	movl   $0x18,-0x16f8(%ebp)
    6b0d:	00 00 00 
    6b10:	c7 85 0c e9 ff ff 00 	movl   $0x0,-0x16f4(%ebp)
    6b17:	00 00 00 
    6b1a:	c7 85 10 e9 ff ff 00 	movl   $0x0,-0x16f0(%ebp)
    6b21:	00 00 00 
    6b24:	8d 85 88 ea ff ff    	lea    -0x1578(%ebp),%eax
    6b2a:	89 85 14 e9 ff ff    	mov    %eax,-0x16ec(%ebp)
    6b30:	c7 85 18 e9 ff ff 00 	movl   $0x200,-0x16e8(%ebp)
    6b37:	02 00 00 
    6b3a:	66 c7 85 1c e9 ff ff 	movw   $0x3832,-0x16e4(%ebp)
    6b41:	32 38 
    6b43:	c6 85 1e e9 ff ff 00 	movb   $0x0,-0x16e2(%ebp)
    6b4a:	c7 85 20 e9 ff ff 10 	movl   $0x10,-0x16e0(%ebp)
    6b51:	00 00 00 
    6b54:	c7 85 24 e9 ff ff 10 	movl   $0x10,-0x16dc(%ebp)
    6b5b:	00 00 00 
    6b5e:	c7 85 28 e9 ff ff 08 	movl   $0x8,-0x16d8(%ebp)
    6b65:	00 00 00 
    6b68:	c7 85 2c e9 ff ff ff 	movl   $0xff,-0x16d4(%ebp)
    6b6f:	00 00 00 
    6b72:	c7 85 30 e9 ff ff 18 	movl   $0x18,-0x16d0(%ebp)
    6b79:	00 00 00 
    6b7c:	c7 85 34 e9 ff ff 00 	movl   $0x0,-0x16cc(%ebp)
    6b83:	00 00 00 
    6b86:	c7 85 38 e9 ff ff 00 	movl   $0x0,-0x16c8(%ebp)
    6b8d:	00 00 00 
    6b90:	8d 85 88 ea ff ff    	lea    -0x1578(%ebp),%eax
    6b96:	89 85 3c e9 ff ff    	mov    %eax,-0x16c4(%ebp)
    6b9c:	c7 85 40 e9 ff ff 00 	movl   $0x200,-0x16c0(%ebp)
    6ba3:	02 00 00 
    6ba6:	66 c7 85 44 e9 ff ff 	movw   $0x3932,-0x16bc(%ebp)
    6bad:	32 39 
    6baf:	c6 85 46 e9 ff ff 00 	movb   $0x0,-0x16ba(%ebp)
    6bb6:	c7 85 48 e9 ff ff 10 	movl   $0x10,-0x16b8(%ebp)
    6bbd:	00 00 00 
    6bc0:	c7 85 4c e9 ff ff 10 	movl   $0x10,-0x16b4(%ebp)
    6bc7:	00 00 00 
    6bca:	c7 85 50 e9 ff ff 09 	movl   $0x9,-0x16b0(%ebp)
    6bd1:	00 00 00 
    6bd4:	c7 85 54 e9 ff ff ff 	movl   $0x1ff,-0x16ac(%ebp)
    6bdb:	01 00 00 
    6bde:	c7 85 58 e9 ff ff 18 	movl   $0x18,-0x16a8(%ebp)
    6be5:	00 00 00 
    6be8:	c7 85 5c e9 ff ff 00 	movl   $0x0,-0x16a4(%ebp)
    6bef:	00 00 00 
    6bf2:	c7 85 60 e9 ff ff 00 	movl   $0x0,-0x16a0(%ebp)
    6bf9:	00 00 00 
    6bfc:	8d 85 88 ea ff ff    	lea    -0x1578(%ebp),%eax
    6c02:	89 85 64 e9 ff ff    	mov    %eax,-0x169c(%ebp)
    6c08:	c7 85 68 e9 ff ff 00 	movl   $0x200,-0x1698(%ebp)
    6c0f:	02 00 00 
    6c12:	66 c7 85 6c e9 ff ff 	movw   $0x3033,-0x1694(%ebp)
    6c19:	33 30 
    6c1b:	c6 85 6e e9 ff ff 00 	movb   $0x0,-0x1692(%ebp)
    6c22:	c7 85 70 e9 ff ff 10 	movl   $0x10,-0x1690(%ebp)
    6c29:	00 00 00 
    6c2c:	c7 85 74 e9 ff ff 10 	movl   $0x10,-0x168c(%ebp)
    6c33:	00 00 00 
    6c36:	c7 85 78 e9 ff ff 0b 	movl   $0xb,-0x1688(%ebp)
    6c3d:	00 00 00 
    6c40:	c7 85 7c e9 ff ff ff 	movl   $0x7ff,-0x1684(%ebp)
    6c47:	07 00 00 
    6c4a:	c7 85 80 e9 ff ff 18 	movl   $0x18,-0x1680(%ebp)
    6c51:	00 00 00 
    6c54:	c7 85 84 e9 ff ff 00 	movl   $0x0,-0x167c(%ebp)
    6c5b:	00 00 00 
    6c5e:	c7 85 88 e9 ff ff 00 	movl   $0x0,-0x1678(%ebp)
    6c65:	00 00 00 
    6c68:	8d 85 88 ea ff ff    	lea    -0x1578(%ebp),%eax
    6c6e:	89 85 8c e9 ff ff    	mov    %eax,-0x1674(%ebp)
    6c74:	c7 85 90 e9 ff ff 00 	movl   $0x200,-0x1670(%ebp)
    6c7b:	02 00 00 
    6c7e:	66 c7 85 94 e9 ff ff 	movw   $0x3133,-0x166c(%ebp)
    6c85:	33 31 
    6c87:	c6 85 96 e9 ff ff 00 	movb   $0x0,-0x166a(%ebp)
    6c8e:	c7 85 98 e9 ff ff 10 	movl   $0x10,-0x1668(%ebp)
    6c95:	00 00 00 
    6c98:	c7 85 9c e9 ff ff 10 	movl   $0x10,-0x1664(%ebp)
    6c9f:	00 00 00 
    6ca2:	c7 85 a0 e9 ff ff 0d 	movl   $0xd,-0x1660(%ebp)
    6ca9:	00 00 00 
    6cac:	c7 85 a4 e9 ff ff ff 	movl   $0x1fff,-0x165c(%ebp)
    6cb3:	1f 00 00 
    6cb6:	c7 85 a8 e9 ff ff 18 	movl   $0x18,-0x1658(%ebp)
    6cbd:	00 00 00 
    6cc0:	c7 85 ac e9 ff ff 00 	movl   $0x0,-0x1654(%ebp)
    6cc7:	00 00 00 
    6cca:	c7 85 b0 e9 ff ff 00 	movl   $0x0,-0x1650(%ebp)
    6cd1:	00 00 00 
    6cd4:	8d 85 88 ea ff ff    	lea    -0x1578(%ebp),%eax
    6cda:	89 85 b4 e9 ff ff    	mov    %eax,-0x164c(%ebp)
    6ce0:	c7 85 b8 e9 ff ff 00 	movl   $0x200,-0x1648(%ebp)
    6ce7:	02 00 00 
    6cea:	66 c7 85 bc e9 ff ff 	movw   $0x3233,-0x1644(%ebp)
    6cf1:	33 32 
    6cf3:	c6 85 be e9 ff ff 00 	movb   $0x0,-0x1642(%ebp)
    6cfa:	c7 85 c0 e9 ff ff 01 	movl   $0x1,-0x1640(%ebp)
    6d01:	00 00 00 
    6d04:	c7 85 c4 e9 ff ff 10 	movl   $0x10,-0x163c(%ebp)
    6d0b:	00 00 00 
    6d0e:	c7 85 c8 e9 ff ff 00 	movl   $0x0,-0x1638(%ebp)
    6d15:	00 00 00 
    6d18:	c7 85 cc e9 ff ff 00 	movl   $0x0,-0x1634(%ebp)
    6d1f:	00 00 00 
    6d22:	c7 85 d0 e9 ff ff ff 	movl   $0xffffffff,-0x1630(%ebp)
    6d29:	ff ff ff 
    6d2c:	c7 85 d4 e9 ff ff 00 	movl   $0x0,-0x162c(%ebp)
    6d33:	00 00 00 
    6d36:	c7 85 d8 e9 ff ff 00 	movl   $0x0,-0x1628(%ebp)
    6d3d:	00 00 00 
    6d40:	8d 85 4a ea ff ff    	lea    -0x15b6(%ebp),%eax
    6d46:	89 85 dc e9 ff ff    	mov    %eax,-0x1624(%ebp)
    6d4c:	c7 85 e0 e9 ff ff 1f 	movl   $0x1f,-0x1620(%ebp)
    6d53:	00 00 00 
    6d56:	66 c7 85 e4 e9 ff ff 	movw   $0x3333,-0x161c(%ebp)
    6d5d:	33 33 
    6d5f:	c6 85 e6 e9 ff ff 00 	movb   $0x0,-0x161a(%ebp)
    6d66:	c7 85 e8 e9 ff ff 01 	movl   $0x1,-0x1618(%ebp)
    6d6d:	00 00 00 
    6d70:	c7 85 ec e9 ff ff 10 	movl   $0x10,-0x1614(%ebp)
    6d77:	00 00 00 
    6d7a:	c7 85 f0 e9 ff ff 00 	movl   $0x0,-0x1610(%ebp)
    6d81:	00 00 00 
    6d84:	c7 85 f4 e9 ff ff 00 	movl   $0x0,-0x160c(%ebp)
    6d8b:	00 00 00 
    6d8e:	c7 85 f8 e9 ff ff ff 	movl   $0xffffffff,-0x1608(%ebp)
    6d95:	ff ff ff 
    6d98:	c7 85 fc e9 ff ff 00 	movl   $0x0,-0x1604(%ebp)
    6d9f:	00 00 00 
    6da2:	c7 85 00 ea ff ff 00 	movl   $0x0,-0x1600(%ebp)
    6da9:	00 00 00 
    6dac:	8d 85 0c ea ff ff    	lea    -0x15f4(%ebp),%eax
    6db2:	89 85 04 ea ff ff    	mov    %eax,-0x15fc(%ebp)
    6db8:	c7 85 08 ea ff ff 1f 	movl   $0x1f,-0x15f8(%ebp)
    6dbf:	00 00 00 
		{"31", 16, 16, 13, 8191, 24, 0, 0, h24, 512},
		{"32", 1, 16, 0, 0, -1, 0, 0, hA, 31},
		{"33", 1, 16, 0, 0, -1, 0, 0, hB, 31}
	};
	ht[0] = ht[0];
}
    6dc2:	81 c4 40 1b 00 00    	add    $0x1b40,%esp
    6dc8:	5b                   	pop    %ebx
    6dc9:	5e                   	pop    %esi
    6dca:	5f                   	pop    %edi
    6dcb:	5d                   	pop    %ebp
    6dcc:	c3                   	ret    

00006dcd <huffman_decoder>:


/* ����huffman����	*/
/* ע��! ��counta,countb - 4 bit ֵ �� y����, discard x */
int huffman_decoder(struct huffcodetab *h, int *x, int *y, int *v, int *w)
{  
    6dcd:	55                   	push   %ebp
    6dce:	89 e5                	mov    %esp,%ebp
    6dd0:	53                   	push   %ebx
    6dd1:	83 ec 24             	sub    $0x24,%esp
  HUFFBITS level;
  int point = 0;
    6dd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int error = 1;
    6ddb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  level     = dmask;
    6de2:	a1 d0 e8 00 00       	mov    0xe8d0,%eax
    6de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (h->val == 0) return 2;
    6dea:	8b 45 08             	mov    0x8(%ebp),%eax
    6ded:	8b 40 20             	mov    0x20(%eax),%eax
    6df0:	85 c0                	test   %eax,%eax
    6df2:	75 0a                	jne    6dfe <huffman_decoder+0x31>
    6df4:	b8 02 00 00 00       	mov    $0x2,%eax
    6df9:	e9 0d 03 00 00       	jmp    710b <huffman_decoder+0x33e>

  /* table 0 ����Ҫ bits */
  if ( h->treelen == 0)
    6dfe:	8b 45 08             	mov    0x8(%ebp),%eax
    6e01:	8b 40 24             	mov    0x24(%eax),%eax
    6e04:	85 c0                	test   %eax,%eax
    6e06:	75 1d                	jne    6e25 <huffman_decoder+0x58>
  {  *x = *y = 0;
    6e08:	8b 45 10             	mov    0x10(%ebp),%eax
    6e0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    6e11:	8b 45 10             	mov    0x10(%ebp),%eax
    6e14:	8b 10                	mov    (%eax),%edx
    6e16:	8b 45 0c             	mov    0xc(%ebp),%eax
    6e19:	89 10                	mov    %edx,(%eax)
     return 0;
    6e1b:	b8 00 00 00 00       	mov    $0x0,%eax
    6e20:	e9 e6 02 00 00       	jmp    710b <huffman_decoder+0x33e>


  /* ���� Huffman table. */

  do {
    if (h->val[point][0]==0) {   /*���Ľ�β*/
    6e25:	8b 45 08             	mov    0x8(%ebp),%eax
    6e28:	8b 40 20             	mov    0x20(%eax),%eax
    6e2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    6e2e:	01 d2                	add    %edx,%edx
    6e30:	01 d0                	add    %edx,%eax
    6e32:	0f b6 00             	movzbl (%eax),%eax
    6e35:	84 c0                	test   %al,%al
    6e37:	75 46                	jne    6e7f <huffman_decoder+0xb2>
      *x = h->val[point][1] >> 4;
    6e39:	8b 45 08             	mov    0x8(%ebp),%eax
    6e3c:	8b 40 20             	mov    0x20(%eax),%eax
    6e3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    6e42:	01 d2                	add    %edx,%edx
    6e44:	01 d0                	add    %edx,%eax
    6e46:	0f b6 40 01          	movzbl 0x1(%eax),%eax
    6e4a:	c0 e8 04             	shr    $0x4,%al
    6e4d:	0f b6 d0             	movzbl %al,%edx
    6e50:	8b 45 0c             	mov    0xc(%ebp),%eax
    6e53:	89 10                	mov    %edx,(%eax)
      *y = h->val[point][1] & 0xf;
    6e55:	8b 45 08             	mov    0x8(%ebp),%eax
    6e58:	8b 40 20             	mov    0x20(%eax),%eax
    6e5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    6e5e:	01 d2                	add    %edx,%edx
    6e60:	01 d0                	add    %edx,%eax
    6e62:	0f b6 40 01          	movzbl 0x1(%eax),%eax
    6e66:	0f b6 c0             	movzbl %al,%eax
    6e69:	83 e0 0f             	and    $0xf,%eax
    6e6c:	89 c2                	mov    %eax,%edx
    6e6e:	8b 45 10             	mov    0x10(%ebp),%eax
    6e71:	89 10                	mov    %edx,(%eax)

      error = 0;
    6e73:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
      break;
    6e7a:	e9 af 00 00 00       	jmp    6f2e <huffman_decoder+0x161>
    } 
    if (hget1bit()) {
    6e7f:	e8 a7 e6 ff ff       	call   552b <hget1bit>
    6e84:	85 c0                	test   %eax,%eax
    6e86:	74 47                	je     6ecf <huffman_decoder+0x102>
      while (h->val[point][1] >= MXOFF) point += h->val[point][1]; 
    6e88:	eb 17                	jmp    6ea1 <huffman_decoder+0xd4>
    6e8a:	8b 45 08             	mov    0x8(%ebp),%eax
    6e8d:	8b 40 20             	mov    0x20(%eax),%eax
    6e90:	8b 55 f0             	mov    -0x10(%ebp),%edx
    6e93:	01 d2                	add    %edx,%edx
    6e95:	01 d0                	add    %edx,%eax
    6e97:	0f b6 40 01          	movzbl 0x1(%eax),%eax
    6e9b:	0f b6 c0             	movzbl %al,%eax
    6e9e:	01 45 f0             	add    %eax,-0x10(%ebp)
    6ea1:	8b 45 08             	mov    0x8(%ebp),%eax
    6ea4:	8b 40 20             	mov    0x20(%eax),%eax
    6ea7:	8b 55 f0             	mov    -0x10(%ebp),%edx
    6eaa:	01 d2                	add    %edx,%edx
    6eac:	01 d0                	add    %edx,%eax
    6eae:	0f b6 40 01          	movzbl 0x1(%eax),%eax
    6eb2:	3c f9                	cmp    $0xf9,%al
    6eb4:	77 d4                	ja     6e8a <huffman_decoder+0xbd>
      point += h->val[point][1];
    6eb6:	8b 45 08             	mov    0x8(%ebp),%eax
    6eb9:	8b 40 20             	mov    0x20(%eax),%eax
    6ebc:	8b 55 f0             	mov    -0x10(%ebp),%edx
    6ebf:	01 d2                	add    %edx,%edx
    6ec1:	01 d0                	add    %edx,%eax
    6ec3:	0f b6 40 01          	movzbl 0x1(%eax),%eax
    6ec7:	0f b6 c0             	movzbl %al,%eax
    6eca:	01 45 f0             	add    %eax,-0x10(%ebp)
    6ecd:	eb 42                	jmp    6f11 <huffman_decoder+0x144>
    }
    else {
      while (h->val[point][0] >= MXOFF) point += h->val[point][0]; 
    6ecf:	eb 16                	jmp    6ee7 <huffman_decoder+0x11a>
    6ed1:	8b 45 08             	mov    0x8(%ebp),%eax
    6ed4:	8b 40 20             	mov    0x20(%eax),%eax
    6ed7:	8b 55 f0             	mov    -0x10(%ebp),%edx
    6eda:	01 d2                	add    %edx,%edx
    6edc:	01 d0                	add    %edx,%eax
    6ede:	0f b6 00             	movzbl (%eax),%eax
    6ee1:	0f b6 c0             	movzbl %al,%eax
    6ee4:	01 45 f0             	add    %eax,-0x10(%ebp)
    6ee7:	8b 45 08             	mov    0x8(%ebp),%eax
    6eea:	8b 40 20             	mov    0x20(%eax),%eax
    6eed:	8b 55 f0             	mov    -0x10(%ebp),%edx
    6ef0:	01 d2                	add    %edx,%edx
    6ef2:	01 d0                	add    %edx,%eax
    6ef4:	0f b6 00             	movzbl (%eax),%eax
    6ef7:	3c f9                	cmp    $0xf9,%al
    6ef9:	77 d6                	ja     6ed1 <huffman_decoder+0x104>
      point += h->val[point][0];
    6efb:	8b 45 08             	mov    0x8(%ebp),%eax
    6efe:	8b 40 20             	mov    0x20(%eax),%eax
    6f01:	8b 55 f0             	mov    -0x10(%ebp),%edx
    6f04:	01 d2                	add    %edx,%edx
    6f06:	01 d0                	add    %edx,%eax
    6f08:	0f b6 00             	movzbl (%eax),%eax
    6f0b:	0f b6 c0             	movzbl %al,%eax
    6f0e:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    level >>= 1;
    6f11:	d1 6d f4             	shrl   -0xc(%ebp)
  } while (level  || (point < ht->treelen) );
    6f14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    6f18:	0f 85 07 ff ff ff    	jne    6e25 <huffman_decoder+0x58>
    6f1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
    6f21:	a1 24 1e 01 00       	mov    0x11e24,%eax
    6f26:	39 c2                	cmp    %eax,%edx
    6f28:	0f 82 f7 fe ff ff    	jb     6e25 <huffman_decoder+0x58>
  
  /* ������ */
  
  if (error) { /* ���� x �� y Ϊһ�м�ֵ */
    6f2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    6f32:	74 24                	je     6f58 <huffman_decoder+0x18b>
    //print(0, "Illegal Huffman code in data.\n");
    *x = ((h->xlen-1) << 1);
    6f34:	8b 45 08             	mov    0x8(%ebp),%eax
    6f37:	8b 40 04             	mov    0x4(%eax),%eax
    6f3a:	83 e8 01             	sub    $0x1,%eax
    6f3d:	01 c0                	add    %eax,%eax
    6f3f:	89 c2                	mov    %eax,%edx
    6f41:	8b 45 0c             	mov    0xc(%ebp),%eax
    6f44:	89 10                	mov    %edx,(%eax)
    *y = ((h->ylen-1) << 1);
    6f46:	8b 45 08             	mov    0x8(%ebp),%eax
    6f49:	8b 40 08             	mov    0x8(%eax),%eax
    6f4c:	83 e8 01             	sub    $0x1,%eax
    6f4f:	01 c0                	add    %eax,%eax
    6f51:	89 c2                	mov    %eax,%edx
    6f53:	8b 45 10             	mov    0x10(%ebp),%eax
    6f56:	89 10                	mov    %edx,(%eax)
  }

  /* �����źű��� */

  if (h->tablename[0] == '3'
    6f58:	8b 45 08             	mov    0x8(%ebp),%eax
    6f5b:	0f b6 00             	movzbl (%eax),%eax
    6f5e:	3c 33                	cmp    $0x33,%al
    6f60:	0f 85 ec 00 00 00    	jne    7052 <huffman_decoder+0x285>
      && (h->tablename[1] == '2' || h->tablename[1] == '3')) {
    6f66:	8b 45 08             	mov    0x8(%ebp),%eax
    6f69:	0f b6 40 01          	movzbl 0x1(%eax),%eax
    6f6d:	3c 32                	cmp    $0x32,%al
    6f6f:	74 0f                	je     6f80 <huffman_decoder+0x1b3>
    6f71:	8b 45 08             	mov    0x8(%ebp),%eax
    6f74:	0f b6 40 01          	movzbl 0x1(%eax),%eax
    6f78:	3c 33                	cmp    $0x33,%al
    6f7a:	0f 85 d2 00 00 00    	jne    7052 <huffman_decoder+0x285>
     *v = (*y>>3) & 1;
    6f80:	8b 45 10             	mov    0x10(%ebp),%eax
    6f83:	8b 00                	mov    (%eax),%eax
    6f85:	c1 f8 03             	sar    $0x3,%eax
    6f88:	83 e0 01             	and    $0x1,%eax
    6f8b:	89 c2                	mov    %eax,%edx
    6f8d:	8b 45 14             	mov    0x14(%ebp),%eax
    6f90:	89 10                	mov    %edx,(%eax)
     *w = (*y>>2) & 1;
    6f92:	8b 45 10             	mov    0x10(%ebp),%eax
    6f95:	8b 00                	mov    (%eax),%eax
    6f97:	c1 f8 02             	sar    $0x2,%eax
    6f9a:	83 e0 01             	and    $0x1,%eax
    6f9d:	89 c2                	mov    %eax,%edx
    6f9f:	8b 45 18             	mov    0x18(%ebp),%eax
    6fa2:	89 10                	mov    %edx,(%eax)
     *x = (*y>>1) & 1;
    6fa4:	8b 45 10             	mov    0x10(%ebp),%eax
    6fa7:	8b 00                	mov    (%eax),%eax
    6fa9:	d1 f8                	sar    %eax
    6fab:	83 e0 01             	and    $0x1,%eax
    6fae:	89 c2                	mov    %eax,%edx
    6fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    6fb3:	89 10                	mov    %edx,(%eax)
     *y = *y & 1;
    6fb5:	8b 45 10             	mov    0x10(%ebp),%eax
    6fb8:	8b 00                	mov    (%eax),%eax
    6fba:	83 e0 01             	and    $0x1,%eax
    6fbd:	89 c2                	mov    %eax,%edx
    6fbf:	8b 45 10             	mov    0x10(%ebp),%eax
    6fc2:	89 10                	mov    %edx,(%eax)
     /* v, w, x �� y �ڱ��������ǵߵ��ģ��������� 
         */
     
/*   {int i=*v; *v=*y; *y=i; i=*w; *w=*x; *x=i;}  MI */

     if (*v)
    6fc4:	8b 45 14             	mov    0x14(%ebp),%eax
    6fc7:	8b 00                	mov    (%eax),%eax
    6fc9:	85 c0                	test   %eax,%eax
    6fcb:	74 18                	je     6fe5 <huffman_decoder+0x218>
        if (hget1bit() == 1) *v = -*v;
    6fcd:	e8 59 e5 ff ff       	call   552b <hget1bit>
    6fd2:	83 f8 01             	cmp    $0x1,%eax
    6fd5:	75 0e                	jne    6fe5 <huffman_decoder+0x218>
    6fd7:	8b 45 14             	mov    0x14(%ebp),%eax
    6fda:	8b 00                	mov    (%eax),%eax
    6fdc:	f7 d8                	neg    %eax
    6fde:	89 c2                	mov    %eax,%edx
    6fe0:	8b 45 14             	mov    0x14(%ebp),%eax
    6fe3:	89 10                	mov    %edx,(%eax)
     if (*w)
    6fe5:	8b 45 18             	mov    0x18(%ebp),%eax
    6fe8:	8b 00                	mov    (%eax),%eax
    6fea:	85 c0                	test   %eax,%eax
    6fec:	74 18                	je     7006 <huffman_decoder+0x239>
        if (hget1bit() == 1) *w = -*w;
    6fee:	e8 38 e5 ff ff       	call   552b <hget1bit>
    6ff3:	83 f8 01             	cmp    $0x1,%eax
    6ff6:	75 0e                	jne    7006 <huffman_decoder+0x239>
    6ff8:	8b 45 18             	mov    0x18(%ebp),%eax
    6ffb:	8b 00                	mov    (%eax),%eax
    6ffd:	f7 d8                	neg    %eax
    6fff:	89 c2                	mov    %eax,%edx
    7001:	8b 45 18             	mov    0x18(%ebp),%eax
    7004:	89 10                	mov    %edx,(%eax)
     if (*x)
    7006:	8b 45 0c             	mov    0xc(%ebp),%eax
    7009:	8b 00                	mov    (%eax),%eax
    700b:	85 c0                	test   %eax,%eax
    700d:	74 18                	je     7027 <huffman_decoder+0x25a>
        if (hget1bit() == 1) *x = -*x;
    700f:	e8 17 e5 ff ff       	call   552b <hget1bit>
    7014:	83 f8 01             	cmp    $0x1,%eax
    7017:	75 0e                	jne    7027 <huffman_decoder+0x25a>
    7019:	8b 45 0c             	mov    0xc(%ebp),%eax
    701c:	8b 00                	mov    (%eax),%eax
    701e:	f7 d8                	neg    %eax
    7020:	89 c2                	mov    %eax,%edx
    7022:	8b 45 0c             	mov    0xc(%ebp),%eax
    7025:	89 10                	mov    %edx,(%eax)
     if (*y)
    7027:	8b 45 10             	mov    0x10(%ebp),%eax
    702a:	8b 00                	mov    (%eax),%eax
    702c:	85 c0                	test   %eax,%eax
    702e:	74 1d                	je     704d <huffman_decoder+0x280>
        if (hget1bit() == 1) *y = -*y;
    7030:	e8 f6 e4 ff ff       	call   552b <hget1bit>
    7035:	83 f8 01             	cmp    $0x1,%eax
    7038:	75 13                	jne    704d <huffman_decoder+0x280>
    703a:	8b 45 10             	mov    0x10(%ebp),%eax
    703d:	8b 00                	mov    (%eax),%eax
    703f:	f7 d8                	neg    %eax
    7041:	89 c2                	mov    %eax,%edx
    7043:	8b 45 10             	mov    0x10(%ebp),%eax
    7046:	89 10                	mov    %edx,(%eax)
        if (hget1bit() == 1) *v = -*v;
     if (*w)
        if (hget1bit() == 1) *w = -*w;
     if (*x)
        if (hget1bit() == 1) *x = -*x;
     if (*y)
    7048:	e9 bb 00 00 00       	jmp    7108 <huffman_decoder+0x33b>
    704d:	e9 b6 00 00 00       	jmp    7108 <huffman_decoder+0x33b>
  else {
  
      /* �ڲ��Ա�������x �� y�ǵߵ��� 
         ����ߵ� x �� y ʹ���Ա��������� */
    
     if (h->linbits)
    7052:	8b 45 08             	mov    0x8(%ebp),%eax
    7055:	8b 40 0c             	mov    0xc(%eax),%eax
    7058:	85 c0                	test   %eax,%eax
    705a:	74 30                	je     708c <huffman_decoder+0x2bf>
       if ((h->xlen-1) == *x) 
    705c:	8b 45 08             	mov    0x8(%ebp),%eax
    705f:	8b 40 04             	mov    0x4(%eax),%eax
    7062:	8d 50 ff             	lea    -0x1(%eax),%edx
    7065:	8b 45 0c             	mov    0xc(%ebp),%eax
    7068:	8b 00                	mov    (%eax),%eax
    706a:	39 c2                	cmp    %eax,%edx
    706c:	75 1e                	jne    708c <huffman_decoder+0x2bf>
         *x += hgetbits(h->linbits);
    706e:	8b 45 0c             	mov    0xc(%ebp),%eax
    7071:	8b 00                	mov    (%eax),%eax
    7073:	89 c3                	mov    %eax,%ebx
    7075:	8b 45 08             	mov    0x8(%ebp),%eax
    7078:	8b 40 0c             	mov    0xc(%eax),%eax
    707b:	89 04 24             	mov    %eax,(%esp)
    707e:	e8 8d e4 ff ff       	call   5510 <hgetbits>
    7083:	01 d8                	add    %ebx,%eax
    7085:	89 c2                	mov    %eax,%edx
    7087:	8b 45 0c             	mov    0xc(%ebp),%eax
    708a:	89 10                	mov    %edx,(%eax)
     if (*x)
    708c:	8b 45 0c             	mov    0xc(%ebp),%eax
    708f:	8b 00                	mov    (%eax),%eax
    7091:	85 c0                	test   %eax,%eax
    7093:	74 18                	je     70ad <huffman_decoder+0x2e0>
        if (hget1bit() == 1) *x = -*x;
    7095:	e8 91 e4 ff ff       	call   552b <hget1bit>
    709a:	83 f8 01             	cmp    $0x1,%eax
    709d:	75 0e                	jne    70ad <huffman_decoder+0x2e0>
    709f:	8b 45 0c             	mov    0xc(%ebp),%eax
    70a2:	8b 00                	mov    (%eax),%eax
    70a4:	f7 d8                	neg    %eax
    70a6:	89 c2                	mov    %eax,%edx
    70a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    70ab:	89 10                	mov    %edx,(%eax)
     if (h->linbits)	  
    70ad:	8b 45 08             	mov    0x8(%ebp),%eax
    70b0:	8b 40 0c             	mov    0xc(%eax),%eax
    70b3:	85 c0                	test   %eax,%eax
    70b5:	74 30                	je     70e7 <huffman_decoder+0x31a>
       if ((h->ylen-1) == *y)
    70b7:	8b 45 08             	mov    0x8(%ebp),%eax
    70ba:	8b 40 08             	mov    0x8(%eax),%eax
    70bd:	8d 50 ff             	lea    -0x1(%eax),%edx
    70c0:	8b 45 10             	mov    0x10(%ebp),%eax
    70c3:	8b 00                	mov    (%eax),%eax
    70c5:	39 c2                	cmp    %eax,%edx
    70c7:	75 1e                	jne    70e7 <huffman_decoder+0x31a>
         *y += hgetbits(h->linbits);
    70c9:	8b 45 10             	mov    0x10(%ebp),%eax
    70cc:	8b 00                	mov    (%eax),%eax
    70ce:	89 c3                	mov    %eax,%ebx
    70d0:	8b 45 08             	mov    0x8(%ebp),%eax
    70d3:	8b 40 0c             	mov    0xc(%eax),%eax
    70d6:	89 04 24             	mov    %eax,(%esp)
    70d9:	e8 32 e4 ff ff       	call   5510 <hgetbits>
    70de:	01 d8                	add    %ebx,%eax
    70e0:	89 c2                	mov    %eax,%edx
    70e2:	8b 45 10             	mov    0x10(%ebp),%eax
    70e5:	89 10                	mov    %edx,(%eax)
     if (*y)
    70e7:	8b 45 10             	mov    0x10(%ebp),%eax
    70ea:	8b 00                	mov    (%eax),%eax
    70ec:	85 c0                	test   %eax,%eax
    70ee:	74 18                	je     7108 <huffman_decoder+0x33b>
        if (hget1bit() == 1) *y = -*y;
    70f0:	e8 36 e4 ff ff       	call   552b <hget1bit>
    70f5:	83 f8 01             	cmp    $0x1,%eax
    70f8:	75 0e                	jne    7108 <huffman_decoder+0x33b>
    70fa:	8b 45 10             	mov    0x10(%ebp),%eax
    70fd:	8b 00                	mov    (%eax),%eax
    70ff:	f7 d8                	neg    %eax
    7101:	89 c2                	mov    %eax,%edx
    7103:	8b 45 10             	mov    0x10(%ebp),%eax
    7106:	89 10                	mov    %edx,(%eax)
     }
	  
  return error;  
    7108:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
    710b:	83 c4 24             	add    $0x24,%esp
    710e:	5b                   	pop    %ebx
    710f:	5d                   	pop    %ebp
    7110:	c3                   	ret    

00007111 <decode_info>:
#include "common.h"
#include "decode.h"
#include "huffman.h"

void decode_info(Bit_stream_struc *bs, struct frame_params *fr_ps)
{
    7111:	55                   	push   %ebp
    7112:	89 e5                	mov    %esp,%ebp
    7114:	83 ec 28             	sub    $0x28,%esp
    layer *hdr = fr_ps->header;
    7117:	8b 45 0c             	mov    0xc(%ebp),%eax
    711a:	8b 00                	mov    (%eax),%eax
    711c:	89 45 f4             	mov    %eax,-0xc(%ebp)

    hdr->version = get1bit(bs);
    711f:	8b 45 08             	mov    0x8(%ebp),%eax
    7122:	89 04 24             	mov    %eax,(%esp)
    7125:	e8 6c df ff ff       	call   5096 <get1bit>
    712a:	89 c2                	mov    %eax,%edx
    712c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    712f:	89 10                	mov    %edx,(%eax)
    hdr->lay = 4-getbits(bs,2);
    7131:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    7138:	00 
    7139:	8b 45 08             	mov    0x8(%ebp),%eax
    713c:	89 04 24             	mov    %eax,(%esp)
    713f:	e8 64 e0 ff ff       	call   51a8 <getbits>
    7144:	ba 04 00 00 00       	mov    $0x4,%edx
    7149:	29 c2                	sub    %eax,%edx
    714b:	89 d0                	mov    %edx,%eax
    714d:	89 c2                	mov    %eax,%edx
    714f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    7152:	89 50 04             	mov    %edx,0x4(%eax)
    hdr->error_protection = !get1bit(bs); /* ���󱣻�. TRUE/FALSE */
    7155:	8b 45 08             	mov    0x8(%ebp),%eax
    7158:	89 04 24             	mov    %eax,(%esp)
    715b:	e8 36 df ff ff       	call   5096 <get1bit>
    7160:	85 c0                	test   %eax,%eax
    7162:	0f 94 c0             	sete   %al
    7165:	0f b6 d0             	movzbl %al,%edx
    7168:	8b 45 f4             	mov    -0xc(%ebp),%eax
    716b:	89 50 08             	mov    %edx,0x8(%eax)
    hdr->bitrate_index = getbits(bs,4);
    716e:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
    7175:	00 
    7176:	8b 45 08             	mov    0x8(%ebp),%eax
    7179:	89 04 24             	mov    %eax,(%esp)
    717c:	e8 27 e0 ff ff       	call   51a8 <getbits>
    7181:	89 c2                	mov    %eax,%edx
    7183:	8b 45 f4             	mov    -0xc(%ebp),%eax
    7186:	89 50 0c             	mov    %edx,0xc(%eax)
    hdr->sampling_frequency = getbits(bs,2);
    7189:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    7190:	00 
    7191:	8b 45 08             	mov    0x8(%ebp),%eax
    7194:	89 04 24             	mov    %eax,(%esp)
    7197:	e8 0c e0 ff ff       	call   51a8 <getbits>
    719c:	89 c2                	mov    %eax,%edx
    719e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    71a1:	89 50 10             	mov    %edx,0x10(%eax)
    hdr->padding = get1bit(bs);
    71a4:	8b 45 08             	mov    0x8(%ebp),%eax
    71a7:	89 04 24             	mov    %eax,(%esp)
    71aa:	e8 e7 de ff ff       	call   5096 <get1bit>
    71af:	89 c2                	mov    %eax,%edx
    71b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    71b4:	89 50 14             	mov    %edx,0x14(%eax)
    hdr->extension = get1bit(bs);
    71b7:	8b 45 08             	mov    0x8(%ebp),%eax
    71ba:	89 04 24             	mov    %eax,(%esp)
    71bd:	e8 d4 de ff ff       	call   5096 <get1bit>
    71c2:	89 c2                	mov    %eax,%edx
    71c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    71c7:	89 50 18             	mov    %edx,0x18(%eax)
    hdr->mode = getbits(bs,2);
    71ca:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    71d1:	00 
    71d2:	8b 45 08             	mov    0x8(%ebp),%eax
    71d5:	89 04 24             	mov    %eax,(%esp)
    71d8:	e8 cb df ff ff       	call   51a8 <getbits>
    71dd:	89 c2                	mov    %eax,%edx
    71df:	8b 45 f4             	mov    -0xc(%ebp),%eax
    71e2:	89 50 1c             	mov    %edx,0x1c(%eax)
    hdr->mode_ext = getbits(bs,2);
    71e5:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    71ec:	00 
    71ed:	8b 45 08             	mov    0x8(%ebp),%eax
    71f0:	89 04 24             	mov    %eax,(%esp)
    71f3:	e8 b0 df ff ff       	call   51a8 <getbits>
    71f8:	89 c2                	mov    %eax,%edx
    71fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    71fd:	89 50 20             	mov    %edx,0x20(%eax)
    hdr->copyright = get1bit(bs);
    7200:	8b 45 08             	mov    0x8(%ebp),%eax
    7203:	89 04 24             	mov    %eax,(%esp)
    7206:	e8 8b de ff ff       	call   5096 <get1bit>
    720b:	89 c2                	mov    %eax,%edx
    720d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    7210:	89 50 24             	mov    %edx,0x24(%eax)
    hdr->original = get1bit(bs);
    7213:	8b 45 08             	mov    0x8(%ebp),%eax
    7216:	89 04 24             	mov    %eax,(%esp)
    7219:	e8 78 de ff ff       	call   5096 <get1bit>
    721e:	89 c2                	mov    %eax,%edx
    7220:	8b 45 f4             	mov    -0xc(%ebp),%eax
    7223:	89 50 28             	mov    %edx,0x28(%eax)
    hdr->emphasis = getbits(bs,2);
    7226:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    722d:	00 
    722e:	8b 45 08             	mov    0x8(%ebp),%eax
    7231:	89 04 24             	mov    %eax,(%esp)
    7234:	e8 6f df ff ff       	call   51a8 <getbits>
    7239:	89 c2                	mov    %eax,%edx
    723b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    723e:	89 50 2c             	mov    %edx,0x2c(%eax)
}
    7241:	c9                   	leave  
    7242:	c3                   	ret    

00007243 <III_get_side_info>:

void III_get_side_info(Bit_stream_struc *bs, struct III_side_info_t *si, struct frame_params *fr_ps)
{
    7243:	55                   	push   %ebp
    7244:	89 e5                	mov    %esp,%ebp
    7246:	56                   	push   %esi
    7247:	53                   	push   %ebx
    7248:	83 ec 20             	sub    $0x20,%esp
	int ch, gr, i;
	int stereo = fr_ps->stereo;
    724b:	8b 45 10             	mov    0x10(%ebp),%eax
    724e:	8b 40 08             	mov    0x8(%eax),%eax
    7251:	89 45 e8             	mov    %eax,-0x18(%ebp)

	si->main_data_begin = getbits(bs, 9);
    7254:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
    725b:	00 
    725c:	8b 45 08             	mov    0x8(%ebp),%eax
    725f:	89 04 24             	mov    %eax,(%esp)
    7262:	e8 41 df ff ff       	call   51a8 <getbits>
    7267:	8b 55 0c             	mov    0xc(%ebp),%edx
    726a:	89 02                	mov    %eax,(%edx)
	if (stereo == 1)
    726c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
    7270:	75 1b                	jne    728d <III_get_side_info+0x4a>
		si->private_bits = getbits(bs,5);
    7272:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
    7279:	00 
    727a:	8b 45 08             	mov    0x8(%ebp),%eax
    727d:	89 04 24             	mov    %eax,(%esp)
    7280:	e8 23 df ff ff       	call   51a8 <getbits>
    7285:	8b 55 0c             	mov    0xc(%ebp),%edx
    7288:	89 42 04             	mov    %eax,0x4(%edx)
    728b:	eb 19                	jmp    72a6 <III_get_side_info+0x63>
	else
		si->private_bits = getbits(bs,3);
    728d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
    7294:	00 
    7295:	8b 45 08             	mov    0x8(%ebp),%eax
    7298:	89 04 24             	mov    %eax,(%esp)
    729b:	e8 08 df ff ff       	call   51a8 <getbits>
    72a0:	8b 55 0c             	mov    0xc(%ebp),%edx
    72a3:	89 42 04             	mov    %eax,0x4(%edx)

	for (ch=0; ch<stereo; ch++)
    72a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    72ad:	eb 3d                	jmp    72ec <III_get_side_info+0xa9>
		for (i=0; i<4; i++)
    72af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    72b6:	eb 2a                	jmp    72e2 <III_get_side_info+0x9f>
			si->ch[ch].scfsi[i] = get1bit(bs);
    72b8:	8b 45 08             	mov    0x8(%ebp),%eax
    72bb:	89 04 24             	mov    %eax,(%esp)
    72be:	e8 d3 dd ff ff       	call   5096 <get1bit>
    72c3:	89 c1                	mov    %eax,%ecx
    72c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    72c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    72cb:	89 d0                	mov    %edx,%eax
    72cd:	c1 e0 02             	shl    $0x2,%eax
    72d0:	01 d0                	add    %edx,%eax
    72d2:	c1 e0 03             	shl    $0x3,%eax
    72d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
    72d8:	01 d0                	add    %edx,%eax
    72da:	89 4c 83 08          	mov    %ecx,0x8(%ebx,%eax,4)
		si->private_bits = getbits(bs,5);
	else
		si->private_bits = getbits(bs,3);

	for (ch=0; ch<stereo; ch++)
		for (i=0; i<4; i++)
    72de:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    72e2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
    72e6:	7e d0                	jle    72b8 <III_get_side_info+0x75>
	if (stereo == 1)
		si->private_bits = getbits(bs,5);
	else
		si->private_bits = getbits(bs,3);

	for (ch=0; ch<stereo; ch++)
    72e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    72ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    72ef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    72f2:	7c bb                	jl     72af <III_get_side_info+0x6c>
		for (i=0; i<4; i++)
			si->ch[ch].scfsi[i] = get1bit(bs);

	for (gr=0; gr<2; gr++) {
    72f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    72fb:	e9 c5 05 00 00       	jmp    78c5 <III_get_side_info+0x682>
		for (ch=0; ch<stereo; ch++) {
    7300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    7307:	e9 a9 05 00 00       	jmp    78b5 <III_get_side_info+0x672>
			si->ch[ch].gr[gr].part2_3_length = getbits(bs, 12);
    730c:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
    7313:	00 
    7314:	8b 45 08             	mov    0x8(%ebp),%eax
    7317:	89 04 24             	mov    %eax,(%esp)
    731a:	e8 89 de ff ff       	call   51a8 <getbits>
    731f:	89 c3                	mov    %eax,%ebx
    7321:	8b 75 0c             	mov    0xc(%ebp),%esi
    7324:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7327:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    732a:	89 c2                	mov    %eax,%edx
    732c:	c1 e2 03             	shl    $0x3,%edx
    732f:	01 c2                	add    %eax,%edx
    7331:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7338:	89 c2                	mov    %eax,%edx
    733a:	89 c8                	mov    %ecx,%eax
    733c:	c1 e0 02             	shl    $0x2,%eax
    733f:	01 c8                	add    %ecx,%eax
    7341:	c1 e0 05             	shl    $0x5,%eax
    7344:	01 d0                	add    %edx,%eax
    7346:	01 f0                	add    %esi,%eax
    7348:	83 c0 18             	add    $0x18,%eax
    734b:	89 18                	mov    %ebx,(%eax)
			si->ch[ch].gr[gr].big_values = getbits(bs, 9);
    734d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
    7354:	00 
    7355:	8b 45 08             	mov    0x8(%ebp),%eax
    7358:	89 04 24             	mov    %eax,(%esp)
    735b:	e8 48 de ff ff       	call   51a8 <getbits>
    7360:	89 c3                	mov    %eax,%ebx
    7362:	8b 75 0c             	mov    0xc(%ebp),%esi
    7365:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7368:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    736b:	89 c2                	mov    %eax,%edx
    736d:	c1 e2 03             	shl    $0x3,%edx
    7370:	01 c2                	add    %eax,%edx
    7372:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7379:	89 c2                	mov    %eax,%edx
    737b:	89 c8                	mov    %ecx,%eax
    737d:	c1 e0 02             	shl    $0x2,%eax
    7380:	01 c8                	add    %ecx,%eax
    7382:	c1 e0 05             	shl    $0x5,%eax
    7385:	01 d0                	add    %edx,%eax
    7387:	01 f0                	add    %esi,%eax
    7389:	83 c0 1c             	add    $0x1c,%eax
    738c:	89 18                	mov    %ebx,(%eax)
			si->ch[ch].gr[gr].global_gain = getbits(bs, 8);
    738e:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
    7395:	00 
    7396:	8b 45 08             	mov    0x8(%ebp),%eax
    7399:	89 04 24             	mov    %eax,(%esp)
    739c:	e8 07 de ff ff       	call   51a8 <getbits>
    73a1:	89 c3                	mov    %eax,%ebx
    73a3:	8b 75 0c             	mov    0xc(%ebp),%esi
    73a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    73a9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    73ac:	89 c2                	mov    %eax,%edx
    73ae:	c1 e2 03             	shl    $0x3,%edx
    73b1:	01 c2                	add    %eax,%edx
    73b3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    73ba:	89 c2                	mov    %eax,%edx
    73bc:	89 c8                	mov    %ecx,%eax
    73be:	c1 e0 02             	shl    $0x2,%eax
    73c1:	01 c8                	add    %ecx,%eax
    73c3:	c1 e0 05             	shl    $0x5,%eax
    73c6:	01 d0                	add    %edx,%eax
    73c8:	01 f0                	add    %esi,%eax
    73ca:	83 c0 20             	add    $0x20,%eax
    73cd:	89 18                	mov    %ebx,(%eax)
			si->ch[ch].gr[gr].scalefac_compress = getbits(bs, 4);
    73cf:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
    73d6:	00 
    73d7:	8b 45 08             	mov    0x8(%ebp),%eax
    73da:	89 04 24             	mov    %eax,(%esp)
    73dd:	e8 c6 dd ff ff       	call   51a8 <getbits>
    73e2:	89 c3                	mov    %eax,%ebx
    73e4:	8b 75 0c             	mov    0xc(%ebp),%esi
    73e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    73ea:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    73ed:	89 c2                	mov    %eax,%edx
    73ef:	c1 e2 03             	shl    $0x3,%edx
    73f2:	01 c2                	add    %eax,%edx
    73f4:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    73fb:	89 c2                	mov    %eax,%edx
    73fd:	89 c8                	mov    %ecx,%eax
    73ff:	c1 e0 02             	shl    $0x2,%eax
    7402:	01 c8                	add    %ecx,%eax
    7404:	c1 e0 05             	shl    $0x5,%eax
    7407:	01 d0                	add    %edx,%eax
    7409:	01 f0                	add    %esi,%eax
    740b:	83 c0 24             	add    $0x24,%eax
    740e:	89 18                	mov    %ebx,(%eax)
			si->ch[ch].gr[gr].window_switching_flag = get1bit(bs);
    7410:	8b 45 08             	mov    0x8(%ebp),%eax
    7413:	89 04 24             	mov    %eax,(%esp)
    7416:	e8 7b dc ff ff       	call   5096 <get1bit>
    741b:	89 c3                	mov    %eax,%ebx
    741d:	8b 75 0c             	mov    0xc(%ebp),%esi
    7420:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7423:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    7426:	89 c2                	mov    %eax,%edx
    7428:	c1 e2 03             	shl    $0x3,%edx
    742b:	01 c2                	add    %eax,%edx
    742d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7434:	89 c2                	mov    %eax,%edx
    7436:	89 c8                	mov    %ecx,%eax
    7438:	c1 e0 02             	shl    $0x2,%eax
    743b:	01 c8                	add    %ecx,%eax
    743d:	c1 e0 05             	shl    $0x5,%eax
    7440:	01 d0                	add    %edx,%eax
    7442:	01 f0                	add    %esi,%eax
    7444:	83 c0 28             	add    $0x28,%eax
    7447:	89 18                	mov    %ebx,(%eax)
			if (si->ch[ch].gr[gr].window_switching_flag) {
    7449:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    744c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    744f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    7452:	89 c2                	mov    %eax,%edx
    7454:	c1 e2 03             	shl    $0x3,%edx
    7457:	01 c2                	add    %eax,%edx
    7459:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7460:	89 c2                	mov    %eax,%edx
    7462:	89 c8                	mov    %ecx,%eax
    7464:	c1 e0 02             	shl    $0x2,%eax
    7467:	01 c8                	add    %ecx,%eax
    7469:	c1 e0 05             	shl    $0x5,%eax
    746c:	01 d0                	add    %edx,%eax
    746e:	01 d8                	add    %ebx,%eax
    7470:	83 c0 28             	add    $0x28,%eax
    7473:	8b 00                	mov    (%eax),%eax
    7475:	85 c0                	test   %eax,%eax
    7477:	0f 84 82 02 00 00    	je     76ff <III_get_side_info+0x4bc>
				si->ch[ch].gr[gr].block_type = getbits(bs, 2);
    747d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    7484:	00 
    7485:	8b 45 08             	mov    0x8(%ebp),%eax
    7488:	89 04 24             	mov    %eax,(%esp)
    748b:	e8 18 dd ff ff       	call   51a8 <getbits>
    7490:	89 c3                	mov    %eax,%ebx
    7492:	8b 75 0c             	mov    0xc(%ebp),%esi
    7495:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7498:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    749b:	89 c2                	mov    %eax,%edx
    749d:	c1 e2 03             	shl    $0x3,%edx
    74a0:	01 c2                	add    %eax,%edx
    74a2:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    74a9:	89 c2                	mov    %eax,%edx
    74ab:	89 c8                	mov    %ecx,%eax
    74ad:	c1 e0 02             	shl    $0x2,%eax
    74b0:	01 c8                	add    %ecx,%eax
    74b2:	c1 e0 05             	shl    $0x5,%eax
    74b5:	01 d0                	add    %edx,%eax
    74b7:	01 f0                	add    %esi,%eax
    74b9:	83 c0 2c             	add    $0x2c,%eax
    74bc:	89 18                	mov    %ebx,(%eax)
				si->ch[ch].gr[gr].mixed_block_flag = get1bit(bs);
    74be:	8b 45 08             	mov    0x8(%ebp),%eax
    74c1:	89 04 24             	mov    %eax,(%esp)
    74c4:	e8 cd db ff ff       	call   5096 <get1bit>
    74c9:	89 c3                	mov    %eax,%ebx
    74cb:	8b 75 0c             	mov    0xc(%ebp),%esi
    74ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    74d1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    74d4:	89 c2                	mov    %eax,%edx
    74d6:	c1 e2 03             	shl    $0x3,%edx
    74d9:	01 c2                	add    %eax,%edx
    74db:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    74e2:	89 c2                	mov    %eax,%edx
    74e4:	89 c8                	mov    %ecx,%eax
    74e6:	c1 e0 02             	shl    $0x2,%eax
    74e9:	01 c8                	add    %ecx,%eax
    74eb:	c1 e0 05             	shl    $0x5,%eax
    74ee:	01 d0                	add    %edx,%eax
    74f0:	01 f0                	add    %esi,%eax
    74f2:	83 c0 30             	add    $0x30,%eax
    74f5:	89 18                	mov    %ebx,(%eax)
				for (i=0; i<2; i++)
    74f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    74fe:	eb 46                	jmp    7546 <III_get_side_info+0x303>
					si->ch[ch].gr[gr].table_select[i] = getbits(bs, 5);
    7500:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
    7507:	00 
    7508:	8b 45 08             	mov    0x8(%ebp),%eax
    750b:	89 04 24             	mov    %eax,(%esp)
    750e:	e8 95 dc ff ff       	call   51a8 <getbits>
    7513:	89 c3                	mov    %eax,%ebx
    7515:	8b 75 0c             	mov    0xc(%ebp),%esi
    7518:	8b 45 f0             	mov    -0x10(%ebp),%eax
    751b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    751e:	89 c2                	mov    %eax,%edx
    7520:	c1 e2 03             	shl    $0x3,%edx
    7523:	01 c2                	add    %eax,%edx
    7525:	8d 04 12             	lea    (%edx,%edx,1),%eax
    7528:	89 c2                	mov    %eax,%edx
    752a:	89 c8                	mov    %ecx,%eax
    752c:	c1 e0 02             	shl    $0x2,%eax
    752f:	01 c8                	add    %ecx,%eax
    7531:	c1 e0 03             	shl    $0x3,%eax
    7534:	01 c2                	add    %eax,%edx
    7536:	8b 45 ec             	mov    -0x14(%ebp),%eax
    7539:	01 d0                	add    %edx,%eax
    753b:	83 c0 08             	add    $0x8,%eax
    753e:	89 5c 86 14          	mov    %ebx,0x14(%esi,%eax,4)
			si->ch[ch].gr[gr].scalefac_compress = getbits(bs, 4);
			si->ch[ch].gr[gr].window_switching_flag = get1bit(bs);
			if (si->ch[ch].gr[gr].window_switching_flag) {
				si->ch[ch].gr[gr].block_type = getbits(bs, 2);
				si->ch[ch].gr[gr].mixed_block_flag = get1bit(bs);
				for (i=0; i<2; i++)
    7542:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    7546:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
    754a:	7e b4                	jle    7500 <III_get_side_info+0x2bd>
					si->ch[ch].gr[gr].table_select[i] = getbits(bs, 5);
				for (i=0; i<3; i++)
    754c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    7553:	eb 46                	jmp    759b <III_get_side_info+0x358>
					si->ch[ch].gr[gr].subblock_gain[i] = getbits(bs, 3);
    7555:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
    755c:	00 
    755d:	8b 45 08             	mov    0x8(%ebp),%eax
    7560:	89 04 24             	mov    %eax,(%esp)
    7563:	e8 40 dc ff ff       	call   51a8 <getbits>
    7568:	89 c3                	mov    %eax,%ebx
    756a:	8b 75 0c             	mov    0xc(%ebp),%esi
    756d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7570:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    7573:	89 c2                	mov    %eax,%edx
    7575:	c1 e2 03             	shl    $0x3,%edx
    7578:	01 c2                	add    %eax,%edx
    757a:	8d 04 12             	lea    (%edx,%edx,1),%eax
    757d:	89 c2                	mov    %eax,%edx
    757f:	89 c8                	mov    %ecx,%eax
    7581:	c1 e0 02             	shl    $0x2,%eax
    7584:	01 c8                	add    %ecx,%eax
    7586:	c1 e0 03             	shl    $0x3,%eax
    7589:	01 c2                	add    %eax,%edx
    758b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    758e:	01 d0                	add    %edx,%eax
    7590:	83 c0 0c             	add    $0xc,%eax
    7593:	89 5c 86 10          	mov    %ebx,0x10(%esi,%eax,4)
			if (si->ch[ch].gr[gr].window_switching_flag) {
				si->ch[ch].gr[gr].block_type = getbits(bs, 2);
				si->ch[ch].gr[gr].mixed_block_flag = get1bit(bs);
				for (i=0; i<2; i++)
					si->ch[ch].gr[gr].table_select[i] = getbits(bs, 5);
				for (i=0; i<3; i++)
    7597:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    759b:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
    759f:	7e b4                	jle    7555 <III_get_side_info+0x312>
					si->ch[ch].gr[gr].subblock_gain[i] = getbits(bs, 3);

				/* Set region_count parameters since they are implicit in this case. */

				if (si->ch[ch].gr[gr].block_type == 0) {
    75a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    75a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    75a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    75aa:	89 c2                	mov    %eax,%edx
    75ac:	c1 e2 03             	shl    $0x3,%edx
    75af:	01 c2                	add    %eax,%edx
    75b1:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    75b8:	89 c2                	mov    %eax,%edx
    75ba:	89 c8                	mov    %ecx,%eax
    75bc:	c1 e0 02             	shl    $0x2,%eax
    75bf:	01 c8                	add    %ecx,%eax
    75c1:	c1 e0 05             	shl    $0x5,%eax
    75c4:	01 d0                	add    %edx,%eax
    75c6:	01 d8                	add    %ebx,%eax
    75c8:	83 c0 2c             	add    $0x2c,%eax
    75cb:	8b 00                	mov    (%eax),%eax
    75cd:	85 c0                	test   %eax,%eax
    75cf:	75 05                	jne    75d6 <III_get_side_info+0x393>
					//printf("Side info bad: block_type == 0 in split block.\n");
					exit();
    75d1:	e8 84 cb ff ff       	call   415a <exit>
				}
				else if (si->ch[ch].gr[gr].block_type == 2
    75d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    75d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    75dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    75df:	89 c2                	mov    %eax,%edx
    75e1:	c1 e2 03             	shl    $0x3,%edx
    75e4:	01 c2                	add    %eax,%edx
    75e6:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    75ed:	89 c2                	mov    %eax,%edx
    75ef:	89 c8                	mov    %ecx,%eax
    75f1:	c1 e0 02             	shl    $0x2,%eax
    75f4:	01 c8                	add    %ecx,%eax
    75f6:	c1 e0 05             	shl    $0x5,%eax
    75f9:	01 d0                	add    %edx,%eax
    75fb:	01 d8                	add    %ebx,%eax
    75fd:	83 c0 2c             	add    $0x2c,%eax
    7600:	8b 00                	mov    (%eax),%eax
    7602:	83 f8 02             	cmp    $0x2,%eax
    7605:	75 62                	jne    7669 <III_get_side_info+0x426>
						&& si->ch[ch].gr[gr].mixed_block_flag == 0)
    7607:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    760a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    760d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    7610:	89 c2                	mov    %eax,%edx
    7612:	c1 e2 03             	shl    $0x3,%edx
    7615:	01 c2                	add    %eax,%edx
    7617:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    761e:	89 c2                	mov    %eax,%edx
    7620:	89 c8                	mov    %ecx,%eax
    7622:	c1 e0 02             	shl    $0x2,%eax
    7625:	01 c8                	add    %ecx,%eax
    7627:	c1 e0 05             	shl    $0x5,%eax
    762a:	01 d0                	add    %edx,%eax
    762c:	01 d8                	add    %ebx,%eax
    762e:	83 c0 30             	add    $0x30,%eax
    7631:	8b 00                	mov    (%eax),%eax
    7633:	85 c0                	test   %eax,%eax
    7635:	75 32                	jne    7669 <III_get_side_info+0x426>
					si->ch[ch].gr[gr].region0_count = 8; /* MI 9; */
    7637:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    763a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    763d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    7640:	89 c2                	mov    %eax,%edx
    7642:	c1 e2 03             	shl    $0x3,%edx
    7645:	01 c2                	add    %eax,%edx
    7647:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    764e:	89 c2                	mov    %eax,%edx
    7650:	89 c8                	mov    %ecx,%eax
    7652:	c1 e0 02             	shl    $0x2,%eax
    7655:	01 c8                	add    %ecx,%eax
    7657:	c1 e0 05             	shl    $0x5,%eax
    765a:	01 d0                	add    %edx,%eax
    765c:	01 d8                	add    %ebx,%eax
    765e:	83 c0 4c             	add    $0x4c,%eax
    7661:	c7 00 08 00 00 00    	movl   $0x8,(%eax)
    7667:	eb 30                	jmp    7699 <III_get_side_info+0x456>
				else si->ch[ch].gr[gr].region0_count = 7; /* MI 8; */
    7669:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    766c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    766f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    7672:	89 c2                	mov    %eax,%edx
    7674:	c1 e2 03             	shl    $0x3,%edx
    7677:	01 c2                	add    %eax,%edx
    7679:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7680:	89 c2                	mov    %eax,%edx
    7682:	89 c8                	mov    %ecx,%eax
    7684:	c1 e0 02             	shl    $0x2,%eax
    7687:	01 c8                	add    %ecx,%eax
    7689:	c1 e0 05             	shl    $0x5,%eax
    768c:	01 d0                	add    %edx,%eax
    768e:	01 d8                	add    %ebx,%eax
    7690:	83 c0 4c             	add    $0x4c,%eax
    7693:	c7 00 07 00 00 00    	movl   $0x7,(%eax)
					si->ch[ch].gr[gr].region1_count = 20 - si->ch[ch].gr[gr].region0_count;
    7699:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    769c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    769f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    76a2:	89 c2                	mov    %eax,%edx
    76a4:	c1 e2 03             	shl    $0x3,%edx
    76a7:	01 c2                	add    %eax,%edx
    76a9:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    76b0:	89 c2                	mov    %eax,%edx
    76b2:	89 c8                	mov    %ecx,%eax
    76b4:	c1 e0 02             	shl    $0x2,%eax
    76b7:	01 c8                	add    %ecx,%eax
    76b9:	c1 e0 05             	shl    $0x5,%eax
    76bc:	01 d0                	add    %edx,%eax
    76be:	01 d8                	add    %ebx,%eax
    76c0:	83 c0 4c             	add    $0x4c,%eax
    76c3:	8b 00                	mov    (%eax),%eax
    76c5:	ba 14 00 00 00       	mov    $0x14,%edx
    76ca:	89 d3                	mov    %edx,%ebx
    76cc:	29 c3                	sub    %eax,%ebx
    76ce:	8b 75 0c             	mov    0xc(%ebp),%esi
    76d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    76d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    76d7:	89 c2                	mov    %eax,%edx
    76d9:	c1 e2 03             	shl    $0x3,%edx
    76dc:	01 c2                	add    %eax,%edx
    76de:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    76e5:	89 c2                	mov    %eax,%edx
    76e7:	89 c8                	mov    %ecx,%eax
    76e9:	c1 e0 02             	shl    $0x2,%eax
    76ec:	01 c8                	add    %ecx,%eax
    76ee:	c1 e0 05             	shl    $0x5,%eax
    76f1:	01 d0                	add    %edx,%eax
    76f3:	01 f0                	add    %esi,%eax
    76f5:	83 c0 50             	add    $0x50,%eax
    76f8:	89 18                	mov    %ebx,(%eax)
    76fa:	e9 07 01 00 00       	jmp    7806 <III_get_side_info+0x5c3>
			}
			else {
				for (i=0; i<3; i++)
    76ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    7706:	eb 46                	jmp    774e <III_get_side_info+0x50b>
					si->ch[ch].gr[gr].table_select[i] = getbits(bs, 5);
    7708:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
    770f:	00 
    7710:	8b 45 08             	mov    0x8(%ebp),%eax
    7713:	89 04 24             	mov    %eax,(%esp)
    7716:	e8 8d da ff ff       	call   51a8 <getbits>
    771b:	89 c3                	mov    %eax,%ebx
    771d:	8b 75 0c             	mov    0xc(%ebp),%esi
    7720:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7723:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    7726:	89 c2                	mov    %eax,%edx
    7728:	c1 e2 03             	shl    $0x3,%edx
    772b:	01 c2                	add    %eax,%edx
    772d:	8d 04 12             	lea    (%edx,%edx,1),%eax
    7730:	89 c2                	mov    %eax,%edx
    7732:	89 c8                	mov    %ecx,%eax
    7734:	c1 e0 02             	shl    $0x2,%eax
    7737:	01 c8                	add    %ecx,%eax
    7739:	c1 e0 03             	shl    $0x3,%eax
    773c:	01 c2                	add    %eax,%edx
    773e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    7741:	01 d0                	add    %edx,%eax
    7743:	83 c0 08             	add    $0x8,%eax
    7746:	89 5c 86 14          	mov    %ebx,0x14(%esi,%eax,4)
					si->ch[ch].gr[gr].region0_count = 8; /* MI 9; */
				else si->ch[ch].gr[gr].region0_count = 7; /* MI 8; */
					si->ch[ch].gr[gr].region1_count = 20 - si->ch[ch].gr[gr].region0_count;
			}
			else {
				for (i=0; i<3; i++)
    774a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    774e:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
    7752:	7e b4                	jle    7708 <III_get_side_info+0x4c5>
					si->ch[ch].gr[gr].table_select[i] = getbits(bs, 5);
				si->ch[ch].gr[gr].region0_count = getbits(bs, 4);
    7754:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
    775b:	00 
    775c:	8b 45 08             	mov    0x8(%ebp),%eax
    775f:	89 04 24             	mov    %eax,(%esp)
    7762:	e8 41 da ff ff       	call   51a8 <getbits>
    7767:	89 c3                	mov    %eax,%ebx
    7769:	8b 75 0c             	mov    0xc(%ebp),%esi
    776c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    776f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    7772:	89 c2                	mov    %eax,%edx
    7774:	c1 e2 03             	shl    $0x3,%edx
    7777:	01 c2                	add    %eax,%edx
    7779:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7780:	89 c2                	mov    %eax,%edx
    7782:	89 c8                	mov    %ecx,%eax
    7784:	c1 e0 02             	shl    $0x2,%eax
    7787:	01 c8                	add    %ecx,%eax
    7789:	c1 e0 05             	shl    $0x5,%eax
    778c:	01 d0                	add    %edx,%eax
    778e:	01 f0                	add    %esi,%eax
    7790:	83 c0 4c             	add    $0x4c,%eax
    7793:	89 18                	mov    %ebx,(%eax)
				si->ch[ch].gr[gr].region1_count = getbits(bs, 3);
    7795:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
    779c:	00 
    779d:	8b 45 08             	mov    0x8(%ebp),%eax
    77a0:	89 04 24             	mov    %eax,(%esp)
    77a3:	e8 00 da ff ff       	call   51a8 <getbits>
    77a8:	89 c3                	mov    %eax,%ebx
    77aa:	8b 75 0c             	mov    0xc(%ebp),%esi
    77ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
    77b0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    77b3:	89 c2                	mov    %eax,%edx
    77b5:	c1 e2 03             	shl    $0x3,%edx
    77b8:	01 c2                	add    %eax,%edx
    77ba:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    77c1:	89 c2                	mov    %eax,%edx
    77c3:	89 c8                	mov    %ecx,%eax
    77c5:	c1 e0 02             	shl    $0x2,%eax
    77c8:	01 c8                	add    %ecx,%eax
    77ca:	c1 e0 05             	shl    $0x5,%eax
    77cd:	01 d0                	add    %edx,%eax
    77cf:	01 f0                	add    %esi,%eax
    77d1:	83 c0 50             	add    $0x50,%eax
    77d4:	89 18                	mov    %ebx,(%eax)
				si->ch[ch].gr[gr].block_type = 0;
    77d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    77d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    77dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    77df:	89 c2                	mov    %eax,%edx
    77e1:	c1 e2 03             	shl    $0x3,%edx
    77e4:	01 c2                	add    %eax,%edx
    77e6:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    77ed:	89 c2                	mov    %eax,%edx
    77ef:	89 c8                	mov    %ecx,%eax
    77f1:	c1 e0 02             	shl    $0x2,%eax
    77f4:	01 c8                	add    %ecx,%eax
    77f6:	c1 e0 05             	shl    $0x5,%eax
    77f9:	01 d0                	add    %edx,%eax
    77fb:	01 d8                	add    %ebx,%eax
    77fd:	83 c0 2c             	add    $0x2c,%eax
    7800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			si->ch[ch].gr[gr].preflag = get1bit(bs);
    7806:	8b 45 08             	mov    0x8(%ebp),%eax
    7809:	89 04 24             	mov    %eax,(%esp)
    780c:	e8 85 d8 ff ff       	call   5096 <get1bit>
    7811:	89 c3                	mov    %eax,%ebx
    7813:	8b 75 0c             	mov    0xc(%ebp),%esi
    7816:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7819:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    781c:	89 c2                	mov    %eax,%edx
    781e:	c1 e2 03             	shl    $0x3,%edx
    7821:	01 c2                	add    %eax,%edx
    7823:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    782a:	89 c2                	mov    %eax,%edx
    782c:	89 c8                	mov    %ecx,%eax
    782e:	c1 e0 02             	shl    $0x2,%eax
    7831:	01 c8                	add    %ecx,%eax
    7833:	c1 e0 05             	shl    $0x5,%eax
    7836:	01 d0                	add    %edx,%eax
    7838:	01 f0                	add    %esi,%eax
    783a:	83 c0 54             	add    $0x54,%eax
    783d:	89 18                	mov    %ebx,(%eax)
			si->ch[ch].gr[gr].scalefac_scale = get1bit(bs);
    783f:	8b 45 08             	mov    0x8(%ebp),%eax
    7842:	89 04 24             	mov    %eax,(%esp)
    7845:	e8 4c d8 ff ff       	call   5096 <get1bit>
    784a:	89 c3                	mov    %eax,%ebx
    784c:	8b 75 0c             	mov    0xc(%ebp),%esi
    784f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7852:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    7855:	89 c2                	mov    %eax,%edx
    7857:	c1 e2 03             	shl    $0x3,%edx
    785a:	01 c2                	add    %eax,%edx
    785c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7863:	89 c2                	mov    %eax,%edx
    7865:	89 c8                	mov    %ecx,%eax
    7867:	c1 e0 02             	shl    $0x2,%eax
    786a:	01 c8                	add    %ecx,%eax
    786c:	c1 e0 05             	shl    $0x5,%eax
    786f:	01 d0                	add    %edx,%eax
    7871:	01 f0                	add    %esi,%eax
    7873:	83 c0 58             	add    $0x58,%eax
    7876:	89 18                	mov    %ebx,(%eax)
			si->ch[ch].gr[gr].count1table_select = get1bit(bs);
    7878:	8b 45 08             	mov    0x8(%ebp),%eax
    787b:	89 04 24             	mov    %eax,(%esp)
    787e:	e8 13 d8 ff ff       	call   5096 <get1bit>
    7883:	89 c3                	mov    %eax,%ebx
    7885:	8b 75 0c             	mov    0xc(%ebp),%esi
    7888:	8b 45 f0             	mov    -0x10(%ebp),%eax
    788b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    788e:	89 c2                	mov    %eax,%edx
    7890:	c1 e2 03             	shl    $0x3,%edx
    7893:	01 c2                	add    %eax,%edx
    7895:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    789c:	89 c2                	mov    %eax,%edx
    789e:	89 c8                	mov    %ecx,%eax
    78a0:	c1 e0 02             	shl    $0x2,%eax
    78a3:	01 c8                	add    %ecx,%eax
    78a5:	c1 e0 05             	shl    $0x5,%eax
    78a8:	01 d0                	add    %edx,%eax
    78aa:	01 f0                	add    %esi,%eax
    78ac:	83 c0 5c             	add    $0x5c,%eax
    78af:	89 18                	mov    %ebx,(%eax)
	for (ch=0; ch<stereo; ch++)
		for (i=0; i<4; i++)
			si->ch[ch].scfsi[i] = get1bit(bs);

	for (gr=0; gr<2; gr++) {
		for (ch=0; ch<stereo; ch++) {
    78b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    78b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    78b8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    78bb:	0f 8c 4b fa ff ff    	jl     730c <III_get_side_info+0xc9>

	for (ch=0; ch<stereo; ch++)
		for (i=0; i<4; i++)
			si->ch[ch].scfsi[i] = get1bit(bs);

	for (gr=0; gr<2; gr++) {
    78c1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    78c5:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    78c9:	0f 8e 31 fa ff ff    	jle    7300 <III_get_side_info+0xbd>
			si->ch[ch].gr[gr].preflag = get1bit(bs);
			si->ch[ch].gr[gr].scalefac_scale = get1bit(bs);
			si->ch[ch].gr[gr].count1table_select = get1bit(bs);
         }
	}
}
    78cf:	83 c4 20             	add    $0x20,%esp
    78d2:	5b                   	pop    %ebx
    78d3:	5e                   	pop    %esi
    78d4:	5d                   	pop    %ebp
    78d5:	c3                   	ret    

000078d6 <III_get_scale_factors>:
	{{0,4,8,12,16,20,24,30,36,44,54,66,82,102,126,156,194,240,296,364,448,550,576},
		{0,4,8,12,16,22,30,42,58,78,104,138,180,192}}
};

void III_get_scale_factors(III_scalefac_t *scalefac, struct III_side_info_t *si, int gr, int ch, struct frame_params *fr_ps)
{
    78d6:	55                   	push   %ebp
    78d7:	89 e5                	mov    %esp,%ebp
    78d9:	56                   	push   %esi
    78da:	53                   	push   %ebx
    78db:	83 ec 20             	sub    $0x20,%esp
	int sfb, i, window;
	struct gr_info_s *gr_info = &(si->ch[ch].gr[gr]);
    78de:	8b 45 10             	mov    0x10(%ebp),%eax
    78e1:	89 c2                	mov    %eax,%edx
    78e3:	c1 e2 03             	shl    $0x3,%edx
    78e6:	01 c2                	add    %eax,%edx
    78e8:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    78ef:	89 c2                	mov    %eax,%edx
    78f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
    78f4:	89 c8                	mov    %ecx,%eax
    78f6:	c1 e0 02             	shl    $0x2,%eax
    78f9:	01 c8                	add    %ecx,%eax
    78fb:	c1 e0 05             	shl    $0x5,%eax
    78fe:	01 d0                	add    %edx,%eax
    7900:	8d 50 10             	lea    0x10(%eax),%edx
    7903:	8b 45 0c             	mov    0xc(%ebp),%eax
    7906:	01 d0                	add    %edx,%eax
    7908:	83 c0 08             	add    $0x8,%eax
    790b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
    790e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    7911:	8b 40 10             	mov    0x10(%eax),%eax
    7914:	85 c0                	test   %eax,%eax
    7916:	0f 84 7e 02 00 00    	je     7b9a <III_get_scale_factors+0x2c4>
    791c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    791f:	8b 40 14             	mov    0x14(%eax),%eax
    7922:	83 f8 02             	cmp    $0x2,%eax
    7925:	0f 85 6f 02 00 00    	jne    7b9a <III_get_scale_factors+0x2c4>
		if (gr_info->mixed_block_flag) { /* MIXED */ /* NEW - ag 11/25 */
    792b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    792e:	8b 40 18             	mov    0x18(%eax),%eax
    7931:	85 c0                	test   %eax,%eax
    7933:	0f 84 6b 01 00 00    	je     7aa4 <III_get_scale_factors+0x1ce>
			for (sfb = 0; sfb < 8; sfb++)
    7939:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    7940:	eb 32                	jmp    7974 <III_get_scale_factors+0x9e>
				(*scalefac)[ch].l[sfb] = hgetbits(
					slen[0][gr_info->scalefac_compress]);
    7942:	8b 45 e8             	mov    -0x18(%ebp),%eax
    7945:	8b 40 0c             	mov    0xc(%eax),%eax
	struct gr_info_s *gr_info = &(si->ch[ch].gr[gr]);

	if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
		if (gr_info->mixed_block_flag) { /* MIXED */ /* NEW - ag 11/25 */
			for (sfb = 0; sfb < 8; sfb++)
				(*scalefac)[ch].l[sfb] = hgetbits(
    7948:	8b 04 85 00 e9 00 00 	mov    0xe900(,%eax,4),%eax
    794f:	89 04 24             	mov    %eax,(%esp)
    7952:	e8 b9 db ff ff       	call   5510 <hgetbits>
    7957:	89 c3                	mov    %eax,%ebx
    7959:	8b 4d 08             	mov    0x8(%ebp),%ecx
    795c:	8b 45 14             	mov    0x14(%ebp),%eax
    795f:	01 c0                	add    %eax,%eax
    7961:	89 c2                	mov    %eax,%edx
    7963:	c1 e2 05             	shl    $0x5,%edx
    7966:	29 c2                	sub    %eax,%edx
    7968:	8b 45 f4             	mov    -0xc(%ebp),%eax
    796b:	01 d0                	add    %edx,%eax
    796d:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
	int sfb, i, window;
	struct gr_info_s *gr_info = &(si->ch[ch].gr[gr]);

	if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
		if (gr_info->mixed_block_flag) { /* MIXED */ /* NEW - ag 11/25 */
			for (sfb = 0; sfb < 8; sfb++)
    7970:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    7974:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
    7978:	7e c8                	jle    7942 <III_get_scale_factors+0x6c>
				(*scalefac)[ch].l[sfb] = hgetbits(
					slen[0][gr_info->scalefac_compress]);
			for (sfb = 3; sfb < 6; sfb++)
    797a:	c7 45 f4 03 00 00 00 	movl   $0x3,-0xc(%ebp)
    7981:	eb 5c                	jmp    79df <III_get_scale_factors+0x109>
				for (window=0; window<3; window++)
    7983:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    798a:	eb 49                	jmp    79d5 <III_get_scale_factors+0xff>
					(*scalefac)[ch].s[window][sfb] = hgetbits(
						slen[0][gr_info->scalefac_compress]);
    798c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    798f:	8b 40 0c             	mov    0xc(%eax),%eax
			for (sfb = 0; sfb < 8; sfb++)
				(*scalefac)[ch].l[sfb] = hgetbits(
					slen[0][gr_info->scalefac_compress]);
			for (sfb = 3; sfb < 6; sfb++)
				for (window=0; window<3; window++)
					(*scalefac)[ch].s[window][sfb] = hgetbits(
    7992:	8b 04 85 00 e9 00 00 	mov    0xe900(,%eax,4),%eax
    7999:	89 04 24             	mov    %eax,(%esp)
    799c:	e8 6f db ff ff       	call   5510 <hgetbits>
    79a1:	89 c6                	mov    %eax,%esi
    79a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
    79a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
    79a9:	8b 4d 14             	mov    0x14(%ebp),%ecx
    79ac:	89 d0                	mov    %edx,%eax
    79ae:	01 c0                	add    %eax,%eax
    79b0:	01 d0                	add    %edx,%eax
    79b2:	c1 e0 02             	shl    $0x2,%eax
    79b5:	01 d0                	add    %edx,%eax
    79b7:	89 ca                	mov    %ecx,%edx
    79b9:	01 d2                	add    %edx,%edx
    79bb:	89 d1                	mov    %edx,%ecx
    79bd:	c1 e1 05             	shl    $0x5,%ecx
    79c0:	29 d1                	sub    %edx,%ecx
    79c2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
    79c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    79c8:	01 d0                	add    %edx,%eax
    79ca:	83 c0 14             	add    $0x14,%eax
    79cd:	89 74 83 0c          	mov    %esi,0xc(%ebx,%eax,4)
		if (gr_info->mixed_block_flag) { /* MIXED */ /* NEW - ag 11/25 */
			for (sfb = 0; sfb < 8; sfb++)
				(*scalefac)[ch].l[sfb] = hgetbits(
					slen[0][gr_info->scalefac_compress]);
			for (sfb = 3; sfb < 6; sfb++)
				for (window=0; window<3; window++)
    79d1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    79d5:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
    79d9:	7e b1                	jle    798c <III_get_scale_factors+0xb6>
	if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
		if (gr_info->mixed_block_flag) { /* MIXED */ /* NEW - ag 11/25 */
			for (sfb = 0; sfb < 8; sfb++)
				(*scalefac)[ch].l[sfb] = hgetbits(
					slen[0][gr_info->scalefac_compress]);
			for (sfb = 3; sfb < 6; sfb++)
    79db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    79df:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
    79e3:	7e 9e                	jle    7983 <III_get_scale_factors+0xad>
				for (window=0; window<3; window++)
					(*scalefac)[ch].s[window][sfb] = hgetbits(
						slen[0][gr_info->scalefac_compress]);
			for (sfb = 6; sfb < 12; sfb++)
    79e5:	c7 45 f4 06 00 00 00 	movl   $0x6,-0xc(%ebp)
    79ec:	eb 5f                	jmp    7a4d <III_get_scale_factors+0x177>
				for (window=0; window<3; window++)
    79ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    79f5:	eb 4c                	jmp    7a43 <III_get_scale_factors+0x16d>
					(*scalefac)[ch].s[window][sfb] = hgetbits(
						slen[1][gr_info->scalefac_compress]);
    79f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    79fa:	8b 40 0c             	mov    0xc(%eax),%eax
				for (window=0; window<3; window++)
					(*scalefac)[ch].s[window][sfb] = hgetbits(
						slen[0][gr_info->scalefac_compress]);
			for (sfb = 6; sfb < 12; sfb++)
				for (window=0; window<3; window++)
					(*scalefac)[ch].s[window][sfb] = hgetbits(
    79fd:	83 c0 10             	add    $0x10,%eax
    7a00:	8b 04 85 00 e9 00 00 	mov    0xe900(,%eax,4),%eax
    7a07:	89 04 24             	mov    %eax,(%esp)
    7a0a:	e8 01 db ff ff       	call   5510 <hgetbits>
    7a0f:	89 c6                	mov    %eax,%esi
    7a11:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7a14:	8b 55 ec             	mov    -0x14(%ebp),%edx
    7a17:	8b 4d 14             	mov    0x14(%ebp),%ecx
    7a1a:	89 d0                	mov    %edx,%eax
    7a1c:	01 c0                	add    %eax,%eax
    7a1e:	01 d0                	add    %edx,%eax
    7a20:	c1 e0 02             	shl    $0x2,%eax
    7a23:	01 d0                	add    %edx,%eax
    7a25:	89 ca                	mov    %ecx,%edx
    7a27:	01 d2                	add    %edx,%edx
    7a29:	89 d1                	mov    %edx,%ecx
    7a2b:	c1 e1 05             	shl    $0x5,%ecx
    7a2e:	29 d1                	sub    %edx,%ecx
    7a30:	8d 14 08             	lea    (%eax,%ecx,1),%edx
    7a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
    7a36:	01 d0                	add    %edx,%eax
    7a38:	83 c0 14             	add    $0x14,%eax
    7a3b:	89 74 83 0c          	mov    %esi,0xc(%ebx,%eax,4)
			for (sfb = 3; sfb < 6; sfb++)
				for (window=0; window<3; window++)
					(*scalefac)[ch].s[window][sfb] = hgetbits(
						slen[0][gr_info->scalefac_compress]);
			for (sfb = 6; sfb < 12; sfb++)
				for (window=0; window<3; window++)
    7a3f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    7a43:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
    7a47:	7e ae                	jle    79f7 <III_get_scale_factors+0x121>
					slen[0][gr_info->scalefac_compress]);
			for (sfb = 3; sfb < 6; sfb++)
				for (window=0; window<3; window++)
					(*scalefac)[ch].s[window][sfb] = hgetbits(
						slen[0][gr_info->scalefac_compress]);
			for (sfb = 6; sfb < 12; sfb++)
    7a49:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    7a4d:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    7a51:	7e 9b                	jle    79ee <III_get_scale_factors+0x118>
				for (window=0; window<3; window++)
					(*scalefac)[ch].s[window][sfb] = hgetbits(
						slen[1][gr_info->scalefac_compress]);
			for (sfb=12,window=0; window<3; window++)
    7a53:	c7 45 f4 0c 00 00 00 	movl   $0xc,-0xc(%ebp)
    7a5a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    7a61:	eb 36                	jmp    7a99 <III_get_scale_factors+0x1c3>
				(*scalefac)[ch].s[window][sfb] = 0;
    7a63:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7a66:	8b 55 ec             	mov    -0x14(%ebp),%edx
    7a69:	8b 4d 14             	mov    0x14(%ebp),%ecx
    7a6c:	89 d0                	mov    %edx,%eax
    7a6e:	01 c0                	add    %eax,%eax
    7a70:	01 d0                	add    %edx,%eax
    7a72:	c1 e0 02             	shl    $0x2,%eax
    7a75:	01 d0                	add    %edx,%eax
    7a77:	89 ca                	mov    %ecx,%edx
    7a79:	01 d2                	add    %edx,%edx
    7a7b:	89 d1                	mov    %edx,%ecx
    7a7d:	c1 e1 05             	shl    $0x5,%ecx
    7a80:	29 d1                	sub    %edx,%ecx
    7a82:	8d 14 08             	lea    (%eax,%ecx,1),%edx
    7a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
    7a88:	01 d0                	add    %edx,%eax
    7a8a:	83 c0 14             	add    $0x14,%eax
    7a8d:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
    7a94:	00 
						slen[0][gr_info->scalefac_compress]);
			for (sfb = 6; sfb < 12; sfb++)
				for (window=0; window<3; window++)
					(*scalefac)[ch].s[window][sfb] = hgetbits(
						slen[1][gr_info->scalefac_compress]);
			for (sfb=12,window=0; window<3; window++)
    7a95:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    7a99:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
    7a9d:	7e c4                	jle    7a63 <III_get_scale_factors+0x18d>
{
	int sfb, i, window;
	struct gr_info_s *gr_info = &(si->ch[ch].gr[gr]);

	if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
		if (gr_info->mixed_block_flag) { /* MIXED */ /* NEW - ag 11/25 */
    7a9f:	e9 b1 01 00 00       	jmp    7c55 <III_get_scale_factors+0x37f>
						slen[1][gr_info->scalefac_compress]);
			for (sfb=12,window=0; window<3; window++)
				(*scalefac)[ch].s[window][sfb] = 0;
		}
		else {  /* SHORT*/
			for (i=0; i<2; i++)
    7aa4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    7aab:	e9 8f 00 00 00       	jmp    7b3f <III_get_scale_factors+0x269>
				for (sfb = sfbtable.s[i]; sfb < sfbtable.s[i+1]; sfb++)
    7ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7ab3:	83 c0 04             	add    $0x4,%eax
    7ab6:	8b 04 85 e4 e8 00 00 	mov    0xe8e4(,%eax,4),%eax
    7abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    7ac0:	eb 64                	jmp    7b26 <III_get_scale_factors+0x250>
					for (window=0; window<3; window++)
    7ac2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    7ac9:	eb 51                	jmp    7b1c <III_get_scale_factors+0x246>
						(*scalefac)[ch].s[window][sfb] = hgetbits(
							slen[i][gr_info->scalefac_compress]);
    7acb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    7ace:	8b 40 0c             	mov    0xc(%eax),%eax
		}
		else {  /* SHORT*/
			for (i=0; i<2; i++)
				for (sfb = sfbtable.s[i]; sfb < sfbtable.s[i+1]; sfb++)
					for (window=0; window<3; window++)
						(*scalefac)[ch].s[window][sfb] = hgetbits(
    7ad1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    7ad4:	c1 e2 04             	shl    $0x4,%edx
    7ad7:	01 d0                	add    %edx,%eax
    7ad9:	8b 04 85 00 e9 00 00 	mov    0xe900(,%eax,4),%eax
    7ae0:	89 04 24             	mov    %eax,(%esp)
    7ae3:	e8 28 da ff ff       	call   5510 <hgetbits>
    7ae8:	89 c6                	mov    %eax,%esi
    7aea:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7aed:	8b 55 ec             	mov    -0x14(%ebp),%edx
    7af0:	8b 4d 14             	mov    0x14(%ebp),%ecx
    7af3:	89 d0                	mov    %edx,%eax
    7af5:	01 c0                	add    %eax,%eax
    7af7:	01 d0                	add    %edx,%eax
    7af9:	c1 e0 02             	shl    $0x2,%eax
    7afc:	01 d0                	add    %edx,%eax
    7afe:	89 ca                	mov    %ecx,%edx
    7b00:	01 d2                	add    %edx,%edx
    7b02:	89 d1                	mov    %edx,%ecx
    7b04:	c1 e1 05             	shl    $0x5,%ecx
    7b07:	29 d1                	sub    %edx,%ecx
    7b09:	8d 14 08             	lea    (%eax,%ecx,1),%edx
    7b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    7b0f:	01 d0                	add    %edx,%eax
    7b11:	83 c0 14             	add    $0x14,%eax
    7b14:	89 74 83 0c          	mov    %esi,0xc(%ebx,%eax,4)
				(*scalefac)[ch].s[window][sfb] = 0;
		}
		else {  /* SHORT*/
			for (i=0; i<2; i++)
				for (sfb = sfbtable.s[i]; sfb < sfbtable.s[i+1]; sfb++)
					for (window=0; window<3; window++)
    7b18:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    7b1c:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
    7b20:	7e a9                	jle    7acb <III_get_scale_factors+0x1f5>
			for (sfb=12,window=0; window<3; window++)
				(*scalefac)[ch].s[window][sfb] = 0;
		}
		else {  /* SHORT*/
			for (i=0; i<2; i++)
				for (sfb = sfbtable.s[i]; sfb < sfbtable.s[i+1]; sfb++)
    7b22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    7b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7b29:	83 c0 01             	add    $0x1,%eax
    7b2c:	83 c0 04             	add    $0x4,%eax
    7b2f:	8b 04 85 e4 e8 00 00 	mov    0xe8e4(,%eax,4),%eax
    7b36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    7b39:	7f 87                	jg     7ac2 <III_get_scale_factors+0x1ec>
						slen[1][gr_info->scalefac_compress]);
			for (sfb=12,window=0; window<3; window++)
				(*scalefac)[ch].s[window][sfb] = 0;
		}
		else {  /* SHORT*/
			for (i=0; i<2; i++)
    7b3b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    7b3f:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    7b43:	0f 8e 67 ff ff ff    	jle    7ab0 <III_get_scale_factors+0x1da>
				for (sfb = sfbtable.s[i]; sfb < sfbtable.s[i+1]; sfb++)
					for (window=0; window<3; window++)
						(*scalefac)[ch].s[window][sfb] = hgetbits(
							slen[i][gr_info->scalefac_compress]);
				for (sfb=12,window=0; window<3; window++)
    7b49:	c7 45 f4 0c 00 00 00 	movl   $0xc,-0xc(%ebp)
    7b50:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    7b57:	eb 36                	jmp    7b8f <III_get_scale_factors+0x2b9>
					(*scalefac)[ch].s[window][sfb] = 0;
    7b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7b5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    7b5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
    7b62:	89 d0                	mov    %edx,%eax
    7b64:	01 c0                	add    %eax,%eax
    7b66:	01 d0                	add    %edx,%eax
    7b68:	c1 e0 02             	shl    $0x2,%eax
    7b6b:	01 d0                	add    %edx,%eax
    7b6d:	89 ca                	mov    %ecx,%edx
    7b6f:	01 d2                	add    %edx,%edx
    7b71:	89 d1                	mov    %edx,%ecx
    7b73:	c1 e1 05             	shl    $0x5,%ecx
    7b76:	29 d1                	sub    %edx,%ecx
    7b78:	8d 14 08             	lea    (%eax,%ecx,1),%edx
    7b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    7b7e:	01 d0                	add    %edx,%eax
    7b80:	83 c0 14             	add    $0x14,%eax
    7b83:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
    7b8a:	00 
			for (i=0; i<2; i++)
				for (sfb = sfbtable.s[i]; sfb < sfbtable.s[i+1]; sfb++)
					for (window=0; window<3; window++)
						(*scalefac)[ch].s[window][sfb] = hgetbits(
							slen[i][gr_info->scalefac_compress]);
				for (sfb=12,window=0; window<3; window++)
    7b8b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    7b8f:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
    7b93:	7e c4                	jle    7b59 <III_get_scale_factors+0x283>
{
	int sfb, i, window;
	struct gr_info_s *gr_info = &(si->ch[ch].gr[gr]);

	if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
		if (gr_info->mixed_block_flag) { /* MIXED */ /* NEW - ag 11/25 */
    7b95:	e9 bb 00 00 00       	jmp    7c55 <III_get_scale_factors+0x37f>
				for (sfb=12,window=0; window<3; window++)
					(*scalefac)[ch].s[window][sfb] = 0;
		}
	}
	else {   /* LONG types 0,1,3 */
		for (i=0; i<4; i++) {
    7b9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    7ba1:	e9 89 00 00 00       	jmp    7c2f <III_get_scale_factors+0x359>
			if ((si->ch[ch].scfsi[i] == 0) || (gr == 0))
    7ba6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    7ba9:	8b 55 14             	mov    0x14(%ebp),%edx
    7bac:	89 d0                	mov    %edx,%eax
    7bae:	c1 e0 02             	shl    $0x2,%eax
    7bb1:	01 d0                	add    %edx,%eax
    7bb3:	c1 e0 03             	shl    $0x3,%eax
    7bb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
    7bb9:	01 d0                	add    %edx,%eax
    7bbb:	8b 44 81 08          	mov    0x8(%ecx,%eax,4),%eax
    7bbf:	85 c0                	test   %eax,%eax
    7bc1:	74 06                	je     7bc9 <III_get_scale_factors+0x2f3>
    7bc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    7bc7:	75 62                	jne    7c2b <III_get_scale_factors+0x355>
				for (sfb = sfbtable.l[i]; sfb < sfbtable.l[i+1]; sfb++)
    7bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7bcc:	8b 04 85 e0 e8 00 00 	mov    0xe8e0(,%eax,4),%eax
    7bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    7bd6:	eb 41                	jmp    7c19 <III_get_scale_factors+0x343>
					(*scalefac)[ch].l[sfb] = hgetbits(
						slen[(i<2)?0:1][gr_info->scalefac_compress]);
    7bd8:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    7bdc:	0f 9f c0             	setg   %al
    7bdf:	0f b6 d0             	movzbl %al,%edx
    7be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    7be5:	8b 40 0c             	mov    0xc(%eax),%eax
	}
	else {   /* LONG types 0,1,3 */
		for (i=0; i<4; i++) {
			if ((si->ch[ch].scfsi[i] == 0) || (gr == 0))
				for (sfb = sfbtable.l[i]; sfb < sfbtable.l[i+1]; sfb++)
					(*scalefac)[ch].l[sfb] = hgetbits(
    7be8:	c1 e2 04             	shl    $0x4,%edx
    7beb:	01 d0                	add    %edx,%eax
    7bed:	8b 04 85 00 e9 00 00 	mov    0xe900(,%eax,4),%eax
    7bf4:	89 04 24             	mov    %eax,(%esp)
    7bf7:	e8 14 d9 ff ff       	call   5510 <hgetbits>
    7bfc:	89 c3                	mov    %eax,%ebx
    7bfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
    7c01:	8b 45 14             	mov    0x14(%ebp),%eax
    7c04:	01 c0                	add    %eax,%eax
    7c06:	89 c2                	mov    %eax,%edx
    7c08:	c1 e2 05             	shl    $0x5,%edx
    7c0b:	29 c2                	sub    %eax,%edx
    7c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    7c10:	01 d0                	add    %edx,%eax
    7c12:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
		}
	}
	else {   /* LONG types 0,1,3 */
		for (i=0; i<4; i++) {
			if ((si->ch[ch].scfsi[i] == 0) || (gr == 0))
				for (sfb = sfbtable.l[i]; sfb < sfbtable.l[i+1]; sfb++)
    7c15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    7c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7c1c:	83 c0 01             	add    $0x1,%eax
    7c1f:	8b 04 85 e0 e8 00 00 	mov    0xe8e0(,%eax,4),%eax
    7c26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    7c29:	7f ad                	jg     7bd8 <III_get_scale_factors+0x302>
				for (sfb=12,window=0; window<3; window++)
					(*scalefac)[ch].s[window][sfb] = 0;
		}
	}
	else {   /* LONG types 0,1,3 */
		for (i=0; i<4; i++) {
    7c2b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    7c2f:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    7c33:	0f 8e 6d ff ff ff    	jle    7ba6 <III_get_scale_factors+0x2d0>
			if ((si->ch[ch].scfsi[i] == 0) || (gr == 0))
				for (sfb = sfbtable.l[i]; sfb < sfbtable.l[i+1]; sfb++)
					(*scalefac)[ch].l[sfb] = hgetbits(
						slen[(i<2)?0:1][gr_info->scalefac_compress]);
		}
		(*scalefac)[ch].l[22] = 0;
    7c39:	8b 4d 08             	mov    0x8(%ebp),%ecx
    7c3c:	8b 45 14             	mov    0x14(%ebp),%eax
    7c3f:	c1 e0 03             	shl    $0x3,%eax
    7c42:	89 c2                	mov    %eax,%edx
    7c44:	c1 e2 05             	shl    $0x5,%edx
    7c47:	29 c2                	sub    %eax,%edx
    7c49:	8d 04 11             	lea    (%ecx,%edx,1),%eax
    7c4c:	83 c0 58             	add    $0x58,%eax
    7c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
}
    7c55:	83 c4 20             	add    $0x20,%esp
    7c58:	5b                   	pop    %ebx
    7c59:	5e                   	pop    %esi
    7c5a:	5d                   	pop    %ebp
    7c5b:	c3                   	ret    

00007c5c <initialize_huffman>:
struct huffcodetab ht[HTN];
*/
int huffman_initialized = FALSE;

void initialize_huffman()
{
    7c5c:	55                   	push   %ebp
    7c5d:	89 e5                	mov    %esp,%ebp
    7c5f:	83 ec 08             	sub    $0x8,%esp
	if (huffman_initialized) return;
    7c62:	a1 20 ec 00 00       	mov    0xec20,%eax
    7c67:	85 c0                	test   %eax,%eax
    7c69:	74 02                	je     7c6d <initialize_huffman+0x11>
    7c6b:	eb 0f                	jmp    7c7c <initialize_huffman+0x20>
	read_decoder_table();
    7c6d:	e8 03 d9 ff ff       	call   5575 <read_decoder_table>
	huffman_initialized = TRUE;
    7c72:	c7 05 20 ec 00 00 01 	movl   $0x1,0xec20
    7c79:	00 00 00 
}
    7c7c:	c9                   	leave  
    7c7d:	c3                   	ret    

00007c7e <III_hufman_decode>:


void III_hufman_decode(long int is[SBLIMIT][SSLIMIT], struct III_side_info_t *si, int ch, int gr, int part2_start, struct frame_params *fr_ps)
{
    7c7e:	55                   	push   %ebp
    7c7f:	89 e5                	mov    %esp,%ebp
    7c81:	57                   	push   %edi
    7c82:	56                   	push   %esi
    7c83:	53                   	push   %ebx
    7c84:	83 ec 4c             	sub    $0x4c,%esp
   struct huffcodetab *h;
   int region1Start;
   int region2Start;
   //int bt = (*si).ch[ch].gr[gr].window_switching_flag && ((*si).ch[ch].gr[gr].block_type == 2);

   initialize_huffman();
    7c87:	e8 d0 ff ff ff       	call   7c5c <initialize_huffman>

   /* ��������߽� */

   if ( ((*si).ch[ch].gr[gr].window_switching_flag) &&
    7c8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    7c8f:	8b 45 14             	mov    0x14(%ebp),%eax
    7c92:	8b 4d 10             	mov    0x10(%ebp),%ecx
    7c95:	89 c2                	mov    %eax,%edx
    7c97:	c1 e2 03             	shl    $0x3,%edx
    7c9a:	01 c2                	add    %eax,%edx
    7c9c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7ca3:	89 c2                	mov    %eax,%edx
    7ca5:	89 c8                	mov    %ecx,%eax
    7ca7:	c1 e0 02             	shl    $0x2,%eax
    7caa:	01 c8                	add    %ecx,%eax
    7cac:	c1 e0 05             	shl    $0x5,%eax
    7caf:	01 d0                	add    %edx,%eax
    7cb1:	01 d8                	add    %ebx,%eax
    7cb3:	83 c0 28             	add    $0x28,%eax
    7cb6:	8b 00                	mov    (%eax),%eax
    7cb8:	85 c0                	test   %eax,%eax
    7cba:	74 44                	je     7d00 <III_hufman_decode+0x82>
        ((*si).ch[ch].gr[gr].block_type == 2) ) {
    7cbc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    7cbf:	8b 45 14             	mov    0x14(%ebp),%eax
    7cc2:	8b 4d 10             	mov    0x10(%ebp),%ecx
    7cc5:	89 c2                	mov    %eax,%edx
    7cc7:	c1 e2 03             	shl    $0x3,%edx
    7cca:	01 c2                	add    %eax,%edx
    7ccc:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7cd3:	89 c2                	mov    %eax,%edx
    7cd5:	89 c8                	mov    %ecx,%eax
    7cd7:	c1 e0 02             	shl    $0x2,%eax
    7cda:	01 c8                	add    %ecx,%eax
    7cdc:	c1 e0 05             	shl    $0x5,%eax
    7cdf:	01 d0                	add    %edx,%eax
    7ce1:	01 d8                	add    %ebx,%eax
    7ce3:	83 c0 2c             	add    $0x2c,%eax
    7ce6:	8b 00                	mov    (%eax),%eax

   initialize_huffman();

   /* ��������߽� */

   if ( ((*si).ch[ch].gr[gr].window_switching_flag) &&
    7ce8:	83 f8 02             	cmp    $0x2,%eax
    7ceb:	75 13                	jne    7d00 <III_hufman_decode+0x82>
        ((*si).ch[ch].gr[gr].block_type == 2) ) {

      /* Region2. */

      region1Start = 36;  /* sfb[9/3]*3=36 */
    7ced:	c7 45 dc 24 00 00 00 	movl   $0x24,-0x24(%ebp)
      region2Start = 576; /* No Region2 for short block case. */
    7cf4:	c7 45 d8 40 02 00 00 	movl   $0x240,-0x28(%ebp)
    7cfb:	e9 cc 00 00 00       	jmp    7dcc <III_hufman_decode+0x14e>
   }


   else {          /* ���ҳ�������µ�����߽�. */

      region1Start = sfBandIndex[fr_ps->header->sampling_frequency]
    7d00:	8b 45 1c             	mov    0x1c(%ebp),%eax
    7d03:	8b 00                	mov    (%eax),%eax
    7d05:	8b 48 10             	mov    0x10(%eax),%ecx
                           .l[(*si).ch[ch].gr[gr].region0_count + 1]; /* MI */
    7d08:	8b 75 0c             	mov    0xc(%ebp),%esi
    7d0b:	8b 45 14             	mov    0x14(%ebp),%eax
    7d0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
    7d11:	89 c2                	mov    %eax,%edx
    7d13:	c1 e2 03             	shl    $0x3,%edx
    7d16:	01 c2                	add    %eax,%edx
    7d18:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7d1f:	89 c2                	mov    %eax,%edx
    7d21:	89 d8                	mov    %ebx,%eax
    7d23:	c1 e0 02             	shl    $0x2,%eax
    7d26:	01 d8                	add    %ebx,%eax
    7d28:	c1 e0 05             	shl    $0x5,%eax
    7d2b:	01 d0                	add    %edx,%eax
    7d2d:	01 f0                	add    %esi,%eax
    7d2f:	83 c0 4c             	add    $0x4c,%eax
    7d32:	8b 00                	mov    (%eax),%eax
    7d34:	8d 50 01             	lea    0x1(%eax),%edx
   }


   else {          /* ���ҳ�������µ�����߽�. */

      region1Start = sfBandIndex[fr_ps->header->sampling_frequency]
    7d37:	89 c8                	mov    %ecx,%eax
    7d39:	c1 e0 03             	shl    $0x3,%eax
    7d3c:	01 c8                	add    %ecx,%eax
    7d3e:	c1 e0 02             	shl    $0x2,%eax
    7d41:	01 c8                	add    %ecx,%eax
    7d43:	01 d0                	add    %edx,%eax
    7d45:	8b 04 85 80 e9 00 00 	mov    0xe980(,%eax,4),%eax
    7d4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
                           .l[(*si).ch[ch].gr[gr].region0_count + 1]; /* MI */
      region2Start = sfBandIndex[fr_ps->header->sampling_frequency]
    7d4f:	8b 45 1c             	mov    0x1c(%ebp),%eax
    7d52:	8b 00                	mov    (%eax),%eax
    7d54:	8b 48 10             	mov    0x10(%eax),%ecx
                              .l[(*si).ch[ch].gr[gr].region0_count +
    7d57:	8b 75 0c             	mov    0xc(%ebp),%esi
    7d5a:	8b 45 14             	mov    0x14(%ebp),%eax
    7d5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
    7d60:	89 c2                	mov    %eax,%edx
    7d62:	c1 e2 03             	shl    $0x3,%edx
    7d65:	01 c2                	add    %eax,%edx
    7d67:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7d6e:	89 c2                	mov    %eax,%edx
    7d70:	89 d8                	mov    %ebx,%eax
    7d72:	c1 e0 02             	shl    $0x2,%eax
    7d75:	01 d8                	add    %ebx,%eax
    7d77:	c1 e0 05             	shl    $0x5,%eax
    7d7a:	01 d0                	add    %edx,%eax
    7d7c:	01 f0                	add    %esi,%eax
    7d7e:	83 c0 4c             	add    $0x4c,%eax
    7d81:	8b 30                	mov    (%eax),%esi
                              (*si).ch[ch].gr[gr].region1_count + 2]; /* MI */
    7d83:	8b 7d 0c             	mov    0xc(%ebp),%edi
    7d86:	8b 45 14             	mov    0x14(%ebp),%eax
    7d89:	8b 5d 10             	mov    0x10(%ebp),%ebx
    7d8c:	89 c2                	mov    %eax,%edx
    7d8e:	c1 e2 03             	shl    $0x3,%edx
    7d91:	01 c2                	add    %eax,%edx
    7d93:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7d9a:	89 c2                	mov    %eax,%edx
    7d9c:	89 d8                	mov    %ebx,%eax
    7d9e:	c1 e0 02             	shl    $0x2,%eax
    7da1:	01 d8                	add    %ebx,%eax
    7da3:	c1 e0 05             	shl    $0x5,%eax
    7da6:	01 d0                	add    %edx,%eax
    7da8:	01 f8                	add    %edi,%eax
    7daa:	83 c0 50             	add    $0x50,%eax
    7dad:	8b 00                	mov    (%eax),%eax
   else {          /* ���ҳ�������µ�����߽�. */

      region1Start = sfBandIndex[fr_ps->header->sampling_frequency]
                           .l[(*si).ch[ch].gr[gr].region0_count + 1]; /* MI */
      region2Start = sfBandIndex[fr_ps->header->sampling_frequency]
                              .l[(*si).ch[ch].gr[gr].region0_count +
    7daf:	01 f0                	add    %esi,%eax
                              (*si).ch[ch].gr[gr].region1_count + 2]; /* MI */
    7db1:	8d 50 02             	lea    0x2(%eax),%edx

   else {          /* ���ҳ�������µ�����߽�. */

      region1Start = sfBandIndex[fr_ps->header->sampling_frequency]
                           .l[(*si).ch[ch].gr[gr].region0_count + 1]; /* MI */
      region2Start = sfBandIndex[fr_ps->header->sampling_frequency]
    7db4:	89 c8                	mov    %ecx,%eax
    7db6:	c1 e0 03             	shl    $0x3,%eax
    7db9:	01 c8                	add    %ecx,%eax
    7dbb:	c1 e0 02             	shl    $0x2,%eax
    7dbe:	01 c8                	add    %ecx,%eax
    7dc0:	01 d0                	add    %edx,%eax
    7dc2:	8b 04 85 80 e9 00 00 	mov    0xe980(,%eax,4),%eax
    7dc9:	89 45 d8             	mov    %eax,-0x28(%ebp)
                              (*si).ch[ch].gr[gr].region1_count + 2]; /* MI */
      }


   /* ��ȡ��ֵ����Read bigvalues area. */
   for (i=0; i<(*si).ch[ch].gr[gr].big_values*2; i+=2) {
    7dcc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    7dd3:	e9 ac 01 00 00       	jmp    7f84 <III_hufman_decode+0x306>
      if      (i<region1Start) h = &ht[(*si).ch[ch].gr[gr].table_select[0]];
    7dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    7ddb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    7dde:	7d 43                	jge    7e23 <III_hufman_decode+0x1a5>
    7de0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    7de3:	8b 45 14             	mov    0x14(%ebp),%eax
    7de6:	8b 4d 10             	mov    0x10(%ebp),%ecx
    7de9:	89 c2                	mov    %eax,%edx
    7deb:	c1 e2 03             	shl    $0x3,%edx
    7dee:	01 c2                	add    %eax,%edx
    7df0:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7df7:	89 c2                	mov    %eax,%edx
    7df9:	89 c8                	mov    %ecx,%eax
    7dfb:	c1 e0 02             	shl    $0x2,%eax
    7dfe:	01 c8                	add    %ecx,%eax
    7e00:	c1 e0 05             	shl    $0x5,%eax
    7e03:	01 d0                	add    %edx,%eax
    7e05:	01 d8                	add    %ebx,%eax
    7e07:	83 c0 34             	add    $0x34,%eax
    7e0a:	8b 10                	mov    (%eax),%edx
    7e0c:	89 d0                	mov    %edx,%eax
    7e0e:	c1 e0 02             	shl    $0x2,%eax
    7e11:	01 d0                	add    %edx,%eax
    7e13:	c1 e0 03             	shl    $0x3,%eax
    7e16:	05 00 1e 01 00       	add    $0x11e00,%eax
    7e1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    7e1e:	e9 86 00 00 00       	jmp    7ea9 <III_hufman_decode+0x22b>
      else if (i<region2Start) h = &ht[(*si).ch[ch].gr[gr].table_select[1]];
    7e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    7e26:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    7e29:	7d 40                	jge    7e6b <III_hufman_decode+0x1ed>
    7e2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    7e2e:	8b 45 14             	mov    0x14(%ebp),%eax
    7e31:	8b 4d 10             	mov    0x10(%ebp),%ecx
    7e34:	89 c2                	mov    %eax,%edx
    7e36:	c1 e2 03             	shl    $0x3,%edx
    7e39:	01 c2                	add    %eax,%edx
    7e3b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7e42:	89 c2                	mov    %eax,%edx
    7e44:	89 c8                	mov    %ecx,%eax
    7e46:	c1 e0 02             	shl    $0x2,%eax
    7e49:	01 c8                	add    %ecx,%eax
    7e4b:	c1 e0 05             	shl    $0x5,%eax
    7e4e:	01 d0                	add    %edx,%eax
    7e50:	01 d8                	add    %ebx,%eax
    7e52:	83 c0 38             	add    $0x38,%eax
    7e55:	8b 10                	mov    (%eax),%edx
    7e57:	89 d0                	mov    %edx,%eax
    7e59:	c1 e0 02             	shl    $0x2,%eax
    7e5c:	01 d0                	add    %edx,%eax
    7e5e:	c1 e0 03             	shl    $0x3,%eax
    7e61:	05 00 1e 01 00       	add    $0x11e00,%eax
    7e66:	89 45 e0             	mov    %eax,-0x20(%ebp)
    7e69:	eb 3e                	jmp    7ea9 <III_hufman_decode+0x22b>
           else                h = &ht[(*si).ch[ch].gr[gr].table_select[2]];
    7e6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    7e6e:	8b 45 14             	mov    0x14(%ebp),%eax
    7e71:	8b 4d 10             	mov    0x10(%ebp),%ecx
    7e74:	89 c2                	mov    %eax,%edx
    7e76:	c1 e2 03             	shl    $0x3,%edx
    7e79:	01 c2                	add    %eax,%edx
    7e7b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7e82:	89 c2                	mov    %eax,%edx
    7e84:	89 c8                	mov    %ecx,%eax
    7e86:	c1 e0 02             	shl    $0x2,%eax
    7e89:	01 c8                	add    %ecx,%eax
    7e8b:	c1 e0 05             	shl    $0x5,%eax
    7e8e:	01 d0                	add    %edx,%eax
    7e90:	01 d8                	add    %ebx,%eax
    7e92:	83 c0 3c             	add    $0x3c,%eax
    7e95:	8b 10                	mov    (%eax),%edx
    7e97:	89 d0                	mov    %edx,%eax
    7e99:	c1 e0 02             	shl    $0x2,%eax
    7e9c:	01 d0                	add    %edx,%eax
    7e9e:	c1 e0 03             	shl    $0x3,%eax
    7ea1:	05 00 1e 01 00       	add    $0x11e00,%eax
    7ea6:	89 45 e0             	mov    %eax,-0x20(%ebp)
      huffman_decoder(h, &x, &y, &v, &w);
    7ea9:	8d 45 c8             	lea    -0x38(%ebp),%eax
    7eac:	89 44 24 10          	mov    %eax,0x10(%esp)
    7eb0:	8d 45 cc             	lea    -0x34(%ebp),%eax
    7eb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
    7eb7:	8d 45 d0             	lea    -0x30(%ebp),%eax
    7eba:	89 44 24 08          	mov    %eax,0x8(%esp)
    7ebe:	8d 45 d4             	lea    -0x2c(%ebp),%eax
    7ec1:	89 44 24 04          	mov    %eax,0x4(%esp)
    7ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
    7ec8:	89 04 24             	mov    %eax,(%esp)
    7ecb:	e8 fd ee ff ff       	call   6dcd <huffman_decoder>
      is[i/SSLIMIT][i%SSLIMIT] = x;
    7ed0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    7ed3:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    7ed8:	89 c8                	mov    %ecx,%eax
    7eda:	f7 ea                	imul   %edx
    7edc:	c1 fa 02             	sar    $0x2,%edx
    7edf:	89 c8                	mov    %ecx,%eax
    7ee1:	c1 f8 1f             	sar    $0x1f,%eax
    7ee4:	29 c2                	sub    %eax,%edx
    7ee6:	89 d0                	mov    %edx,%eax
    7ee8:	89 c2                	mov    %eax,%edx
    7eea:	89 d0                	mov    %edx,%eax
    7eec:	c1 e0 03             	shl    $0x3,%eax
    7eef:	01 d0                	add    %edx,%eax
    7ef1:	c1 e0 03             	shl    $0x3,%eax
    7ef4:	89 c2                	mov    %eax,%edx
    7ef6:	8b 45 08             	mov    0x8(%ebp),%eax
    7ef9:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    7efc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    7eff:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    7f04:	89 c8                	mov    %ecx,%eax
    7f06:	f7 ea                	imul   %edx
    7f08:	c1 fa 02             	sar    $0x2,%edx
    7f0b:	89 c8                	mov    %ecx,%eax
    7f0d:	c1 f8 1f             	sar    $0x1f,%eax
    7f10:	29 c2                	sub    %eax,%edx
    7f12:	89 d0                	mov    %edx,%eax
    7f14:	c1 e0 03             	shl    $0x3,%eax
    7f17:	01 d0                	add    %edx,%eax
    7f19:	01 c0                	add    %eax,%eax
    7f1b:	29 c1                	sub    %eax,%ecx
    7f1d:	89 ca                	mov    %ecx,%edx
    7f1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    7f22:	89 04 93             	mov    %eax,(%ebx,%edx,4)
      is[(i+1)/SSLIMIT][(i+1)%SSLIMIT] = y;
    7f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    7f28:	8d 48 01             	lea    0x1(%eax),%ecx
    7f2b:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    7f30:	89 c8                	mov    %ecx,%eax
    7f32:	f7 ea                	imul   %edx
    7f34:	c1 fa 02             	sar    $0x2,%edx
    7f37:	89 c8                	mov    %ecx,%eax
    7f39:	c1 f8 1f             	sar    $0x1f,%eax
    7f3c:	29 c2                	sub    %eax,%edx
    7f3e:	89 d0                	mov    %edx,%eax
    7f40:	89 c2                	mov    %eax,%edx
    7f42:	89 d0                	mov    %edx,%eax
    7f44:	c1 e0 03             	shl    $0x3,%eax
    7f47:	01 d0                	add    %edx,%eax
    7f49:	c1 e0 03             	shl    $0x3,%eax
    7f4c:	89 c2                	mov    %eax,%edx
    7f4e:	8b 45 08             	mov    0x8(%ebp),%eax
    7f51:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    7f54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    7f57:	8d 48 01             	lea    0x1(%eax),%ecx
    7f5a:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    7f5f:	89 c8                	mov    %ecx,%eax
    7f61:	f7 ea                	imul   %edx
    7f63:	c1 fa 02             	sar    $0x2,%edx
    7f66:	89 c8                	mov    %ecx,%eax
    7f68:	c1 f8 1f             	sar    $0x1f,%eax
    7f6b:	29 c2                	sub    %eax,%edx
    7f6d:	89 d0                	mov    %edx,%eax
    7f6f:	c1 e0 03             	shl    $0x3,%eax
    7f72:	01 d0                	add    %edx,%eax
    7f74:	01 c0                	add    %eax,%eax
    7f76:	29 c1                	sub    %eax,%ecx
    7f78:	89 ca                	mov    %ecx,%edx
    7f7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    7f7d:	89 04 93             	mov    %eax,(%ebx,%edx,4)
                              (*si).ch[ch].gr[gr].region1_count + 2]; /* MI */
      }


   /* ��ȡ��ֵ����Read bigvalues area. */
   for (i=0; i<(*si).ch[ch].gr[gr].big_values*2; i+=2) {
    7f80:	83 45 e4 02          	addl   $0x2,-0x1c(%ebp)
    7f84:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    7f87:	8b 75 0c             	mov    0xc(%ebp),%esi
    7f8a:	8b 45 14             	mov    0x14(%ebp),%eax
    7f8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
    7f90:	89 c2                	mov    %eax,%edx
    7f92:	c1 e2 03             	shl    $0x3,%edx
    7f95:	01 c2                	add    %eax,%edx
    7f97:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7f9e:	89 c2                	mov    %eax,%edx
    7fa0:	89 c8                	mov    %ecx,%eax
    7fa2:	c1 e0 02             	shl    $0x2,%eax
    7fa5:	01 c8                	add    %ecx,%eax
    7fa7:	c1 e0 05             	shl    $0x5,%eax
    7faa:	01 d0                	add    %edx,%eax
    7fac:	01 f0                	add    %esi,%eax
    7fae:	83 c0 1c             	add    $0x1c,%eax
    7fb1:	8b 00                	mov    (%eax),%eax
    7fb3:	01 c0                	add    %eax,%eax
    7fb5:	39 c3                	cmp    %eax,%ebx
    7fb7:	0f 82 1b fe ff ff    	jb     7dd8 <III_hufman_decode+0x15a>
      is[i/SSLIMIT][i%SSLIMIT] = x;
      is[(i+1)/SSLIMIT][(i+1)%SSLIMIT] = y;
      }

   /* Read count1 area. */
   h = &ht[(*si).ch[ch].gr[gr].count1table_select+32];
    7fbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    7fc0:	8b 45 14             	mov    0x14(%ebp),%eax
    7fc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
    7fc6:	89 c2                	mov    %eax,%edx
    7fc8:	c1 e2 03             	shl    $0x3,%edx
    7fcb:	01 c2                	add    %eax,%edx
    7fcd:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    7fd4:	89 c2                	mov    %eax,%edx
    7fd6:	89 c8                	mov    %ecx,%eax
    7fd8:	c1 e0 02             	shl    $0x2,%eax
    7fdb:	01 c8                	add    %ecx,%eax
    7fdd:	c1 e0 05             	shl    $0x5,%eax
    7fe0:	01 d0                	add    %edx,%eax
    7fe2:	01 d8                	add    %ebx,%eax
    7fe4:	83 c0 5c             	add    $0x5c,%eax
    7fe7:	8b 00                	mov    (%eax),%eax
    7fe9:	8d 50 20             	lea    0x20(%eax),%edx
    7fec:	89 d0                	mov    %edx,%eax
    7fee:	c1 e0 02             	shl    $0x2,%eax
    7ff1:	01 d0                	add    %edx,%eax
    7ff3:	c1 e0 03             	shl    $0x3,%eax
    7ff6:	05 00 1e 01 00       	add    $0x11e00,%eax
    7ffb:	89 45 e0             	mov    %eax,-0x20(%ebp)
   while ((hsstell() < part2_start + (*si).ch[ch].gr[gr].part2_3_length ) &&
    7ffe:	e9 91 01 00 00       	jmp    8194 <III_hufman_decode+0x516>
     ( i < SSLIMIT*SBLIMIT )) {
      huffman_decoder(h, &x, &y, &v, &w);
    8003:	8d 45 c8             	lea    -0x38(%ebp),%eax
    8006:	89 44 24 10          	mov    %eax,0x10(%esp)
    800a:	8d 45 cc             	lea    -0x34(%ebp),%eax
    800d:	89 44 24 0c          	mov    %eax,0xc(%esp)
    8011:	8d 45 d0             	lea    -0x30(%ebp),%eax
    8014:	89 44 24 08          	mov    %eax,0x8(%esp)
    8018:	8d 45 d4             	lea    -0x2c(%ebp),%eax
    801b:	89 44 24 04          	mov    %eax,0x4(%esp)
    801f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    8022:	89 04 24             	mov    %eax,(%esp)
    8025:	e8 a3 ed ff ff       	call   6dcd <huffman_decoder>
      is[i/SSLIMIT][i%SSLIMIT] = v;
    802a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    802d:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8032:	89 c8                	mov    %ecx,%eax
    8034:	f7 ea                	imul   %edx
    8036:	c1 fa 02             	sar    $0x2,%edx
    8039:	89 c8                	mov    %ecx,%eax
    803b:	c1 f8 1f             	sar    $0x1f,%eax
    803e:	29 c2                	sub    %eax,%edx
    8040:	89 d0                	mov    %edx,%eax
    8042:	89 c2                	mov    %eax,%edx
    8044:	89 d0                	mov    %edx,%eax
    8046:	c1 e0 03             	shl    $0x3,%eax
    8049:	01 d0                	add    %edx,%eax
    804b:	c1 e0 03             	shl    $0x3,%eax
    804e:	89 c2                	mov    %eax,%edx
    8050:	8b 45 08             	mov    0x8(%ebp),%eax
    8053:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    8056:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    8059:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    805e:	89 c8                	mov    %ecx,%eax
    8060:	f7 ea                	imul   %edx
    8062:	c1 fa 02             	sar    $0x2,%edx
    8065:	89 c8                	mov    %ecx,%eax
    8067:	c1 f8 1f             	sar    $0x1f,%eax
    806a:	29 c2                	sub    %eax,%edx
    806c:	89 d0                	mov    %edx,%eax
    806e:	c1 e0 03             	shl    $0x3,%eax
    8071:	01 d0                	add    %edx,%eax
    8073:	01 c0                	add    %eax,%eax
    8075:	29 c1                	sub    %eax,%ecx
    8077:	89 ca                	mov    %ecx,%edx
    8079:	8b 45 cc             	mov    -0x34(%ebp),%eax
    807c:	89 04 93             	mov    %eax,(%ebx,%edx,4)
      is[(i+1)/SSLIMIT][(i+1)%SSLIMIT] = w;
    807f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    8082:	8d 48 01             	lea    0x1(%eax),%ecx
    8085:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    808a:	89 c8                	mov    %ecx,%eax
    808c:	f7 ea                	imul   %edx
    808e:	c1 fa 02             	sar    $0x2,%edx
    8091:	89 c8                	mov    %ecx,%eax
    8093:	c1 f8 1f             	sar    $0x1f,%eax
    8096:	29 c2                	sub    %eax,%edx
    8098:	89 d0                	mov    %edx,%eax
    809a:	89 c2                	mov    %eax,%edx
    809c:	89 d0                	mov    %edx,%eax
    809e:	c1 e0 03             	shl    $0x3,%eax
    80a1:	01 d0                	add    %edx,%eax
    80a3:	c1 e0 03             	shl    $0x3,%eax
    80a6:	89 c2                	mov    %eax,%edx
    80a8:	8b 45 08             	mov    0x8(%ebp),%eax
    80ab:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    80ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    80b1:	8d 48 01             	lea    0x1(%eax),%ecx
    80b4:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    80b9:	89 c8                	mov    %ecx,%eax
    80bb:	f7 ea                	imul   %edx
    80bd:	c1 fa 02             	sar    $0x2,%edx
    80c0:	89 c8                	mov    %ecx,%eax
    80c2:	c1 f8 1f             	sar    $0x1f,%eax
    80c5:	29 c2                	sub    %eax,%edx
    80c7:	89 d0                	mov    %edx,%eax
    80c9:	c1 e0 03             	shl    $0x3,%eax
    80cc:	01 d0                	add    %edx,%eax
    80ce:	01 c0                	add    %eax,%eax
    80d0:	29 c1                	sub    %eax,%ecx
    80d2:	89 ca                	mov    %ecx,%edx
    80d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
    80d7:	89 04 93             	mov    %eax,(%ebx,%edx,4)
      is[(i+2)/SSLIMIT][(i+2)%SSLIMIT] = x;
    80da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    80dd:	8d 48 02             	lea    0x2(%eax),%ecx
    80e0:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    80e5:	89 c8                	mov    %ecx,%eax
    80e7:	f7 ea                	imul   %edx
    80e9:	c1 fa 02             	sar    $0x2,%edx
    80ec:	89 c8                	mov    %ecx,%eax
    80ee:	c1 f8 1f             	sar    $0x1f,%eax
    80f1:	29 c2                	sub    %eax,%edx
    80f3:	89 d0                	mov    %edx,%eax
    80f5:	89 c2                	mov    %eax,%edx
    80f7:	89 d0                	mov    %edx,%eax
    80f9:	c1 e0 03             	shl    $0x3,%eax
    80fc:	01 d0                	add    %edx,%eax
    80fe:	c1 e0 03             	shl    $0x3,%eax
    8101:	89 c2                	mov    %eax,%edx
    8103:	8b 45 08             	mov    0x8(%ebp),%eax
    8106:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    8109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    810c:	8d 48 02             	lea    0x2(%eax),%ecx
    810f:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8114:	89 c8                	mov    %ecx,%eax
    8116:	f7 ea                	imul   %edx
    8118:	c1 fa 02             	sar    $0x2,%edx
    811b:	89 c8                	mov    %ecx,%eax
    811d:	c1 f8 1f             	sar    $0x1f,%eax
    8120:	29 c2                	sub    %eax,%edx
    8122:	89 d0                	mov    %edx,%eax
    8124:	c1 e0 03             	shl    $0x3,%eax
    8127:	01 d0                	add    %edx,%eax
    8129:	01 c0                	add    %eax,%eax
    812b:	29 c1                	sub    %eax,%ecx
    812d:	89 ca                	mov    %ecx,%edx
    812f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    8132:	89 04 93             	mov    %eax,(%ebx,%edx,4)
      is[(i+3)/SSLIMIT][(i+3)%SSLIMIT] = y;
    8135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    8138:	8d 48 03             	lea    0x3(%eax),%ecx
    813b:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8140:	89 c8                	mov    %ecx,%eax
    8142:	f7 ea                	imul   %edx
    8144:	c1 fa 02             	sar    $0x2,%edx
    8147:	89 c8                	mov    %ecx,%eax
    8149:	c1 f8 1f             	sar    $0x1f,%eax
    814c:	29 c2                	sub    %eax,%edx
    814e:	89 d0                	mov    %edx,%eax
    8150:	89 c2                	mov    %eax,%edx
    8152:	89 d0                	mov    %edx,%eax
    8154:	c1 e0 03             	shl    $0x3,%eax
    8157:	01 d0                	add    %edx,%eax
    8159:	c1 e0 03             	shl    $0x3,%eax
    815c:	89 c2                	mov    %eax,%edx
    815e:	8b 45 08             	mov    0x8(%ebp),%eax
    8161:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    8164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    8167:	8d 48 03             	lea    0x3(%eax),%ecx
    816a:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    816f:	89 c8                	mov    %ecx,%eax
    8171:	f7 ea                	imul   %edx
    8173:	c1 fa 02             	sar    $0x2,%edx
    8176:	89 c8                	mov    %ecx,%eax
    8178:	c1 f8 1f             	sar    $0x1f,%eax
    817b:	29 c2                	sub    %eax,%edx
    817d:	89 d0                	mov    %edx,%eax
    817f:	c1 e0 03             	shl    $0x3,%eax
    8182:	01 d0                	add    %edx,%eax
    8184:	01 c0                	add    %eax,%eax
    8186:	29 c1                	sub    %eax,%ecx
    8188:	89 ca                	mov    %ecx,%edx
    818a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    818d:	89 04 93             	mov    %eax,(%ebx,%edx,4)
      i += 4;
    8190:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
      is[(i+1)/SSLIMIT][(i+1)%SSLIMIT] = y;
      }

   /* Read count1 area. */
   h = &ht[(*si).ch[ch].gr[gr].count1table_select+32];
   while ((hsstell() < part2_start + (*si).ch[ch].gr[gr].part2_3_length ) &&
    8194:	e8 5b d3 ff ff       	call   54f4 <hsstell>
    8199:	89 c3                	mov    %eax,%ebx
    819b:	8b 75 0c             	mov    0xc(%ebp),%esi
    819e:	8b 45 14             	mov    0x14(%ebp),%eax
    81a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
    81a4:	89 c2                	mov    %eax,%edx
    81a6:	c1 e2 03             	shl    $0x3,%edx
    81a9:	01 c2                	add    %eax,%edx
    81ab:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    81b2:	89 c2                	mov    %eax,%edx
    81b4:	89 c8                	mov    %ecx,%eax
    81b6:	c1 e0 02             	shl    $0x2,%eax
    81b9:	01 c8                	add    %ecx,%eax
    81bb:	c1 e0 05             	shl    $0x5,%eax
    81be:	01 d0                	add    %edx,%eax
    81c0:	01 f0                	add    %esi,%eax
    81c2:	83 c0 18             	add    $0x18,%eax
    81c5:	8b 10                	mov    (%eax),%edx
    81c7:	8b 45 18             	mov    0x18(%ebp),%eax
    81ca:	01 d0                	add    %edx,%eax
    81cc:	39 c3                	cmp    %eax,%ebx
    81ce:	73 0d                	jae    81dd <III_hufman_decode+0x55f>
    81d0:	81 7d e4 3f 02 00 00 	cmpl   $0x23f,-0x1c(%ebp)
    81d7:	0f 8e 26 fe ff ff    	jle    8003 <III_hufman_decode+0x385>
      is[(i+2)/SSLIMIT][(i+2)%SSLIMIT] = x;
      is[(i+3)/SSLIMIT][(i+3)%SSLIMIT] = y;
      i += 4;
      }

   if (hsstell() > part2_start + (*si).ch[ch].gr[gr].part2_3_length)
    81dd:	e8 12 d3 ff ff       	call   54f4 <hsstell>
    81e2:	89 c3                	mov    %eax,%ebx
    81e4:	8b 75 0c             	mov    0xc(%ebp),%esi
    81e7:	8b 45 14             	mov    0x14(%ebp),%eax
    81ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
    81ed:	89 c2                	mov    %eax,%edx
    81ef:	c1 e2 03             	shl    $0x3,%edx
    81f2:	01 c2                	add    %eax,%edx
    81f4:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    81fb:	89 c2                	mov    %eax,%edx
    81fd:	89 c8                	mov    %ecx,%eax
    81ff:	c1 e0 02             	shl    $0x2,%eax
    8202:	01 c8                	add    %ecx,%eax
    8204:	c1 e0 05             	shl    $0x5,%eax
    8207:	01 d0                	add    %edx,%eax
    8209:	01 f0                	add    %esi,%eax
    820b:	83 c0 18             	add    $0x18,%eax
    820e:	8b 10                	mov    (%eax),%edx
    8210:	8b 45 18             	mov    0x18(%ebp),%eax
    8213:	01 d0                	add    %edx,%eax
    8215:	39 c3                	cmp    %eax,%ebx
    8217:	76 48                	jbe    8261 <III_hufman_decode+0x5e3>
   {  i -=4;
    8219:	83 6d e4 04          	subl   $0x4,-0x1c(%ebp)
      rewindNbits(hsstell()-part2_start - (*si).ch[ch].gr[gr].part2_3_length);
    821d:	e8 d2 d2 ff ff       	call   54f4 <hsstell>
    8222:	8b 55 18             	mov    0x18(%ebp),%edx
    8225:	29 d0                	sub    %edx,%eax
    8227:	89 c6                	mov    %eax,%esi
    8229:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    822c:	8b 45 14             	mov    0x14(%ebp),%eax
    822f:	8b 4d 10             	mov    0x10(%ebp),%ecx
    8232:	89 c2                	mov    %eax,%edx
    8234:	c1 e2 03             	shl    $0x3,%edx
    8237:	01 c2                	add    %eax,%edx
    8239:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    8240:	89 c2                	mov    %eax,%edx
    8242:	89 c8                	mov    %ecx,%eax
    8244:	c1 e0 02             	shl    $0x2,%eax
    8247:	01 c8                	add    %ecx,%eax
    8249:	c1 e0 05             	shl    $0x5,%eax
    824c:	01 d0                	add    %edx,%eax
    824e:	01 d8                	add    %ebx,%eax
    8250:	83 c0 18             	add    $0x18,%eax
    8253:	8b 00                	mov    (%eax),%eax
    8255:	29 c6                	sub    %eax,%esi
    8257:	89 f0                	mov    %esi,%eax
    8259:	89 04 24             	mov    %eax,(%esp)
    825c:	e8 de d2 ff ff       	call   553f <rewindNbits>
   }

   /* Dismiss stuffing Bits */
   if ( hsstell() < part2_start + (*si).ch[ch].gr[gr].part2_3_length )
    8261:	e8 8e d2 ff ff       	call   54f4 <hsstell>
    8266:	89 c3                	mov    %eax,%ebx
    8268:	8b 75 0c             	mov    0xc(%ebp),%esi
    826b:	8b 45 14             	mov    0x14(%ebp),%eax
    826e:	8b 4d 10             	mov    0x10(%ebp),%ecx
    8271:	89 c2                	mov    %eax,%edx
    8273:	c1 e2 03             	shl    $0x3,%edx
    8276:	01 c2                	add    %eax,%edx
    8278:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    827f:	89 c2                	mov    %eax,%edx
    8281:	89 c8                	mov    %ecx,%eax
    8283:	c1 e0 02             	shl    $0x2,%eax
    8286:	01 c8                	add    %ecx,%eax
    8288:	c1 e0 05             	shl    $0x5,%eax
    828b:	01 d0                	add    %edx,%eax
    828d:	01 f0                	add    %esi,%eax
    828f:	83 c0 18             	add    $0x18,%eax
    8292:	8b 10                	mov    (%eax),%edx
    8294:	8b 45 18             	mov    0x18(%ebp),%eax
    8297:	01 d0                	add    %edx,%eax
    8299:	39 c3                	cmp    %eax,%ebx
    829b:	73 45                	jae    82e2 <III_hufman_decode+0x664>
      hgetbits( part2_start + (*si).ch[ch].gr[gr].part2_3_length - hsstell());
    829d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    82a0:	8b 45 14             	mov    0x14(%ebp),%eax
    82a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
    82a6:	89 c2                	mov    %eax,%edx
    82a8:	c1 e2 03             	shl    $0x3,%edx
    82ab:	01 c2                	add    %eax,%edx
    82ad:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    82b4:	89 c2                	mov    %eax,%edx
    82b6:	89 c8                	mov    %ecx,%eax
    82b8:	c1 e0 02             	shl    $0x2,%eax
    82bb:	01 c8                	add    %ecx,%eax
    82bd:	c1 e0 05             	shl    $0x5,%eax
    82c0:	01 d0                	add    %edx,%eax
    82c2:	01 d8                	add    %ebx,%eax
    82c4:	83 c0 18             	add    $0x18,%eax
    82c7:	8b 10                	mov    (%eax),%edx
    82c9:	8b 45 18             	mov    0x18(%ebp),%eax
    82cc:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    82cf:	e8 20 d2 ff ff       	call   54f4 <hsstell>
    82d4:	29 c3                	sub    %eax,%ebx
    82d6:	89 d8                	mov    %ebx,%eax
    82d8:	89 04 24             	mov    %eax,(%esp)
    82db:	e8 30 d2 ff ff       	call   5510 <hgetbits>

   /* Zero out rest. */
   for (; i<SSLIMIT*SBLIMIT; i++)
    82e0:	eb 5c                	jmp    833e <III_hufman_decode+0x6c0>
    82e2:	eb 5a                	jmp    833e <III_hufman_decode+0x6c0>
      is[i/SSLIMIT][i%SSLIMIT] = 0;
    82e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    82e7:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    82ec:	89 c8                	mov    %ecx,%eax
    82ee:	f7 ea                	imul   %edx
    82f0:	c1 fa 02             	sar    $0x2,%edx
    82f3:	89 c8                	mov    %ecx,%eax
    82f5:	c1 f8 1f             	sar    $0x1f,%eax
    82f8:	29 c2                	sub    %eax,%edx
    82fa:	89 d0                	mov    %edx,%eax
    82fc:	89 c2                	mov    %eax,%edx
    82fe:	89 d0                	mov    %edx,%eax
    8300:	c1 e0 03             	shl    $0x3,%eax
    8303:	01 d0                	add    %edx,%eax
    8305:	c1 e0 03             	shl    $0x3,%eax
    8308:	89 c2                	mov    %eax,%edx
    830a:	8b 45 08             	mov    0x8(%ebp),%eax
    830d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    8310:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    8313:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8318:	89 c8                	mov    %ecx,%eax
    831a:	f7 ea                	imul   %edx
    831c:	c1 fa 02             	sar    $0x2,%edx
    831f:	89 c8                	mov    %ecx,%eax
    8321:	c1 f8 1f             	sar    $0x1f,%eax
    8324:	29 c2                	sub    %eax,%edx
    8326:	89 d0                	mov    %edx,%eax
    8328:	c1 e0 03             	shl    $0x3,%eax
    832b:	01 d0                	add    %edx,%eax
    832d:	01 c0                	add    %eax,%eax
    832f:	29 c1                	sub    %eax,%ecx
    8331:	89 ca                	mov    %ecx,%edx
    8333:	c7 04 93 00 00 00 00 	movl   $0x0,(%ebx,%edx,4)
   /* Dismiss stuffing Bits */
   if ( hsstell() < part2_start + (*si).ch[ch].gr[gr].part2_3_length )
      hgetbits( part2_start + (*si).ch[ch].gr[gr].part2_3_length - hsstell());

   /* Zero out rest. */
   for (; i<SSLIMIT*SBLIMIT; i++)
    833a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    833e:	81 7d e4 3f 02 00 00 	cmpl   $0x23f,-0x1c(%ebp)
    8345:	7e 9d                	jle    82e4 <III_hufman_decode+0x666>
      is[i/SSLIMIT][i%SSLIMIT] = 0;
}
    8347:	83 c4 4c             	add    $0x4c,%esp
    834a:	5b                   	pop    %ebx
    834b:	5e                   	pop    %esi
    834c:	5f                   	pop    %edi
    834d:	5d                   	pop    %ebp
    834e:	c3                   	ret    

0000834f <III_dequantize_sample>:


int pretab[22] = {0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,2,2,3,3,3,2,0};

void III_dequantize_sample(long int is[SBLIMIT][SSLIMIT], double xr[SBLIMIT][SSLIMIT], III_scalefac_t *scalefac, struct gr_info_s *gr_info, int ch, struct frame_params *fr_ps)
{
    834f:	55                   	push   %ebp
    8350:	89 e5                	mov    %esp,%ebp
    8352:	56                   	push   %esi
    8353:	53                   	push   %ebx
    8354:	83 ec 50             	sub    $0x50,%esp
	int ss,sb,cb=0,sfreq=fr_ps->header->sampling_frequency;
    8357:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    835e:	8b 45 1c             	mov    0x1c(%ebp),%eax
    8361:	8b 00                	mov    (%eax),%eax
    8363:	8b 40 10             	mov    0x10(%eax),%eax
    8366:	89 45 dc             	mov    %eax,-0x24(%ebp)
	//int stereo = fr_ps->stereo;
	int next_cb_boundary, cb_begin, cb_width = 0, sign;
    8369:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

	/* choose correct scalefactor band per block type, initalize boundary */

	if (gr_info->window_switching_flag && (gr_info->block_type == 2) )
    8370:	8b 45 14             	mov    0x14(%ebp),%eax
    8373:	8b 40 10             	mov    0x10(%eax),%eax
    8376:	85 c0                	test   %eax,%eax
    8378:	74 61                	je     83db <III_dequantize_sample+0x8c>
    837a:	8b 45 14             	mov    0x14(%ebp),%eax
    837d:	8b 40 14             	mov    0x14(%eax),%eax
    8380:	83 f8 02             	cmp    $0x2,%eax
    8383:	75 56                	jne    83db <III_dequantize_sample+0x8c>
		if (gr_info->mixed_block_flag)
    8385:	8b 45 14             	mov    0x14(%ebp),%eax
    8388:	8b 40 18             	mov    0x18(%eax),%eax
    838b:	85 c0                	test   %eax,%eax
    838d:	74 15                	je     83a4 <III_dequantize_sample+0x55>
			next_cb_boundary=sfBandIndex[sfreq].l[1];  /* LONG blocks: 0,1,3 */
    838f:	8b 45 dc             	mov    -0x24(%ebp),%eax
    8392:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    8398:	05 84 e9 00 00       	add    $0xe984,%eax
    839d:	8b 00                	mov    (%eax),%eax
    839f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int next_cb_boundary, cb_begin, cb_width = 0, sign;

	/* choose correct scalefactor band per block type, initalize boundary */

	if (gr_info->window_switching_flag && (gr_info->block_type == 2) )
		if (gr_info->mixed_block_flag)
    83a2:	eb 4a                	jmp    83ee <III_dequantize_sample+0x9f>
			next_cb_boundary=sfBandIndex[sfreq].l[1];  /* LONG blocks: 0,1,3 */
		else {
			next_cb_boundary=sfBandIndex[sfreq].s[1]*3; /* pure SHORT block */
    83a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
    83a7:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    83ad:	05 d4 e9 00 00       	add    $0xe9d4,%eax
    83b2:	8b 50 0c             	mov    0xc(%eax),%edx
    83b5:	89 d0                	mov    %edx,%eax
    83b7:	01 c0                	add    %eax,%eax
    83b9:	01 d0                	add    %edx,%eax
    83bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			cb_width = sfBandIndex[sfreq].s[1];
    83be:	8b 45 dc             	mov    -0x24(%ebp),%eax
    83c1:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    83c7:	05 d4 e9 00 00       	add    $0xe9d4,%eax
    83cc:	8b 40 0c             	mov    0xc(%eax),%eax
    83cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			cb_begin = 0;
    83d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int next_cb_boundary, cb_begin, cb_width = 0, sign;

	/* choose correct scalefactor band per block type, initalize boundary */

	if (gr_info->window_switching_flag && (gr_info->block_type == 2) )
		if (gr_info->mixed_block_flag)
    83d9:	eb 13                	jmp    83ee <III_dequantize_sample+0x9f>
			next_cb_boundary=sfBandIndex[sfreq].s[1]*3; /* pure SHORT block */
			cb_width = sfBandIndex[sfreq].s[1];
			cb_begin = 0;
		}
	else
		next_cb_boundary=sfBandIndex[sfreq].l[1];  /* LONG blocks: 0,1,3 */
    83db:	8b 45 dc             	mov    -0x24(%ebp),%eax
    83de:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    83e4:	05 84 e9 00 00       	add    $0xe984,%eax
    83e9:	8b 00                	mov    (%eax),%eax
    83eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/* apply formula per block type */
	for (sb=0 ; sb < SBLIMIT ; sb++) {
    83ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    83f5:	e9 3d 06 00 00       	jmp    8a37 <III_dequantize_sample+0x6e8>
		for (ss=0 ; ss < SSLIMIT ; ss++) {
    83fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    8401:	e9 23 06 00 00       	jmp    8a29 <III_dequantize_sample+0x6da>
			if ( (sb*18)+ss == next_cb_boundary) { /* Adjust critical band boundary */
    8406:	8b 55 f0             	mov    -0x10(%ebp),%edx
    8409:	89 d0                	mov    %edx,%eax
    840b:	c1 e0 03             	shl    $0x3,%eax
    840e:	01 d0                	add    %edx,%eax
    8410:	01 c0                	add    %eax,%eax
    8412:	89 c2                	mov    %eax,%edx
    8414:	8b 45 f4             	mov    -0xc(%ebp),%eax
    8417:	01 d0                	add    %edx,%eax
    8419:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    841c:	0f 85 9e 02 00 00    	jne    86c0 <III_dequantize_sample+0x371>
				if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
    8422:	8b 45 14             	mov    0x14(%ebp),%eax
    8425:	8b 40 10             	mov    0x10(%eax),%eax
    8428:	85 c0                	test   %eax,%eax
    842a:	0f 84 6b 02 00 00    	je     869b <III_dequantize_sample+0x34c>
    8430:	8b 45 14             	mov    0x14(%ebp),%eax
    8433:	8b 40 14             	mov    0x14(%eax),%eax
    8436:	83 f8 02             	cmp    $0x2,%eax
    8439:	0f 85 5c 02 00 00    	jne    869b <III_dequantize_sample+0x34c>
					if (gr_info->mixed_block_flag) {
    843f:	8b 45 14             	mov    0x14(%ebp),%eax
    8442:	8b 40 18             	mov    0x18(%eax),%eax
    8445:	85 c0                	test   %eax,%eax
    8447:	0f 84 af 01 00 00    	je     85fc <III_dequantize_sample+0x2ad>
						if (((sb*18)+ss) == sfBandIndex[sfreq].l[8])  {
    844d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    8450:	89 d0                	mov    %edx,%eax
    8452:	c1 e0 03             	shl    $0x3,%eax
    8455:	01 d0                	add    %edx,%eax
    8457:	01 c0                	add    %eax,%eax
    8459:	89 c2                	mov    %eax,%edx
    845b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    845e:	01 c2                	add    %eax,%edx
    8460:	8b 45 dc             	mov    -0x24(%ebp),%eax
    8463:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    8469:	05 a0 e9 00 00       	add    $0xe9a0,%eax
    846e:	8b 00                	mov    (%eax),%eax
    8470:	39 c2                	cmp    %eax,%edx
    8472:	0f 85 93 00 00 00    	jne    850b <III_dequantize_sample+0x1bc>
							next_cb_boundary=sfBandIndex[sfreq].s[4]*3;
    8478:	8b 45 dc             	mov    -0x24(%ebp),%eax
    847b:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    8481:	05 e0 e9 00 00       	add    $0xe9e0,%eax
    8486:	8b 50 0c             	mov    0xc(%eax),%edx
    8489:	89 d0                	mov    %edx,%eax
    848b:	01 c0                	add    %eax,%eax
    848d:	01 d0                	add    %edx,%eax
    848f:	89 45 e8             	mov    %eax,-0x18(%ebp)
							cb = 3;
    8492:	c7 45 ec 03 00 00 00 	movl   $0x3,-0x14(%ebp)
							cb_width = sfBandIndex[sfreq].s[cb+1] -
    8499:	8b 45 ec             	mov    -0x14(%ebp),%eax
    849c:	8d 48 01             	lea    0x1(%eax),%ecx
    849f:	8b 55 dc             	mov    -0x24(%ebp),%edx
    84a2:	89 d0                	mov    %edx,%eax
    84a4:	c1 e0 03             	shl    $0x3,%eax
    84a7:	01 d0                	add    %edx,%eax
    84a9:	c1 e0 02             	shl    $0x2,%eax
    84ac:	01 d0                	add    %edx,%eax
    84ae:	01 c8                	add    %ecx,%eax
    84b0:	83 c0 14             	add    $0x14,%eax
    84b3:	8b 0c 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%ecx
										sfBandIndex[sfreq].s[cb];
    84ba:	8b 55 dc             	mov    -0x24(%ebp),%edx
    84bd:	89 d0                	mov    %edx,%eax
    84bf:	c1 e0 03             	shl    $0x3,%eax
    84c2:	01 d0                	add    %edx,%eax
    84c4:	c1 e0 02             	shl    $0x2,%eax
    84c7:	01 d0                	add    %edx,%eax
    84c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    84cc:	01 d0                	add    %edx,%eax
    84ce:	83 c0 14             	add    $0x14,%eax
    84d1:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
				if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
					if (gr_info->mixed_block_flag) {
						if (((sb*18)+ss) == sfBandIndex[sfreq].l[8])  {
							next_cb_boundary=sfBandIndex[sfreq].s[4]*3;
							cb = 3;
							cb_width = sfBandIndex[sfreq].s[cb+1] -
    84d8:	29 c1                	sub    %eax,%ecx
    84da:	89 c8                	mov    %ecx,%eax
    84dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
										sfBandIndex[sfreq].s[cb];
							cb_begin = sfBandIndex[sfreq].s[cb]*3;
    84df:	8b 55 dc             	mov    -0x24(%ebp),%edx
    84e2:	89 d0                	mov    %edx,%eax
    84e4:	c1 e0 03             	shl    $0x3,%eax
    84e7:	01 d0                	add    %edx,%eax
    84e9:	c1 e0 02             	shl    $0x2,%eax
    84ec:	01 d0                	add    %edx,%eax
    84ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
    84f1:	01 d0                	add    %edx,%eax
    84f3:	83 c0 14             	add    $0x14,%eax
    84f6:	8b 14 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%edx
    84fd:	89 d0                	mov    %edx,%eax
    84ff:	01 c0                	add    %eax,%eax
    8501:	01 d0                	add    %edx,%eax
    8503:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    8506:	e9 8e 01 00 00       	jmp    8699 <III_dequantize_sample+0x34a>
						}
						else if (((sb*18)+ss) < sfBandIndex[sfreq].l[8])
    850b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    850e:	89 d0                	mov    %edx,%eax
    8510:	c1 e0 03             	shl    $0x3,%eax
    8513:	01 d0                	add    %edx,%eax
    8515:	01 c0                	add    %eax,%eax
    8517:	89 c2                	mov    %eax,%edx
    8519:	8b 45 f4             	mov    -0xc(%ebp),%eax
    851c:	01 c2                	add    %eax,%edx
    851e:	8b 45 dc             	mov    -0x24(%ebp),%eax
    8521:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    8527:	05 a0 e9 00 00       	add    $0xe9a0,%eax
    852c:	8b 00                	mov    (%eax),%eax
    852e:	39 c2                	cmp    %eax,%edx
    8530:	7d 2a                	jge    855c <III_dequantize_sample+0x20d>
							next_cb_boundary = sfBandIndex[sfreq].l[(++cb)+1];
    8532:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    8536:	8b 45 ec             	mov    -0x14(%ebp),%eax
    8539:	8d 48 01             	lea    0x1(%eax),%ecx
    853c:	8b 55 dc             	mov    -0x24(%ebp),%edx
    853f:	89 d0                	mov    %edx,%eax
    8541:	c1 e0 03             	shl    $0x3,%eax
    8544:	01 d0                	add    %edx,%eax
    8546:	c1 e0 02             	shl    $0x2,%eax
    8549:	01 d0                	add    %edx,%eax
    854b:	01 c8                	add    %ecx,%eax
    854d:	8b 04 85 80 e9 00 00 	mov    0xe980(,%eax,4),%eax
    8554:	89 45 e8             	mov    %eax,-0x18(%ebp)
    8557:	e9 3d 01 00 00       	jmp    8699 <III_dequantize_sample+0x34a>
						else {
							next_cb_boundary = sfBandIndex[sfreq].s[(++cb)+1]*3;
    855c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    8560:	8b 45 ec             	mov    -0x14(%ebp),%eax
    8563:	8d 48 01             	lea    0x1(%eax),%ecx
    8566:	8b 55 dc             	mov    -0x24(%ebp),%edx
    8569:	89 d0                	mov    %edx,%eax
    856b:	c1 e0 03             	shl    $0x3,%eax
    856e:	01 d0                	add    %edx,%eax
    8570:	c1 e0 02             	shl    $0x2,%eax
    8573:	01 d0                	add    %edx,%eax
    8575:	01 c8                	add    %ecx,%eax
    8577:	83 c0 14             	add    $0x14,%eax
    857a:	8b 14 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%edx
    8581:	89 d0                	mov    %edx,%eax
    8583:	01 c0                	add    %eax,%eax
    8585:	01 d0                	add    %edx,%eax
    8587:	89 45 e8             	mov    %eax,-0x18(%ebp)
							cb_width = sfBandIndex[sfreq].s[cb+1] -
    858a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    858d:	8d 48 01             	lea    0x1(%eax),%ecx
    8590:	8b 55 dc             	mov    -0x24(%ebp),%edx
    8593:	89 d0                	mov    %edx,%eax
    8595:	c1 e0 03             	shl    $0x3,%eax
    8598:	01 d0                	add    %edx,%eax
    859a:	c1 e0 02             	shl    $0x2,%eax
    859d:	01 d0                	add    %edx,%eax
    859f:	01 c8                	add    %ecx,%eax
    85a1:	83 c0 14             	add    $0x14,%eax
    85a4:	8b 0c 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%ecx
										sfBandIndex[sfreq].s[cb];
    85ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
    85ae:	89 d0                	mov    %edx,%eax
    85b0:	c1 e0 03             	shl    $0x3,%eax
    85b3:	01 d0                	add    %edx,%eax
    85b5:	c1 e0 02             	shl    $0x2,%eax
    85b8:	01 d0                	add    %edx,%eax
    85ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
    85bd:	01 d0                	add    %edx,%eax
    85bf:	83 c0 14             	add    $0x14,%eax
    85c2:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
						}
						else if (((sb*18)+ss) < sfBandIndex[sfreq].l[8])
							next_cb_boundary = sfBandIndex[sfreq].l[(++cb)+1];
						else {
							next_cb_boundary = sfBandIndex[sfreq].s[(++cb)+1]*3;
							cb_width = sfBandIndex[sfreq].s[cb+1] -
    85c9:	29 c1                	sub    %eax,%ecx
    85cb:	89 c8                	mov    %ecx,%eax
    85cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
										sfBandIndex[sfreq].s[cb];
							cb_begin = sfBandIndex[sfreq].s[cb]*3;
    85d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    85d3:	89 d0                	mov    %edx,%eax
    85d5:	c1 e0 03             	shl    $0x3,%eax
    85d8:	01 d0                	add    %edx,%eax
    85da:	c1 e0 02             	shl    $0x2,%eax
    85dd:	01 d0                	add    %edx,%eax
    85df:	8b 55 ec             	mov    -0x14(%ebp),%edx
    85e2:	01 d0                	add    %edx,%eax
    85e4:	83 c0 14             	add    $0x14,%eax
    85e7:	8b 14 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%edx
    85ee:	89 d0                	mov    %edx,%eax
    85f0:	01 c0                	add    %eax,%eax
    85f2:	01 d0                	add    %edx,%eax
    85f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	/* apply formula per block type */
	for (sb=0 ; sb < SBLIMIT ; sb++) {
		for (ss=0 ; ss < SSLIMIT ; ss++) {
			if ( (sb*18)+ss == next_cb_boundary) { /* Adjust critical band boundary */
				if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
					if (gr_info->mixed_block_flag) {
    85f7:	e9 c4 00 00 00       	jmp    86c0 <III_dequantize_sample+0x371>
										sfBandIndex[sfreq].s[cb];
							cb_begin = sfBandIndex[sfreq].s[cb]*3;
						}
					}
					else {
						next_cb_boundary = sfBandIndex[sfreq].s[(++cb)+1]*3;
    85fc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    8600:	8b 45 ec             	mov    -0x14(%ebp),%eax
    8603:	8d 48 01             	lea    0x1(%eax),%ecx
    8606:	8b 55 dc             	mov    -0x24(%ebp),%edx
    8609:	89 d0                	mov    %edx,%eax
    860b:	c1 e0 03             	shl    $0x3,%eax
    860e:	01 d0                	add    %edx,%eax
    8610:	c1 e0 02             	shl    $0x2,%eax
    8613:	01 d0                	add    %edx,%eax
    8615:	01 c8                	add    %ecx,%eax
    8617:	83 c0 14             	add    $0x14,%eax
    861a:	8b 14 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%edx
    8621:	89 d0                	mov    %edx,%eax
    8623:	01 c0                	add    %eax,%eax
    8625:	01 d0                	add    %edx,%eax
    8627:	89 45 e8             	mov    %eax,-0x18(%ebp)
						cb_width = sfBandIndex[sfreq].s[cb+1] -
    862a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    862d:	8d 48 01             	lea    0x1(%eax),%ecx
    8630:	8b 55 dc             	mov    -0x24(%ebp),%edx
    8633:	89 d0                	mov    %edx,%eax
    8635:	c1 e0 03             	shl    $0x3,%eax
    8638:	01 d0                	add    %edx,%eax
    863a:	c1 e0 02             	shl    $0x2,%eax
    863d:	01 d0                	add    %edx,%eax
    863f:	01 c8                	add    %ecx,%eax
    8641:	83 c0 14             	add    $0x14,%eax
    8644:	8b 0c 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%ecx
									sfBandIndex[sfreq].s[cb];
    864b:	8b 55 dc             	mov    -0x24(%ebp),%edx
    864e:	89 d0                	mov    %edx,%eax
    8650:	c1 e0 03             	shl    $0x3,%eax
    8653:	01 d0                	add    %edx,%eax
    8655:	c1 e0 02             	shl    $0x2,%eax
    8658:	01 d0                	add    %edx,%eax
    865a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    865d:	01 d0                	add    %edx,%eax
    865f:	83 c0 14             	add    $0x14,%eax
    8662:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
							cb_begin = sfBandIndex[sfreq].s[cb]*3;
						}
					}
					else {
						next_cb_boundary = sfBandIndex[sfreq].s[(++cb)+1]*3;
						cb_width = sfBandIndex[sfreq].s[cb+1] -
    8669:	29 c1                	sub    %eax,%ecx
    866b:	89 c8                	mov    %ecx,%eax
    866d:	89 45 e0             	mov    %eax,-0x20(%ebp)
									sfBandIndex[sfreq].s[cb];
						cb_begin = sfBandIndex[sfreq].s[cb]*3;
    8670:	8b 55 dc             	mov    -0x24(%ebp),%edx
    8673:	89 d0                	mov    %edx,%eax
    8675:	c1 e0 03             	shl    $0x3,%eax
    8678:	01 d0                	add    %edx,%eax
    867a:	c1 e0 02             	shl    $0x2,%eax
    867d:	01 d0                	add    %edx,%eax
    867f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    8682:	01 d0                	add    %edx,%eax
    8684:	83 c0 14             	add    $0x14,%eax
    8687:	8b 14 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%edx
    868e:	89 d0                	mov    %edx,%eax
    8690:	01 c0                	add    %eax,%eax
    8692:	01 d0                	add    %edx,%eax
    8694:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	/* apply formula per block type */
	for (sb=0 ; sb < SBLIMIT ; sb++) {
		for (ss=0 ; ss < SSLIMIT ; ss++) {
			if ( (sb*18)+ss == next_cb_boundary) { /* Adjust critical band boundary */
				if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
					if (gr_info->mixed_block_flag) {
    8697:	eb 27                	jmp    86c0 <III_dequantize_sample+0x371>
    8699:	eb 25                	jmp    86c0 <III_dequantize_sample+0x371>
									sfBandIndex[sfreq].s[cb];
						cb_begin = sfBandIndex[sfreq].s[cb]*3;
					}
				}
	            else /* long blocks */
		           next_cb_boundary = sfBandIndex[sfreq].l[(++cb)+1];
    869b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    869f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    86a2:	8d 48 01             	lea    0x1(%eax),%ecx
    86a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
    86a8:	89 d0                	mov    %edx,%eax
    86aa:	c1 e0 03             	shl    $0x3,%eax
    86ad:	01 d0                	add    %edx,%eax
    86af:	c1 e0 02             	shl    $0x2,%eax
    86b2:	01 d0                	add    %edx,%eax
    86b4:	01 c8                	add    %ecx,%eax
    86b6:	8b 04 85 80 e9 00 00 	mov    0xe980(,%eax,4),%eax
    86bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}

			/* Compute overall (global) scaling. */
			xr[sb][ss] = pow( 2.0 , (0.25 * (gr_info->global_gain - 210.0)));
    86c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
    86c3:	89 d0                	mov    %edx,%eax
    86c5:	c1 e0 03             	shl    $0x3,%eax
    86c8:	01 d0                	add    %edx,%eax
    86ca:	c1 e0 04             	shl    $0x4,%eax
    86cd:	89 c2                	mov    %eax,%edx
    86cf:	8b 45 0c             	mov    0xc(%ebp),%eax
    86d2:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    86d5:	8b 45 14             	mov    0x14(%ebp),%eax
    86d8:	8b 40 08             	mov    0x8(%eax),%eax
    86db:	ba 00 00 00 00       	mov    $0x0,%edx
    86e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
    86e3:	89 55 cc             	mov    %edx,-0x34(%ebp)
    86e6:	df 6d c8             	fildll -0x38(%ebp)
    86e9:	dd 05 30 d6 00 00    	fldl   0xd630
    86ef:	de e9                	fsubrp %st,%st(1)
    86f1:	dd 05 38 d6 00 00    	fldl   0xd638
    86f7:	de c9                	fmulp  %st,%st(1)
    86f9:	dd 5c 24 08          	fstpl  0x8(%esp)
    86fd:	dd 05 40 d6 00 00    	fldl   0xd640
    8703:	dd 1c 24             	fstpl  (%esp)
    8706:	e8 0c c1 ff ff       	call   4817 <pow>
    870b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    870e:	dd 1c c3             	fstpl  (%ebx,%eax,8)

			/* Do long/short dependent scaling operations. */

			if (gr_info->window_switching_flag && (
    8711:	8b 45 14             	mov    0x14(%ebp),%eax
    8714:	8b 40 10             	mov    0x10(%eax),%eax
    8717:	85 c0                	test   %eax,%eax
    8719:	0f 84 86 01 00 00    	je     88a5 <III_dequantize_sample+0x556>
				((gr_info->block_type == 2) && (gr_info->mixed_block_flag == 0)) ||
    871f:	8b 45 14             	mov    0x14(%ebp),%eax
    8722:	8b 40 14             	mov    0x14(%eax),%eax
			/* Compute overall (global) scaling. */
			xr[sb][ss] = pow( 2.0 , (0.25 * (gr_info->global_gain - 210.0)));

			/* Do long/short dependent scaling operations. */

			if (gr_info->window_switching_flag && (
    8725:	83 f8 02             	cmp    $0x2,%eax
    8728:	75 0a                	jne    8734 <III_dequantize_sample+0x3e5>
				((gr_info->block_type == 2) && (gr_info->mixed_block_flag == 0)) ||
    872a:	8b 45 14             	mov    0x14(%ebp),%eax
    872d:	8b 40 18             	mov    0x18(%eax),%eax
    8730:	85 c0                	test   %eax,%eax
    8732:	74 27                	je     875b <III_dequantize_sample+0x40c>
				((gr_info->block_type == 2) && gr_info->mixed_block_flag && (sb >= 2)) )) {
    8734:	8b 45 14             	mov    0x14(%ebp),%eax
    8737:	8b 40 14             	mov    0x14(%eax),%eax
			xr[sb][ss] = pow( 2.0 , (0.25 * (gr_info->global_gain - 210.0)));

			/* Do long/short dependent scaling operations. */

			if (gr_info->window_switching_flag && (
				((gr_info->block_type == 2) && (gr_info->mixed_block_flag == 0)) ||
    873a:	83 f8 02             	cmp    $0x2,%eax
    873d:	0f 85 62 01 00 00    	jne    88a5 <III_dequantize_sample+0x556>
				((gr_info->block_type == 2) && gr_info->mixed_block_flag && (sb >= 2)) )) {
    8743:	8b 45 14             	mov    0x14(%ebp),%eax
    8746:	8b 40 18             	mov    0x18(%eax),%eax
    8749:	85 c0                	test   %eax,%eax
    874b:	0f 84 54 01 00 00    	je     88a5 <III_dequantize_sample+0x556>
    8751:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    8755:	0f 8e 4a 01 00 00    	jle    88a5 <III_dequantize_sample+0x556>

				xr[sb][ss] *= pow(2.0, 0.25 * -8.0 *
    875b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    875e:	89 d0                	mov    %edx,%eax
    8760:	c1 e0 03             	shl    $0x3,%eax
    8763:	01 d0                	add    %edx,%eax
    8765:	c1 e0 04             	shl    $0x4,%eax
    8768:	89 c2                	mov    %eax,%edx
    876a:	8b 45 0c             	mov    0xc(%ebp),%eax
    876d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    8770:	8b 55 f0             	mov    -0x10(%ebp),%edx
    8773:	89 d0                	mov    %edx,%eax
    8775:	c1 e0 03             	shl    $0x3,%eax
    8778:	01 d0                	add    %edx,%eax
    877a:	c1 e0 04             	shl    $0x4,%eax
    877d:	89 c2                	mov    %eax,%edx
    877f:	8b 45 0c             	mov    0xc(%ebp),%eax
    8782:	01 c2                	add    %eax,%edx
    8784:	8b 45 f4             	mov    -0xc(%ebp),%eax
    8787:	dd 04 c2             	fldl   (%edx,%eax,8)
    878a:	dd 5d c0             	fstpl  -0x40(%ebp)
						gr_info->subblock_gain[(((sb*18)+ss) - cb_begin)/cb_width]);
    878d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    8790:	89 d0                	mov    %edx,%eax
    8792:	c1 e0 03             	shl    $0x3,%eax
    8795:	01 d0                	add    %edx,%eax
    8797:	01 c0                	add    %eax,%eax
    8799:	89 c2                	mov    %eax,%edx
    879b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    879e:	01 d0                	add    %edx,%eax
    87a0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
    87a3:	99                   	cltd   
    87a4:	f7 7d e0             	idivl  -0x20(%ebp)
    87a7:	89 c2                	mov    %eax,%edx
    87a9:	8b 45 14             	mov    0x14(%ebp),%eax
    87ac:	83 c2 08             	add    $0x8,%edx
    87af:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax

			if (gr_info->window_switching_flag && (
				((gr_info->block_type == 2) && (gr_info->mixed_block_flag == 0)) ||
				((gr_info->block_type == 2) && gr_info->mixed_block_flag && (sb >= 2)) )) {

				xr[sb][ss] *= pow(2.0, 0.25 * -8.0 *
    87b3:	ba 00 00 00 00       	mov    $0x0,%edx
    87b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
    87bb:	89 55 cc             	mov    %edx,-0x34(%ebp)
    87be:	df 6d c8             	fildll -0x38(%ebp)
    87c1:	dd 05 48 d6 00 00    	fldl   0xd648
    87c7:	de c9                	fmulp  %st,%st(1)
    87c9:	dd 5c 24 08          	fstpl  0x8(%esp)
    87cd:	dd 05 40 d6 00 00    	fldl   0xd640
    87d3:	dd 1c 24             	fstpl  (%esp)
    87d6:	e8 3c c0 ff ff       	call   4817 <pow>
    87db:	dc 4d c0             	fmull  -0x40(%ebp)
    87de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    87e1:	dd 1c c3             	fstpl  (%ebx,%eax,8)
						gr_info->subblock_gain[(((sb*18)+ss) - cb_begin)/cb_width]);
				xr[sb][ss] *= pow(2.0, 0.25 * -2.0 * (1.0+gr_info->scalefac_scale)
    87e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
    87e7:	89 d0                	mov    %edx,%eax
    87e9:	c1 e0 03             	shl    $0x3,%eax
    87ec:	01 d0                	add    %edx,%eax
    87ee:	c1 e0 04             	shl    $0x4,%eax
    87f1:	89 c2                	mov    %eax,%edx
    87f3:	8b 45 0c             	mov    0xc(%ebp),%eax
    87f6:	8d 34 02             	lea    (%edx,%eax,1),%esi
    87f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
    87fc:	89 d0                	mov    %edx,%eax
    87fe:	c1 e0 03             	shl    $0x3,%eax
    8801:	01 d0                	add    %edx,%eax
    8803:	c1 e0 04             	shl    $0x4,%eax
    8806:	89 c2                	mov    %eax,%edx
    8808:	8b 45 0c             	mov    0xc(%ebp),%eax
    880b:	01 c2                	add    %eax,%edx
    880d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    8810:	dd 04 c2             	fldl   (%edx,%eax,8)
    8813:	dd 5d c0             	fstpl  -0x40(%ebp)
    8816:	8b 45 14             	mov    0x14(%ebp),%eax
    8819:	8b 40 40             	mov    0x40(%eax),%eax
    881c:	ba 00 00 00 00       	mov    $0x0,%edx
    8821:	89 45 c8             	mov    %eax,-0x38(%ebp)
    8824:	89 55 cc             	mov    %edx,-0x34(%ebp)
    8827:	df 6d c8             	fildll -0x38(%ebp)
    882a:	d9 e8                	fld1   
    882c:	de c1                	faddp  %st,%st(1)
    882e:	dd 05 50 d6 00 00    	fldl   0xd650
    8834:	de c9                	fmulp  %st,%st(1)
						* (*scalefac)[ch].s[(((sb*18)+ss) - cb_begin)/cb_width][cb]);
    8836:	8b 55 f0             	mov    -0x10(%ebp),%edx
    8839:	89 d0                	mov    %edx,%eax
    883b:	c1 e0 03             	shl    $0x3,%eax
    883e:	01 d0                	add    %edx,%eax
    8840:	01 c0                	add    %eax,%eax
    8842:	89 c2                	mov    %eax,%edx
    8844:	8b 45 f4             	mov    -0xc(%ebp),%eax
    8847:	01 d0                	add    %edx,%eax
    8849:	2b 45 e4             	sub    -0x1c(%ebp),%eax
    884c:	99                   	cltd   
    884d:	f7 7d e0             	idivl  -0x20(%ebp)
    8850:	89 c2                	mov    %eax,%edx
    8852:	8b 5d 10             	mov    0x10(%ebp),%ebx
    8855:	8b 4d 18             	mov    0x18(%ebp),%ecx
    8858:	89 d0                	mov    %edx,%eax
    885a:	01 c0                	add    %eax,%eax
    885c:	01 d0                	add    %edx,%eax
    885e:	c1 e0 02             	shl    $0x2,%eax
    8861:	01 d0                	add    %edx,%eax
    8863:	89 ca                	mov    %ecx,%edx
    8865:	01 d2                	add    %edx,%edx
    8867:	89 d1                	mov    %edx,%ecx
    8869:	c1 e1 05             	shl    $0x5,%ecx
    886c:	29 d1                	sub    %edx,%ecx
    886e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
    8871:	8b 45 ec             	mov    -0x14(%ebp),%eax
    8874:	01 d0                	add    %edx,%eax
    8876:	83 c0 14             	add    $0x14,%eax
    8879:	8b 44 83 0c          	mov    0xc(%ebx,%eax,4),%eax
				((gr_info->block_type == 2) && (gr_info->mixed_block_flag == 0)) ||
				((gr_info->block_type == 2) && gr_info->mixed_block_flag && (sb >= 2)) )) {

				xr[sb][ss] *= pow(2.0, 0.25 * -8.0 *
						gr_info->subblock_gain[(((sb*18)+ss) - cb_begin)/cb_width]);
				xr[sb][ss] *= pow(2.0, 0.25 * -2.0 * (1.0+gr_info->scalefac_scale)
    887d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    8880:	db 45 d4             	fildl  -0x2c(%ebp)
    8883:	de c9                	fmulp  %st,%st(1)
    8885:	dd 5c 24 08          	fstpl  0x8(%esp)
    8889:	dd 05 40 d6 00 00    	fldl   0xd640
    888f:	dd 1c 24             	fstpl  (%esp)
    8892:	e8 80 bf ff ff       	call   4817 <pow>
    8897:	dc 4d c0             	fmull  -0x40(%ebp)
    889a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    889d:	dd 1c c6             	fstpl  (%esi,%eax,8)
    88a0:	e9 ab 00 00 00       	jmp    8950 <III_dequantize_sample+0x601>
						* (*scalefac)[ch].s[(((sb*18)+ss) - cb_begin)/cb_width][cb]);
			}
			else {   /* LONG block types 0,1,3 & 1st 2 subbands of switched blocks */
				xr[sb][ss] *= pow(2.0, -0.5 * (1.0+gr_info->scalefac_scale)
    88a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
    88a8:	89 d0                	mov    %edx,%eax
    88aa:	c1 e0 03             	shl    $0x3,%eax
    88ad:	01 d0                	add    %edx,%eax
    88af:	c1 e0 04             	shl    $0x4,%eax
    88b2:	89 c2                	mov    %eax,%edx
    88b4:	8b 45 0c             	mov    0xc(%ebp),%eax
    88b7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    88ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
    88bd:	89 d0                	mov    %edx,%eax
    88bf:	c1 e0 03             	shl    $0x3,%eax
    88c2:	01 d0                	add    %edx,%eax
    88c4:	c1 e0 04             	shl    $0x4,%eax
    88c7:	89 c2                	mov    %eax,%edx
    88c9:	8b 45 0c             	mov    0xc(%ebp),%eax
    88cc:	01 c2                	add    %eax,%edx
    88ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    88d1:	dd 04 c2             	fldl   (%edx,%eax,8)
    88d4:	dd 5d c0             	fstpl  -0x40(%ebp)
    88d7:	8b 45 14             	mov    0x14(%ebp),%eax
    88da:	8b 40 40             	mov    0x40(%eax),%eax
    88dd:	ba 00 00 00 00       	mov    $0x0,%edx
    88e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    88e5:	89 55 cc             	mov    %edx,-0x34(%ebp)
    88e8:	df 6d c8             	fildll -0x38(%ebp)
    88eb:	d9 e8                	fld1   
    88ed:	de c1                	faddp  %st,%st(1)
    88ef:	dd 05 50 d6 00 00    	fldl   0xd650
    88f5:	de c9                	fmulp  %st,%st(1)
								* ((*scalefac)[ch].l[cb]
    88f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    88fa:	8b 45 18             	mov    0x18(%ebp),%eax
    88fd:	01 c0                	add    %eax,%eax
    88ff:	89 c2                	mov    %eax,%edx
    8901:	c1 e2 05             	shl    $0x5,%edx
    8904:	29 c2                	sub    %eax,%edx
    8906:	8b 45 ec             	mov    -0x14(%ebp),%eax
    8909:	01 d0                	add    %edx,%eax
    890b:	8b 04 81             	mov    (%ecx,%eax,4),%eax
								+ gr_info->preflag * pretab[cb]));
    890e:	89 c2                	mov    %eax,%edx
    8910:	8b 45 14             	mov    0x14(%ebp),%eax
    8913:	8b 48 3c             	mov    0x3c(%eax),%ecx
    8916:	8b 45 ec             	mov    -0x14(%ebp),%eax
    8919:	8b 04 85 40 eb 00 00 	mov    0xeb40(,%eax,4),%eax
    8920:	0f af c1             	imul   %ecx,%eax
    8923:	01 d0                	add    %edx,%eax
						gr_info->subblock_gain[(((sb*18)+ss) - cb_begin)/cb_width]);
				xr[sb][ss] *= pow(2.0, 0.25 * -2.0 * (1.0+gr_info->scalefac_scale)
						* (*scalefac)[ch].s[(((sb*18)+ss) - cb_begin)/cb_width][cb]);
			}
			else {   /* LONG block types 0,1,3 & 1st 2 subbands of switched blocks */
				xr[sb][ss] *= pow(2.0, -0.5 * (1.0+gr_info->scalefac_scale)
    8925:	ba 00 00 00 00       	mov    $0x0,%edx
    892a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    892d:	89 55 cc             	mov    %edx,-0x34(%ebp)
    8930:	df 6d c8             	fildll -0x38(%ebp)
    8933:	de c9                	fmulp  %st,%st(1)
    8935:	dd 5c 24 08          	fstpl  0x8(%esp)
    8939:	dd 05 40 d6 00 00    	fldl   0xd640
    893f:	dd 1c 24             	fstpl  (%esp)
    8942:	e8 d0 be ff ff       	call   4817 <pow>
    8947:	dc 4d c0             	fmull  -0x40(%ebp)
    894a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    894d:	dd 1c c3             	fstpl  (%ebx,%eax,8)
								+ gr_info->preflag * pretab[cb]));
			}

			/* Scale quantized value. */

			sign = (is[sb][ss]<0) ? 1 : 0;
    8950:	8b 55 f0             	mov    -0x10(%ebp),%edx
    8953:	89 d0                	mov    %edx,%eax
    8955:	c1 e0 03             	shl    $0x3,%eax
    8958:	01 d0                	add    %edx,%eax
    895a:	c1 e0 03             	shl    $0x3,%eax
    895d:	89 c2                	mov    %eax,%edx
    895f:	8b 45 08             	mov    0x8(%ebp),%eax
    8962:	01 c2                	add    %eax,%edx
    8964:	8b 45 f4             	mov    -0xc(%ebp),%eax
    8967:	8b 04 82             	mov    (%edx,%eax,4),%eax
    896a:	c1 e8 1f             	shr    $0x1f,%eax
    896d:	0f b6 c0             	movzbl %al,%eax
    8970:	89 45 d8             	mov    %eax,-0x28(%ebp)
			xr[sb][ss] *= pow( (double) abs(is[sb][ss]), ((double)4.0/3.0) );
    8973:	8b 55 f0             	mov    -0x10(%ebp),%edx
    8976:	89 d0                	mov    %edx,%eax
    8978:	c1 e0 03             	shl    $0x3,%eax
    897b:	01 d0                	add    %edx,%eax
    897d:	c1 e0 04             	shl    $0x4,%eax
    8980:	89 c2                	mov    %eax,%edx
    8982:	8b 45 0c             	mov    0xc(%ebp),%eax
    8985:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    8988:	8b 55 f0             	mov    -0x10(%ebp),%edx
    898b:	89 d0                	mov    %edx,%eax
    898d:	c1 e0 03             	shl    $0x3,%eax
    8990:	01 d0                	add    %edx,%eax
    8992:	c1 e0 04             	shl    $0x4,%eax
    8995:	89 c2                	mov    %eax,%edx
    8997:	8b 45 0c             	mov    0xc(%ebp),%eax
    899a:	01 c2                	add    %eax,%edx
    899c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    899f:	dd 04 c2             	fldl   (%edx,%eax,8)
    89a2:	dd 5d c0             	fstpl  -0x40(%ebp)
    89a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
    89a8:	89 d0                	mov    %edx,%eax
    89aa:	c1 e0 03             	shl    $0x3,%eax
    89ad:	01 d0                	add    %edx,%eax
    89af:	c1 e0 03             	shl    $0x3,%eax
    89b2:	89 c2                	mov    %eax,%edx
    89b4:	8b 45 08             	mov    0x8(%ebp),%eax
    89b7:	01 c2                	add    %eax,%edx
    89b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    89bc:	8b 04 82             	mov    (%edx,%eax,4),%eax
    89bf:	89 04 24             	mov    %eax,(%esp)
    89c2:	e8 47 bd ff ff       	call   470e <abs>
    89c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    89ca:	db 45 d4             	fildl  -0x2c(%ebp)
    89cd:	dd 05 58 d6 00 00    	fldl   0xd658
    89d3:	dd 5c 24 08          	fstpl  0x8(%esp)
    89d7:	dd 1c 24             	fstpl  (%esp)
    89da:	e8 38 be ff ff       	call   4817 <pow>
    89df:	dc 4d c0             	fmull  -0x40(%ebp)
    89e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    89e5:	dd 1c c3             	fstpl  (%ebx,%eax,8)
			if (sign) xr[sb][ss] = -xr[sb][ss];
    89e8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    89ec:	74 37                	je     8a25 <III_dequantize_sample+0x6d6>
    89ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
    89f1:	89 d0                	mov    %edx,%eax
    89f3:	c1 e0 03             	shl    $0x3,%eax
    89f6:	01 d0                	add    %edx,%eax
    89f8:	c1 e0 04             	shl    $0x4,%eax
    89fb:	89 c2                	mov    %eax,%edx
    89fd:	8b 45 0c             	mov    0xc(%ebp),%eax
    8a00:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    8a03:	8b 55 f0             	mov    -0x10(%ebp),%edx
    8a06:	89 d0                	mov    %edx,%eax
    8a08:	c1 e0 03             	shl    $0x3,%eax
    8a0b:	01 d0                	add    %edx,%eax
    8a0d:	c1 e0 04             	shl    $0x4,%eax
    8a10:	89 c2                	mov    %eax,%edx
    8a12:	8b 45 0c             	mov    0xc(%ebp),%eax
    8a15:	01 c2                	add    %eax,%edx
    8a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
    8a1a:	dd 04 c2             	fldl   (%edx,%eax,8)
    8a1d:	d9 e0                	fchs   
    8a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    8a22:	dd 1c c1             	fstpl  (%ecx,%eax,8)
	else
		next_cb_boundary=sfBandIndex[sfreq].l[1];  /* LONG blocks: 0,1,3 */

	/* apply formula per block type */
	for (sb=0 ; sb < SBLIMIT ; sb++) {
		for (ss=0 ; ss < SSLIMIT ; ss++) {
    8a25:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    8a29:	83 7d f4 11          	cmpl   $0x11,-0xc(%ebp)
    8a2d:	0f 8e d3 f9 ff ff    	jle    8406 <III_dequantize_sample+0xb7>
		}
	else
		next_cb_boundary=sfBandIndex[sfreq].l[1];  /* LONG blocks: 0,1,3 */

	/* apply formula per block type */
	for (sb=0 ; sb < SBLIMIT ; sb++) {
    8a33:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    8a37:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
    8a3b:	0f 8e b9 f9 ff ff    	jle    83fa <III_dequantize_sample+0xab>
			sign = (is[sb][ss]<0) ? 1 : 0;
			xr[sb][ss] *= pow( (double) abs(is[sb][ss]), ((double)4.0/3.0) );
			if (sign) xr[sb][ss] = -xr[sb][ss];
		}
	}
}
    8a41:	83 c4 50             	add    $0x50,%esp
    8a44:	5b                   	pop    %ebx
    8a45:	5e                   	pop    %esi
    8a46:	5d                   	pop    %ebp
    8a47:	c3                   	ret    

00008a48 <III_reorder>:


void III_reorder(double xr[SBLIMIT][SSLIMIT], double ro[SBLIMIT][SSLIMIT], struct gr_info_s *gr_info, struct frame_params *fr_ps)
{
    8a48:	55                   	push   %ebp
    8a49:	89 e5                	mov    %esp,%ebp
    8a4b:	57                   	push   %edi
    8a4c:	56                   	push   %esi
    8a4d:	53                   	push   %ebx
    8a4e:	83 ec 34             	sub    $0x34,%esp
   int sfreq=fr_ps->header->sampling_frequency;
    8a51:	8b 45 14             	mov    0x14(%ebp),%eax
    8a54:	8b 00                	mov    (%eax),%eax
    8a56:	8b 40 10             	mov    0x10(%eax),%eax
    8a59:	89 45 d0             	mov    %eax,-0x30(%ebp)
   int sfb, sfb_start, sfb_lines;
   int sb, ss, window, freq, src_line, des_line;

   for(sb=0;sb<SBLIMIT;sb++)
    8a5c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    8a63:	eb 33                	jmp    8a98 <III_reorder+0x50>
      for(ss=0;ss<SSLIMIT;ss++)
    8a65:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    8a6c:	eb 20                	jmp    8a8e <III_reorder+0x46>
         ro[sb][ss] = 0;
    8a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
    8a71:	89 d0                	mov    %edx,%eax
    8a73:	c1 e0 03             	shl    $0x3,%eax
    8a76:	01 d0                	add    %edx,%eax
    8a78:	c1 e0 04             	shl    $0x4,%eax
    8a7b:	89 c2                	mov    %eax,%edx
    8a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
    8a80:	01 c2                	add    %eax,%edx
    8a82:	8b 45 dc             	mov    -0x24(%ebp),%eax
    8a85:	d9 ee                	fldz   
    8a87:	dd 1c c2             	fstpl  (%edx,%eax,8)
   int sfreq=fr_ps->header->sampling_frequency;
   int sfb, sfb_start, sfb_lines;
   int sb, ss, window, freq, src_line, des_line;

   for(sb=0;sb<SBLIMIT;sb++)
      for(ss=0;ss<SSLIMIT;ss++)
    8a8a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
    8a8e:	83 7d dc 11          	cmpl   $0x11,-0x24(%ebp)
    8a92:	7e da                	jle    8a6e <III_reorder+0x26>
{
   int sfreq=fr_ps->header->sampling_frequency;
   int sfb, sfb_start, sfb_lines;
   int sb, ss, window, freq, src_line, des_line;

   for(sb=0;sb<SBLIMIT;sb++)
    8a94:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    8a98:	83 7d e0 1f          	cmpl   $0x1f,-0x20(%ebp)
    8a9c:	7e c7                	jle    8a65 <III_reorder+0x1d>
      for(ss=0;ss<SSLIMIT;ss++)
         ro[sb][ss] = 0;

   if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
    8a9e:	8b 45 10             	mov    0x10(%ebp),%eax
    8aa1:	8b 40 10             	mov    0x10(%eax),%eax
    8aa4:	85 c0                	test   %eax,%eax
    8aa6:	0f 84 af 03 00 00    	je     8e5b <III_reorder+0x413>
    8aac:	8b 45 10             	mov    0x10(%ebp),%eax
    8aaf:	8b 40 14             	mov    0x14(%eax),%eax
    8ab2:	83 f8 02             	cmp    $0x2,%eax
    8ab5:	0f 85 a0 03 00 00    	jne    8e5b <III_reorder+0x413>
      if (gr_info->mixed_block_flag) {
    8abb:	8b 45 10             	mov    0x10(%ebp),%eax
    8abe:	8b 40 18             	mov    0x18(%eax),%eax
    8ac1:	85 c0                	test   %eax,%eax
    8ac3:	0f 84 00 02 00 00    	je     8cc9 <III_reorder+0x281>
         for (sb=0 ; sb < 2 ; sb++)
    8ac9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    8ad0:	eb 4c                	jmp    8b1e <III_reorder+0xd6>
            for (ss=0 ; ss < SSLIMIT ; ss++) {
    8ad2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    8ad9:	eb 39                	jmp    8b14 <III_reorder+0xcc>
               ro[sb][ss] = xr[sb][ss];
    8adb:	8b 55 e0             	mov    -0x20(%ebp),%edx
    8ade:	89 d0                	mov    %edx,%eax
    8ae0:	c1 e0 03             	shl    $0x3,%eax
    8ae3:	01 d0                	add    %edx,%eax
    8ae5:	c1 e0 04             	shl    $0x4,%eax
    8ae8:	89 c2                	mov    %eax,%edx
    8aea:	8b 45 0c             	mov    0xc(%ebp),%eax
    8aed:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    8af0:	8b 55 e0             	mov    -0x20(%ebp),%edx
    8af3:	89 d0                	mov    %edx,%eax
    8af5:	c1 e0 03             	shl    $0x3,%eax
    8af8:	01 d0                	add    %edx,%eax
    8afa:	c1 e0 04             	shl    $0x4,%eax
    8afd:	89 c2                	mov    %eax,%edx
    8aff:	8b 45 08             	mov    0x8(%ebp),%eax
    8b02:	01 c2                	add    %eax,%edx
    8b04:	8b 45 dc             	mov    -0x24(%ebp),%eax
    8b07:	dd 04 c2             	fldl   (%edx,%eax,8)
    8b0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
    8b0d:	dd 1c c1             	fstpl  (%ecx,%eax,8)
         ro[sb][ss] = 0;

   if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
      if (gr_info->mixed_block_flag) {
         for (sb=0 ; sb < 2 ; sb++)
            for (ss=0 ; ss < SSLIMIT ; ss++) {
    8b10:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
    8b14:	83 7d dc 11          	cmpl   $0x11,-0x24(%ebp)
    8b18:	7e c1                	jle    8adb <III_reorder+0x93>
      for(ss=0;ss<SSLIMIT;ss++)
         ro[sb][ss] = 0;

   if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
      if (gr_info->mixed_block_flag) {
         for (sb=0 ; sb < 2 ; sb++)
    8b1a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    8b1e:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
    8b22:	7e ae                	jle    8ad2 <III_reorder+0x8a>
            for (ss=0 ; ss < SSLIMIT ; ss++) {
               ro[sb][ss] = xr[sb][ss];
            }
         for(sfb=3,sfb_start=sfBandIndex[sfreq].s[3],
    8b24:	c7 45 ec 03 00 00 00 	movl   $0x3,-0x14(%ebp)
    8b2b:	8b 45 d0             	mov    -0x30(%ebp),%eax
    8b2e:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    8b34:	05 dc e9 00 00       	add    $0xe9dc,%eax
    8b39:	8b 40 0c             	mov    0xc(%eax),%eax
    8b3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            sfb_lines=sfBandIndex[sfreq].s[4] - sfb_start;
    8b3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
    8b42:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    8b48:	05 e0 e9 00 00       	add    $0xe9e0,%eax
    8b4d:	8b 40 0c             	mov    0xc(%eax),%eax
    8b50:	2b 45 e8             	sub    -0x18(%ebp),%eax
    8b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if (gr_info->mixed_block_flag) {
         for (sb=0 ; sb < 2 ; sb++)
            for (ss=0 ; ss < SSLIMIT ; ss++) {
               ro[sb][ss] = xr[sb][ss];
            }
         for(sfb=3,sfb_start=sfBandIndex[sfreq].s[3],
    8b56:	e9 5f 01 00 00       	jmp    8cba <III_reorder+0x272>
            sfb_lines=sfBandIndex[sfreq].s[4] - sfb_start;
            sfb < 13; sfb++,sfb_start=sfBandIndex[sfreq].s[sfb],
            (sfb_lines=sfBandIndex[sfreq].s[sfb+1] - sfb_start))
               for(window=0; window<3; window++)
    8b5b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    8b62:	e9 fd 00 00 00       	jmp    8c64 <III_reorder+0x21c>
                  for(freq=0;freq<sfb_lines;freq++) {
    8b67:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    8b6e:	e9 e1 00 00 00       	jmp    8c54 <III_reorder+0x20c>
                     src_line = sfb_start*3 + window*sfb_lines + freq;
    8b73:	8b 55 e8             	mov    -0x18(%ebp),%edx
    8b76:	89 d0                	mov    %edx,%eax
    8b78:	01 c0                	add    %eax,%eax
    8b7a:	01 c2                	add    %eax,%edx
    8b7c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    8b7f:	0f af 45 e4          	imul   -0x1c(%ebp),%eax
    8b83:	01 c2                	add    %eax,%edx
    8b85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    8b88:	01 d0                	add    %edx,%eax
    8b8a:	89 45 cc             	mov    %eax,-0x34(%ebp)
                     des_line = (sfb_start*3) + window + (freq*3);
    8b8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
    8b90:	89 d0                	mov    %edx,%eax
    8b92:	01 c0                	add    %eax,%eax
    8b94:	01 c2                	add    %eax,%edx
    8b96:	8b 45 d8             	mov    -0x28(%ebp),%eax
    8b99:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    8b9c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    8b9f:	89 d0                	mov    %edx,%eax
    8ba1:	01 c0                	add    %eax,%eax
    8ba3:	01 d0                	add    %edx,%eax
    8ba5:	01 c8                	add    %ecx,%eax
    8ba7:	89 45 c8             	mov    %eax,-0x38(%ebp)
                     ro[des_line/SSLIMIT][des_line%SSLIMIT] =
    8baa:	8b 4d c8             	mov    -0x38(%ebp),%ecx
    8bad:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8bb2:	89 c8                	mov    %ecx,%eax
    8bb4:	f7 ea                	imul   %edx
    8bb6:	c1 fa 02             	sar    $0x2,%edx
    8bb9:	89 c8                	mov    %ecx,%eax
    8bbb:	c1 f8 1f             	sar    $0x1f,%eax
    8bbe:	29 c2                	sub    %eax,%edx
    8bc0:	89 d0                	mov    %edx,%eax
    8bc2:	89 c2                	mov    %eax,%edx
    8bc4:	89 d0                	mov    %edx,%eax
    8bc6:	c1 e0 03             	shl    $0x3,%eax
    8bc9:	01 d0                	add    %edx,%eax
    8bcb:	c1 e0 04             	shl    $0x4,%eax
    8bce:	89 c2                	mov    %eax,%edx
    8bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
    8bd3:	8d 34 02             	lea    (%edx,%eax,1),%esi
    8bd6:	8b 5d c8             	mov    -0x38(%ebp),%ebx
    8bd9:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8bde:	89 d8                	mov    %ebx,%eax
    8be0:	f7 ea                	imul   %edx
    8be2:	c1 fa 02             	sar    $0x2,%edx
    8be5:	89 d8                	mov    %ebx,%eax
    8be7:	c1 f8 1f             	sar    $0x1f,%eax
    8bea:	89 d1                	mov    %edx,%ecx
    8bec:	29 c1                	sub    %eax,%ecx
    8bee:	89 c8                	mov    %ecx,%eax
    8bf0:	c1 e0 03             	shl    $0x3,%eax
    8bf3:	01 c8                	add    %ecx,%eax
    8bf5:	01 c0                	add    %eax,%eax
    8bf7:	29 c3                	sub    %eax,%ebx
    8bf9:	89 d9                	mov    %ebx,%ecx
                                    xr[src_line/SSLIMIT][src_line%SSLIMIT];
    8bfb:	8b 5d cc             	mov    -0x34(%ebp),%ebx
    8bfe:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8c03:	89 d8                	mov    %ebx,%eax
    8c05:	f7 ea                	imul   %edx
    8c07:	c1 fa 02             	sar    $0x2,%edx
    8c0a:	89 d8                	mov    %ebx,%eax
    8c0c:	c1 f8 1f             	sar    $0x1f,%eax
    8c0f:	29 c2                	sub    %eax,%edx
    8c11:	89 d0                	mov    %edx,%eax
    8c13:	89 c2                	mov    %eax,%edx
    8c15:	89 d0                	mov    %edx,%eax
    8c17:	c1 e0 03             	shl    $0x3,%eax
    8c1a:	01 d0                	add    %edx,%eax
    8c1c:	c1 e0 04             	shl    $0x4,%eax
    8c1f:	89 c2                	mov    %eax,%edx
    8c21:	8b 45 08             	mov    0x8(%ebp),%eax
    8c24:	8d 3c 02             	lea    (%edx,%eax,1),%edi
    8c27:	8b 5d cc             	mov    -0x34(%ebp),%ebx
    8c2a:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8c2f:	89 d8                	mov    %ebx,%eax
    8c31:	f7 ea                	imul   %edx
    8c33:	c1 fa 02             	sar    $0x2,%edx
    8c36:	89 d8                	mov    %ebx,%eax
    8c38:	c1 f8 1f             	sar    $0x1f,%eax
    8c3b:	29 c2                	sub    %eax,%edx
    8c3d:	89 d0                	mov    %edx,%eax
    8c3f:	c1 e0 03             	shl    $0x3,%eax
    8c42:	01 d0                	add    %edx,%eax
    8c44:	01 c0                	add    %eax,%eax
    8c46:	29 c3                	sub    %eax,%ebx
    8c48:	89 da                	mov    %ebx,%edx
    8c4a:	dd 04 d7             	fldl   (%edi,%edx,8)
            (sfb_lines=sfBandIndex[sfreq].s[sfb+1] - sfb_start))
               for(window=0; window<3; window++)
                  for(freq=0;freq<sfb_lines;freq++) {
                     src_line = sfb_start*3 + window*sfb_lines + freq;
                     des_line = (sfb_start*3) + window + (freq*3);
                     ro[des_line/SSLIMIT][des_line%SSLIMIT] =
    8c4d:	dd 1c ce             	fstpl  (%esi,%ecx,8)
         for(sfb=3,sfb_start=sfBandIndex[sfreq].s[3],
            sfb_lines=sfBandIndex[sfreq].s[4] - sfb_start;
            sfb < 13; sfb++,sfb_start=sfBandIndex[sfreq].s[sfb],
            (sfb_lines=sfBandIndex[sfreq].s[sfb+1] - sfb_start))
               for(window=0; window<3; window++)
                  for(freq=0;freq<sfb_lines;freq++) {
    8c50:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
    8c54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    8c57:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
    8c5a:	0f 8c 13 ff ff ff    	jl     8b73 <III_reorder+0x12b>
            }
         for(sfb=3,sfb_start=sfBandIndex[sfreq].s[3],
            sfb_lines=sfBandIndex[sfreq].s[4] - sfb_start;
            sfb < 13; sfb++,sfb_start=sfBandIndex[sfreq].s[sfb],
            (sfb_lines=sfBandIndex[sfreq].s[sfb+1] - sfb_start))
               for(window=0; window<3; window++)
    8c60:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
    8c64:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
    8c68:	0f 8e f9 fe ff ff    	jle    8b67 <III_reorder+0x11f>
            for (ss=0 ; ss < SSLIMIT ; ss++) {
               ro[sb][ss] = xr[sb][ss];
            }
         for(sfb=3,sfb_start=sfBandIndex[sfreq].s[3],
            sfb_lines=sfBandIndex[sfreq].s[4] - sfb_start;
            sfb < 13; sfb++,sfb_start=sfBandIndex[sfreq].s[sfb],
    8c6e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    8c72:	8b 55 d0             	mov    -0x30(%ebp),%edx
    8c75:	89 d0                	mov    %edx,%eax
    8c77:	c1 e0 03             	shl    $0x3,%eax
    8c7a:	01 d0                	add    %edx,%eax
    8c7c:	c1 e0 02             	shl    $0x2,%eax
    8c7f:	01 d0                	add    %edx,%eax
    8c81:	8b 55 ec             	mov    -0x14(%ebp),%edx
    8c84:	01 d0                	add    %edx,%eax
    8c86:	83 c0 14             	add    $0x14,%eax
    8c89:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
    8c90:	89 45 e8             	mov    %eax,-0x18(%ebp)
            (sfb_lines=sfBandIndex[sfreq].s[sfb+1] - sfb_start))
    8c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
    8c96:	8d 48 01             	lea    0x1(%eax),%ecx
    8c99:	8b 55 d0             	mov    -0x30(%ebp),%edx
    8c9c:	89 d0                	mov    %edx,%eax
    8c9e:	c1 e0 03             	shl    $0x3,%eax
    8ca1:	01 d0                	add    %edx,%eax
    8ca3:	c1 e0 02             	shl    $0x2,%eax
    8ca6:	01 d0                	add    %edx,%eax
    8ca8:	01 c8                	add    %ecx,%eax
    8caa:	83 c0 14             	add    $0x14,%eax
    8cad:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
    8cb4:	2b 45 e8             	sub    -0x18(%ebp),%eax
    8cb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if (gr_info->mixed_block_flag) {
         for (sb=0 ; sb < 2 ; sb++)
            for (ss=0 ; ss < SSLIMIT ; ss++) {
               ro[sb][ss] = xr[sb][ss];
            }
         for(sfb=3,sfb_start=sfBandIndex[sfreq].s[3],
    8cba:	83 7d ec 0c          	cmpl   $0xc,-0x14(%ebp)
    8cbe:	0f 8e 97 fe ff ff    	jle    8b5b <III_reorder+0x113>
   for(sb=0;sb<SBLIMIT;sb++)
      for(ss=0;ss<SSLIMIT;ss++)
         ro[sb][ss] = 0;

   if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
      if (gr_info->mixed_block_flag) {
    8cc4:	e9 ed 01 00 00       	jmp    8eb6 <III_reorder+0x46e>
                     ro[des_line/SSLIMIT][des_line%SSLIMIT] =
                                    xr[src_line/SSLIMIT][src_line%SSLIMIT];
               }
      }
      else {
         for(sfb=0,sfb_start=0,sfb_lines=sfBandIndex[sfreq].s[1];
    8cc9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    8cd0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    8cd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
    8cda:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    8ce0:	05 d4 e9 00 00       	add    $0xe9d4,%eax
    8ce5:	8b 40 0c             	mov    0xc(%eax),%eax
    8ce8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    8ceb:	e9 5f 01 00 00       	jmp    8e4f <III_reorder+0x407>
            sfb < 13; sfb++,sfb_start=sfBandIndex[sfreq].s[sfb],
            (sfb_lines=sfBandIndex[sfreq].s[sfb+1] - sfb_start))
               for(window=0; window<3; window++)
    8cf0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    8cf7:	e9 fd 00 00 00       	jmp    8df9 <III_reorder+0x3b1>
                  for(freq=0;freq<sfb_lines;freq++) {
    8cfc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    8d03:	e9 e1 00 00 00       	jmp    8de9 <III_reorder+0x3a1>
                     src_line = sfb_start*3 + window*sfb_lines + freq;
    8d08:	8b 55 e8             	mov    -0x18(%ebp),%edx
    8d0b:	89 d0                	mov    %edx,%eax
    8d0d:	01 c0                	add    %eax,%eax
    8d0f:	01 c2                	add    %eax,%edx
    8d11:	8b 45 d8             	mov    -0x28(%ebp),%eax
    8d14:	0f af 45 e4          	imul   -0x1c(%ebp),%eax
    8d18:	01 c2                	add    %eax,%edx
    8d1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    8d1d:	01 d0                	add    %edx,%eax
    8d1f:	89 45 cc             	mov    %eax,-0x34(%ebp)
                     des_line = (sfb_start*3) + window + (freq*3);
    8d22:	8b 55 e8             	mov    -0x18(%ebp),%edx
    8d25:	89 d0                	mov    %edx,%eax
    8d27:	01 c0                	add    %eax,%eax
    8d29:	01 c2                	add    %eax,%edx
    8d2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    8d2e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    8d31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    8d34:	89 d0                	mov    %edx,%eax
    8d36:	01 c0                	add    %eax,%eax
    8d38:	01 d0                	add    %edx,%eax
    8d3a:	01 c8                	add    %ecx,%eax
    8d3c:	89 45 c8             	mov    %eax,-0x38(%ebp)
                     ro[des_line/SSLIMIT][des_line%SSLIMIT] =
    8d3f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
    8d42:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8d47:	89 c8                	mov    %ecx,%eax
    8d49:	f7 ea                	imul   %edx
    8d4b:	c1 fa 02             	sar    $0x2,%edx
    8d4e:	89 c8                	mov    %ecx,%eax
    8d50:	c1 f8 1f             	sar    $0x1f,%eax
    8d53:	29 c2                	sub    %eax,%edx
    8d55:	89 d0                	mov    %edx,%eax
    8d57:	89 c2                	mov    %eax,%edx
    8d59:	89 d0                	mov    %edx,%eax
    8d5b:	c1 e0 03             	shl    $0x3,%eax
    8d5e:	01 d0                	add    %edx,%eax
    8d60:	c1 e0 04             	shl    $0x4,%eax
    8d63:	89 c2                	mov    %eax,%edx
    8d65:	8b 45 0c             	mov    0xc(%ebp),%eax
    8d68:	8d 34 02             	lea    (%edx,%eax,1),%esi
    8d6b:	8b 5d c8             	mov    -0x38(%ebp),%ebx
    8d6e:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8d73:	89 d8                	mov    %ebx,%eax
    8d75:	f7 ea                	imul   %edx
    8d77:	c1 fa 02             	sar    $0x2,%edx
    8d7a:	89 d8                	mov    %ebx,%eax
    8d7c:	c1 f8 1f             	sar    $0x1f,%eax
    8d7f:	89 d1                	mov    %edx,%ecx
    8d81:	29 c1                	sub    %eax,%ecx
    8d83:	89 c8                	mov    %ecx,%eax
    8d85:	c1 e0 03             	shl    $0x3,%eax
    8d88:	01 c8                	add    %ecx,%eax
    8d8a:	01 c0                	add    %eax,%eax
    8d8c:	29 c3                	sub    %eax,%ebx
    8d8e:	89 d9                	mov    %ebx,%ecx
                       xr[src_line/SSLIMIT][src_line%SSLIMIT];
    8d90:	8b 5d cc             	mov    -0x34(%ebp),%ebx
    8d93:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8d98:	89 d8                	mov    %ebx,%eax
    8d9a:	f7 ea                	imul   %edx
    8d9c:	c1 fa 02             	sar    $0x2,%edx
    8d9f:	89 d8                	mov    %ebx,%eax
    8da1:	c1 f8 1f             	sar    $0x1f,%eax
    8da4:	29 c2                	sub    %eax,%edx
    8da6:	89 d0                	mov    %edx,%eax
    8da8:	89 c2                	mov    %eax,%edx
    8daa:	89 d0                	mov    %edx,%eax
    8dac:	c1 e0 03             	shl    $0x3,%eax
    8daf:	01 d0                	add    %edx,%eax
    8db1:	c1 e0 04             	shl    $0x4,%eax
    8db4:	89 c2                	mov    %eax,%edx
    8db6:	8b 45 08             	mov    0x8(%ebp),%eax
    8db9:	8d 3c 02             	lea    (%edx,%eax,1),%edi
    8dbc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
    8dbf:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    8dc4:	89 d8                	mov    %ebx,%eax
    8dc6:	f7 ea                	imul   %edx
    8dc8:	c1 fa 02             	sar    $0x2,%edx
    8dcb:	89 d8                	mov    %ebx,%eax
    8dcd:	c1 f8 1f             	sar    $0x1f,%eax
    8dd0:	29 c2                	sub    %eax,%edx
    8dd2:	89 d0                	mov    %edx,%eax
    8dd4:	c1 e0 03             	shl    $0x3,%eax
    8dd7:	01 d0                	add    %edx,%eax
    8dd9:	01 c0                	add    %eax,%eax
    8ddb:	29 c3                	sub    %eax,%ebx
    8ddd:	89 da                	mov    %ebx,%edx
    8ddf:	dd 04 d7             	fldl   (%edi,%edx,8)
            (sfb_lines=sfBandIndex[sfreq].s[sfb+1] - sfb_start))
               for(window=0; window<3; window++)
                  for(freq=0;freq<sfb_lines;freq++) {
                     src_line = sfb_start*3 + window*sfb_lines + freq;
                     des_line = (sfb_start*3) + window + (freq*3);
                     ro[des_line/SSLIMIT][des_line%SSLIMIT] =
    8de2:	dd 1c ce             	fstpl  (%esi,%ecx,8)
      else {
         for(sfb=0,sfb_start=0,sfb_lines=sfBandIndex[sfreq].s[1];
            sfb < 13; sfb++,sfb_start=sfBandIndex[sfreq].s[sfb],
            (sfb_lines=sfBandIndex[sfreq].s[sfb+1] - sfb_start))
               for(window=0; window<3; window++)
                  for(freq=0;freq<sfb_lines;freq++) {
    8de5:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
    8de9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    8dec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
    8def:	0f 8c 13 ff ff ff    	jl     8d08 <III_reorder+0x2c0>
      }
      else {
         for(sfb=0,sfb_start=0,sfb_lines=sfBandIndex[sfreq].s[1];
            sfb < 13; sfb++,sfb_start=sfBandIndex[sfreq].s[sfb],
            (sfb_lines=sfBandIndex[sfreq].s[sfb+1] - sfb_start))
               for(window=0; window<3; window++)
    8df5:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
    8df9:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
    8dfd:	0f 8e f9 fe ff ff    	jle    8cfc <III_reorder+0x2b4>
                                    xr[src_line/SSLIMIT][src_line%SSLIMIT];
               }
      }
      else {
         for(sfb=0,sfb_start=0,sfb_lines=sfBandIndex[sfreq].s[1];
            sfb < 13; sfb++,sfb_start=sfBandIndex[sfreq].s[sfb],
    8e03:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    8e07:	8b 55 d0             	mov    -0x30(%ebp),%edx
    8e0a:	89 d0                	mov    %edx,%eax
    8e0c:	c1 e0 03             	shl    $0x3,%eax
    8e0f:	01 d0                	add    %edx,%eax
    8e11:	c1 e0 02             	shl    $0x2,%eax
    8e14:	01 d0                	add    %edx,%eax
    8e16:	8b 55 ec             	mov    -0x14(%ebp),%edx
    8e19:	01 d0                	add    %edx,%eax
    8e1b:	83 c0 14             	add    $0x14,%eax
    8e1e:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
    8e25:	89 45 e8             	mov    %eax,-0x18(%ebp)
            (sfb_lines=sfBandIndex[sfreq].s[sfb+1] - sfb_start))
    8e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
    8e2b:	8d 48 01             	lea    0x1(%eax),%ecx
    8e2e:	8b 55 d0             	mov    -0x30(%ebp),%edx
    8e31:	89 d0                	mov    %edx,%eax
    8e33:	c1 e0 03             	shl    $0x3,%eax
    8e36:	01 d0                	add    %edx,%eax
    8e38:	c1 e0 02             	shl    $0x2,%eax
    8e3b:	01 d0                	add    %edx,%eax
    8e3d:	01 c8                	add    %ecx,%eax
    8e3f:	83 c0 14             	add    $0x14,%eax
    8e42:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
    8e49:	2b 45 e8             	sub    -0x18(%ebp),%eax
    8e4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                     ro[des_line/SSLIMIT][des_line%SSLIMIT] =
                                    xr[src_line/SSLIMIT][src_line%SSLIMIT];
               }
      }
      else {
         for(sfb=0,sfb_start=0,sfb_lines=sfBandIndex[sfreq].s[1];
    8e4f:	83 7d ec 0c          	cmpl   $0xc,-0x14(%ebp)
    8e53:	0f 8e 97 fe ff ff    	jle    8cf0 <III_reorder+0x2a8>
   for(sb=0;sb<SBLIMIT;sb++)
      for(ss=0;ss<SSLIMIT;ss++)
         ro[sb][ss] = 0;

   if (gr_info->window_switching_flag && (gr_info->block_type == 2)) {
      if (gr_info->mixed_block_flag) {
    8e59:	eb 5b                	jmp    8eb6 <III_reorder+0x46e>
                       xr[src_line/SSLIMIT][src_line%SSLIMIT];
               }
      }
   }
   else {   /*long blocks */
      for (sb=0 ; sb < SBLIMIT ; sb++)
    8e5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    8e62:	eb 4c                	jmp    8eb0 <III_reorder+0x468>
         for (ss=0 ; ss < SSLIMIT ; ss++)
    8e64:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    8e6b:	eb 39                	jmp    8ea6 <III_reorder+0x45e>
            ro[sb][ss] = xr[sb][ss];
    8e6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
    8e70:	89 d0                	mov    %edx,%eax
    8e72:	c1 e0 03             	shl    $0x3,%eax
    8e75:	01 d0                	add    %edx,%eax
    8e77:	c1 e0 04             	shl    $0x4,%eax
    8e7a:	89 c2                	mov    %eax,%edx
    8e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
    8e7f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    8e82:	8b 55 e0             	mov    -0x20(%ebp),%edx
    8e85:	89 d0                	mov    %edx,%eax
    8e87:	c1 e0 03             	shl    $0x3,%eax
    8e8a:	01 d0                	add    %edx,%eax
    8e8c:	c1 e0 04             	shl    $0x4,%eax
    8e8f:	89 c2                	mov    %eax,%edx
    8e91:	8b 45 08             	mov    0x8(%ebp),%eax
    8e94:	01 c2                	add    %eax,%edx
    8e96:	8b 45 dc             	mov    -0x24(%ebp),%eax
    8e99:	dd 04 c2             	fldl   (%edx,%eax,8)
    8e9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
    8e9f:	dd 1c c1             	fstpl  (%ecx,%eax,8)
               }
      }
   }
   else {   /*long blocks */
      for (sb=0 ; sb < SBLIMIT ; sb++)
         for (ss=0 ; ss < SSLIMIT ; ss++)
    8ea2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
    8ea6:	83 7d dc 11          	cmpl   $0x11,-0x24(%ebp)
    8eaa:	7e c1                	jle    8e6d <III_reorder+0x425>
                       xr[src_line/SSLIMIT][src_line%SSLIMIT];
               }
      }
   }
   else {   /*long blocks */
      for (sb=0 ; sb < SBLIMIT ; sb++)
    8eac:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    8eb0:	83 7d e0 1f          	cmpl   $0x1f,-0x20(%ebp)
    8eb4:	7e ae                	jle    8e64 <III_reorder+0x41c>
         for (ss=0 ; ss < SSLIMIT ; ss++)
            ro[sb][ss] = xr[sb][ss];
   }
}
    8eb6:	83 c4 34             	add    $0x34,%esp
    8eb9:	5b                   	pop    %ebx
    8eba:	5e                   	pop    %esi
    8ebb:	5f                   	pop    %edi
    8ebc:	5d                   	pop    %ebp
    8ebd:	c3                   	ret    

00008ebe <III_stereo>:


void III_stereo(double xr[2][SBLIMIT][SSLIMIT], double lr[2][SBLIMIT][SSLIMIT], III_scalefac_t *scalefac, struct gr_info_s *gr_info, struct frame_params *fr_ps)
{
    8ebe:	55                   	push   %ebp
    8ebf:	89 e5                	mov    %esp,%ebp
    8ec1:	56                   	push   %esi
    8ec2:	53                   	push   %ebx
    8ec3:	81 ec 50 1b 00 00    	sub    $0x1b50,%esp
   int sfreq = fr_ps->header->sampling_frequency;
    8ec9:	8b 45 18             	mov    0x18(%ebp),%eax
    8ecc:	8b 00                	mov    (%eax),%eax
    8ece:	8b 40 10             	mov    0x10(%eax),%eax
    8ed1:	89 45 c8             	mov    %eax,-0x38(%ebp)
   int stereo = fr_ps->stereo;
    8ed4:	8b 45 18             	mov    0x18(%ebp),%eax
    8ed7:	8b 40 08             	mov    0x8(%eax),%eax
    8eda:	89 45 c4             	mov    %eax,-0x3c(%ebp)
   int ms_stereo = (fr_ps->header->mode == MPG_MD_JOINT_STEREO) &&
    8edd:	8b 45 18             	mov    0x18(%ebp),%eax
    8ee0:	8b 00                	mov    (%eax),%eax
    8ee2:	8b 40 1c             	mov    0x1c(%eax),%eax
    8ee5:	83 f8 01             	cmp    $0x1,%eax
    8ee8:	75 16                	jne    8f00 <III_stereo+0x42>
                   (fr_ps->header->mode_ext & 0x2);
    8eea:	8b 45 18             	mov    0x18(%ebp),%eax
    8eed:	8b 00                	mov    (%eax),%eax
    8eef:	8b 40 20             	mov    0x20(%eax),%eax
    8ef2:	83 e0 02             	and    $0x2,%eax

void III_stereo(double xr[2][SBLIMIT][SSLIMIT], double lr[2][SBLIMIT][SSLIMIT], III_scalefac_t *scalefac, struct gr_info_s *gr_info, struct frame_params *fr_ps)
{
   int sfreq = fr_ps->header->sampling_frequency;
   int stereo = fr_ps->stereo;
   int ms_stereo = (fr_ps->header->mode == MPG_MD_JOINT_STEREO) &&
    8ef5:	85 c0                	test   %eax,%eax
    8ef7:	74 07                	je     8f00 <III_stereo+0x42>
    8ef9:	b8 01 00 00 00       	mov    $0x1,%eax
    8efe:	eb 05                	jmp    8f05 <III_stereo+0x47>
    8f00:	b8 00 00 00 00       	mov    $0x0,%eax
    8f05:	89 45 c0             	mov    %eax,-0x40(%ebp)
                   (fr_ps->header->mode_ext & 0x2);
   int i_stereo = (fr_ps->header->mode == MPG_MD_JOINT_STEREO) &&
    8f08:	8b 45 18             	mov    0x18(%ebp),%eax
    8f0b:	8b 00                	mov    (%eax),%eax
    8f0d:	8b 40 1c             	mov    0x1c(%eax),%eax
    8f10:	83 f8 01             	cmp    $0x1,%eax
    8f13:	75 16                	jne    8f2b <III_stereo+0x6d>
                  (fr_ps->header->mode_ext & 0x1);
    8f15:	8b 45 18             	mov    0x18(%ebp),%eax
    8f18:	8b 00                	mov    (%eax),%eax
    8f1a:	8b 40 20             	mov    0x20(%eax),%eax
    8f1d:	83 e0 01             	and    $0x1,%eax
{
   int sfreq = fr_ps->header->sampling_frequency;
   int stereo = fr_ps->stereo;
   int ms_stereo = (fr_ps->header->mode == MPG_MD_JOINT_STEREO) &&
                   (fr_ps->header->mode_ext & 0x2);
   int i_stereo = (fr_ps->header->mode == MPG_MD_JOINT_STEREO) &&
    8f20:	85 c0                	test   %eax,%eax
    8f22:	74 07                	je     8f2b <III_stereo+0x6d>
    8f24:	b8 01 00 00 00       	mov    $0x1,%eax
    8f29:	eb 05                	jmp    8f30 <III_stereo+0x72>
    8f2b:	b8 00 00 00 00       	mov    $0x0,%eax
    8f30:	89 45 bc             	mov    %eax,-0x44(%ebp)
   int sfb;
   int i,j,sb,ss,ch,is_pos[576];
   double is_ratio[576];

   /* intialization */
   for ( i=0; i<576; i++ )
    8f33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    8f3a:	eb 12                	jmp    8f4e <III_stereo+0x90>
      is_pos[i] = 7;
    8f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    8f3f:	c7 84 85 bc f6 ff ff 	movl   $0x7,-0x944(%ebp,%eax,4)
    8f46:	07 00 00 00 
   int sfb;
   int i,j,sb,ss,ch,is_pos[576];
   double is_ratio[576];

   /* intialization */
   for ( i=0; i<576; i++ )
    8f4a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    8f4e:	81 7d f0 3f 02 00 00 	cmpl   $0x23f,-0x10(%ebp)
    8f55:	7e e5                	jle    8f3c <III_stereo+0x7e>
      is_pos[i] = 7;

   if ((stereo == 2) && i_stereo )
    8f57:	83 7d c4 02          	cmpl   $0x2,-0x3c(%ebp)
    8f5b:	0f 85 18 0a 00 00    	jne    9979 <III_stereo+0xabb>
    8f61:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
    8f65:	0f 84 0e 0a 00 00    	je     9979 <III_stereo+0xabb>
   {  if (gr_info->window_switching_flag && (gr_info->block_type == 2))
    8f6b:	8b 45 14             	mov    0x14(%ebp),%eax
    8f6e:	8b 40 10             	mov    0x10(%eax),%eax
    8f71:	85 c0                	test   %eax,%eax
    8f73:	0f 84 10 08 00 00    	je     9789 <III_stereo+0x8cb>
    8f79:	8b 45 14             	mov    0x14(%ebp),%eax
    8f7c:	8b 40 14             	mov    0x14(%eax),%eax
    8f7f:	83 f8 02             	cmp    $0x2,%eax
    8f82:	0f 85 01 08 00 00    	jne    9789 <III_stereo+0x8cb>
      {  if( gr_info->mixed_block_flag )
    8f88:	8b 45 14             	mov    0x14(%ebp),%eax
    8f8b:	8b 40 18             	mov    0x18(%eax),%eax
    8f8e:	85 c0                	test   %eax,%eax
    8f90:	0f 84 d0 04 00 00    	je     9466 <III_stereo+0x5a8>
         {  int max_sfb = 0;
    8f96:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

            for ( j=0; j<3; j++ )
    8f9d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    8fa4:	e9 1b 03 00 00       	jmp    92c4 <III_stereo+0x406>
            {  int sfbcnt;
               sfbcnt = 2;
    8fa9:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
               for( sfb=12; sfb >=3; sfb-- )
    8fb0:	c7 45 f4 0c 00 00 00 	movl   $0xc,-0xc(%ebp)
    8fb7:	e9 0f 01 00 00       	jmp    90cb <III_stereo+0x20d>
               {  int lines;
                  lines = sfBandIndex[sfreq].s[sfb+1]-sfBandIndex[sfreq].s[sfb];
    8fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    8fbf:	8d 48 01             	lea    0x1(%eax),%ecx
    8fc2:	8b 55 c8             	mov    -0x38(%ebp),%edx
    8fc5:	89 d0                	mov    %edx,%eax
    8fc7:	c1 e0 03             	shl    $0x3,%eax
    8fca:	01 d0                	add    %edx,%eax
    8fcc:	c1 e0 02             	shl    $0x2,%eax
    8fcf:	01 d0                	add    %edx,%eax
    8fd1:	01 c8                	add    %ecx,%eax
    8fd3:	83 c0 14             	add    $0x14,%eax
    8fd6:	8b 0c 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%ecx
    8fdd:	8b 55 c8             	mov    -0x38(%ebp),%edx
    8fe0:	89 d0                	mov    %edx,%eax
    8fe2:	c1 e0 03             	shl    $0x3,%eax
    8fe5:	01 d0                	add    %edx,%eax
    8fe7:	c1 e0 02             	shl    $0x2,%eax
    8fea:	01 d0                	add    %edx,%eax
    8fec:	8b 55 f4             	mov    -0xc(%ebp),%edx
    8fef:	01 d0                	add    %edx,%eax
    8ff1:	83 c0 14             	add    $0x14,%eax
    8ff4:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
    8ffb:	29 c1                	sub    %eax,%ecx
    8ffd:	89 c8                	mov    %ecx,%eax
    8fff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                  i = 3*sfBandIndex[sfreq].s[sfb] + (j+1) * lines - 1;
    9002:	8b 55 c8             	mov    -0x38(%ebp),%edx
    9005:	89 d0                	mov    %edx,%eax
    9007:	c1 e0 03             	shl    $0x3,%eax
    900a:	01 d0                	add    %edx,%eax
    900c:	c1 e0 02             	shl    $0x2,%eax
    900f:	01 d0                	add    %edx,%eax
    9011:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9014:	01 d0                	add    %edx,%eax
    9016:	83 c0 14             	add    $0x14,%eax
    9019:	8b 14 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%edx
    9020:	89 d0                	mov    %edx,%eax
    9022:	01 c0                	add    %eax,%eax
    9024:	01 c2                	add    %eax,%edx
    9026:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9029:	83 c0 01             	add    $0x1,%eax
    902c:	0f af 45 d4          	imul   -0x2c(%ebp),%eax
    9030:	01 d0                	add    %edx,%eax
    9032:	83 e8 01             	sub    $0x1,%eax
    9035:	89 45 f0             	mov    %eax,-0x10(%ebp)
                  while ( lines > 0 )
    9038:	e9 80 00 00 00       	jmp    90bd <III_stereo+0x1ff>
                  {  if ( xr[1][i/SSLIMIT][i%SSLIMIT] != 0.0 )
    903d:	8b 45 08             	mov    0x8(%ebp),%eax
    9040:	8d b0 00 12 00 00    	lea    0x1200(%eax),%esi
    9046:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    9049:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    904e:	89 c8                	mov    %ecx,%eax
    9050:	f7 ea                	imul   %edx
    9052:	c1 fa 02             	sar    $0x2,%edx
    9055:	89 c8                	mov    %ecx,%eax
    9057:	c1 f8 1f             	sar    $0x1f,%eax
    905a:	89 d3                	mov    %edx,%ebx
    905c:	29 c3                	sub    %eax,%ebx
    905e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    9061:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    9066:	89 c8                	mov    %ecx,%eax
    9068:	f7 ea                	imul   %edx
    906a:	c1 fa 02             	sar    $0x2,%edx
    906d:	89 c8                	mov    %ecx,%eax
    906f:	c1 f8 1f             	sar    $0x1f,%eax
    9072:	29 c2                	sub    %eax,%edx
    9074:	89 d0                	mov    %edx,%eax
    9076:	c1 e0 03             	shl    $0x3,%eax
    9079:	01 d0                	add    %edx,%eax
    907b:	01 c0                	add    %eax,%eax
    907d:	29 c1                	sub    %eax,%ecx
    907f:	89 ca                	mov    %ecx,%edx
    9081:	89 d8                	mov    %ebx,%eax
    9083:	c1 e0 03             	shl    $0x3,%eax
    9086:	01 d8                	add    %ebx,%eax
    9088:	01 c0                	add    %eax,%eax
    908a:	01 d0                	add    %edx,%eax
    908c:	dd 04 c6             	fldl   (%esi,%eax,8)
    908f:	d9 ee                	fldz   
    9091:	df e9                	fucomip %st(1),%st
    9093:	7a 0a                	jp     909f <III_stereo+0x1e1>
    9095:	d9 ee                	fldz   
    9097:	df e9                	fucomip %st(1),%st
    9099:	dd d8                	fstp   %st(0)
    909b:	74 18                	je     90b5 <III_stereo+0x1f7>
    909d:	eb 02                	jmp    90a1 <III_stereo+0x1e3>
    909f:	dd d8                	fstp   %st(0)
                     {  sfbcnt = sfb;
    90a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    90a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
                        sfb = -10;
    90a7:	c7 45 f4 f6 ff ff ff 	movl   $0xfffffff6,-0xc(%ebp)
                        lines = -10;
    90ae:	c7 45 d4 f6 ff ff ff 	movl   $0xfffffff6,-0x2c(%ebp)
                     }
                     lines--;
    90b5:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
                     i--;
    90b9:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
               sfbcnt = 2;
               for( sfb=12; sfb >=3; sfb-- )
               {  int lines;
                  lines = sfBandIndex[sfreq].s[sfb+1]-sfBandIndex[sfreq].s[sfb];
                  i = 3*sfBandIndex[sfreq].s[sfb] + (j+1) * lines - 1;
                  while ( lines > 0 )
    90bd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
    90c1:	0f 8f 76 ff ff ff    	jg     903d <III_stereo+0x17f>
         {  int max_sfb = 0;

            for ( j=0; j<3; j++ )
            {  int sfbcnt;
               sfbcnt = 2;
               for( sfb=12; sfb >=3; sfb-- )
    90c7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    90cb:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
    90cf:	0f 8f e7 fe ff ff    	jg     8fbc <III_stereo+0xfe>
                     }
                     lines--;
                     i--;
                  }
               }
               sfb = sfbcnt + 1;
    90d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
    90d8:	83 c0 01             	add    $0x1,%eax
    90db:	89 45 f4             	mov    %eax,-0xc(%ebp)

               if ( sfb > max_sfb )
    90de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    90e1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    90e4:	7e 0b                	jle    90f1 <III_stereo+0x233>
                  max_sfb = sfb;
    90e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    90e9:	89 45 dc             	mov    %eax,-0x24(%ebp)

               while( sfb<12 )
    90ec:	e9 f5 00 00 00       	jmp    91e6 <III_stereo+0x328>
    90f1:	e9 f0 00 00 00       	jmp    91e6 <III_stereo+0x328>
               {  sb = sfBandIndex[sfreq].s[sfb+1]-sfBandIndex[sfreq].s[sfb];
    90f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    90f9:	8d 48 01             	lea    0x1(%eax),%ecx
    90fc:	8b 55 c8             	mov    -0x38(%ebp),%edx
    90ff:	89 d0                	mov    %edx,%eax
    9101:	c1 e0 03             	shl    $0x3,%eax
    9104:	01 d0                	add    %edx,%eax
    9106:	c1 e0 02             	shl    $0x2,%eax
    9109:	01 d0                	add    %edx,%eax
    910b:	01 c8                	add    %ecx,%eax
    910d:	83 c0 14             	add    $0x14,%eax
    9110:	8b 0c 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%ecx
    9117:	8b 55 c8             	mov    -0x38(%ebp),%edx
    911a:	89 d0                	mov    %edx,%eax
    911c:	c1 e0 03             	shl    $0x3,%eax
    911f:	01 d0                	add    %edx,%eax
    9121:	c1 e0 02             	shl    $0x2,%eax
    9124:	01 d0                	add    %edx,%eax
    9126:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9129:	01 d0                	add    %edx,%eax
    912b:	83 c0 14             	add    $0x14,%eax
    912e:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
    9135:	29 c1                	sub    %eax,%ecx
    9137:	89 c8                	mov    %ecx,%eax
    9139:	89 45 e8             	mov    %eax,-0x18(%ebp)
                  i = 3*sfBandIndex[sfreq].s[sfb] + j * sb;
    913c:	8b 55 c8             	mov    -0x38(%ebp),%edx
    913f:	89 d0                	mov    %edx,%eax
    9141:	c1 e0 03             	shl    $0x3,%eax
    9144:	01 d0                	add    %edx,%eax
    9146:	c1 e0 02             	shl    $0x2,%eax
    9149:	01 d0                	add    %edx,%eax
    914b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    914e:	01 d0                	add    %edx,%eax
    9150:	83 c0 14             	add    $0x14,%eax
    9153:	8b 14 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%edx
    915a:	89 d0                	mov    %edx,%eax
    915c:	01 c0                	add    %eax,%eax
    915e:	01 c2                	add    %eax,%edx
    9160:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9163:	0f af 45 e8          	imul   -0x18(%ebp),%eax
    9167:	01 d0                	add    %edx,%eax
    9169:	89 45 f0             	mov    %eax,-0x10(%ebp)
                  for ( ; sb > 0; sb--)
    916c:	eb 6e                	jmp    91dc <III_stereo+0x31e>
                  {  is_pos[i] = (*scalefac)[1].s[j][sfb];
    916e:	8b 4d 10             	mov    0x10(%ebp),%ecx
    9171:	8b 55 ec             	mov    -0x14(%ebp),%edx
    9174:	89 d0                	mov    %edx,%eax
    9176:	01 c0                	add    %eax,%eax
    9178:	01 d0                	add    %edx,%eax
    917a:	c1 e0 02             	shl    $0x2,%eax
    917d:	01 d0                	add    %edx,%eax
    917f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9182:	01 d0                	add    %edx,%eax
    9184:	83 c0 52             	add    $0x52,%eax
    9187:	8b 54 81 0c          	mov    0xc(%ecx,%eax,4),%edx
    918b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    918e:	89 94 85 bc f6 ff ff 	mov    %edx,-0x944(%ebp,%eax,4)
                     if ( is_pos[i] != 7 )
    9195:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9198:	8b 84 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%eax
    919f:	83 f8 07             	cmp    $0x7,%eax
    91a2:	74 30                	je     91d4 <III_stereo+0x316>
                        is_ratio[i] = tan( is_pos[i] * (PI / 12));
    91a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    91a7:	8b 84 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%eax
    91ae:	89 85 b4 e4 ff ff    	mov    %eax,-0x1b4c(%ebp)
    91b4:	db 85 b4 e4 ff ff    	fildl  -0x1b4c(%ebp)
    91ba:	dd 05 60 d6 00 00    	fldl   0xd660
    91c0:	de c9                	fmulp  %st,%st(1)
    91c2:	dd 1c 24             	fstpl  (%esp)
    91c5:	e8 1d b6 ff ff       	call   47e7 <tan>
    91ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
    91cd:	dd 9c c5 b8 e4 ff ff 	fstpl  -0x1b48(%ebp,%eax,8)
                     i++;
    91d4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
                  max_sfb = sfb;

               while( sfb<12 )
               {  sb = sfBandIndex[sfreq].s[sfb+1]-sfBandIndex[sfreq].s[sfb];
                  i = 3*sfBandIndex[sfreq].s[sfb] + j * sb;
                  for ( ; sb > 0; sb--)
    91d8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
    91dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    91e0:	7f 8c                	jg     916e <III_stereo+0x2b0>
                  {  is_pos[i] = (*scalefac)[1].s[j][sfb];
                     if ( is_pos[i] != 7 )
                        is_ratio[i] = tan( is_pos[i] * (PI / 12));
                     i++;
                  }
                  sfb++;
    91e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
               sfb = sfbcnt + 1;

               if ( sfb > max_sfb )
                  max_sfb = sfb;

               while( sfb<12 )
    91e6:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    91ea:	0f 8e 06 ff ff ff    	jle    90f6 <III_stereo+0x238>
                        is_ratio[i] = tan( is_pos[i] * (PI / 12));
                     i++;
                  }
                  sfb++;
               }
               sb = sfBandIndex[sfreq].s[11]-sfBandIndex[sfreq].s[10];
    91f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
    91f3:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    91f9:	05 fc e9 00 00       	add    $0xe9fc,%eax
    91fe:	8b 50 0c             	mov    0xc(%eax),%edx
    9201:	8b 45 c8             	mov    -0x38(%ebp),%eax
    9204:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    920a:	05 f8 e9 00 00       	add    $0xe9f8,%eax
    920f:	8b 40 0c             	mov    0xc(%eax),%eax
    9212:	29 c2                	sub    %eax,%edx
    9214:	89 d0                	mov    %edx,%eax
    9216:	89 45 e8             	mov    %eax,-0x18(%ebp)
               sfb = 3*sfBandIndex[sfreq].s[10] + j * sb;
    9219:	8b 45 c8             	mov    -0x38(%ebp),%eax
    921c:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    9222:	05 f8 e9 00 00       	add    $0xe9f8,%eax
    9227:	8b 50 0c             	mov    0xc(%eax),%edx
    922a:	89 d0                	mov    %edx,%eax
    922c:	01 c0                	add    %eax,%eax
    922e:	01 c2                	add    %eax,%edx
    9230:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9233:	0f af 45 e8          	imul   -0x18(%ebp),%eax
    9237:	01 d0                	add    %edx,%eax
    9239:	89 45 f4             	mov    %eax,-0xc(%ebp)
               sb = sfBandIndex[sfreq].s[12]-sfBandIndex[sfreq].s[11];
    923c:	8b 45 c8             	mov    -0x38(%ebp),%eax
    923f:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    9245:	05 00 ea 00 00       	add    $0xea00,%eax
    924a:	8b 50 0c             	mov    0xc(%eax),%edx
    924d:	8b 45 c8             	mov    -0x38(%ebp),%eax
    9250:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    9256:	05 fc e9 00 00       	add    $0xe9fc,%eax
    925b:	8b 40 0c             	mov    0xc(%eax),%eax
    925e:	29 c2                	sub    %eax,%edx
    9260:	89 d0                	mov    %edx,%eax
    9262:	89 45 e8             	mov    %eax,-0x18(%ebp)
               i = 3*sfBandIndex[sfreq].s[11] + j * sb;
    9265:	8b 45 c8             	mov    -0x38(%ebp),%eax
    9268:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    926e:	05 fc e9 00 00       	add    $0xe9fc,%eax
    9273:	8b 50 0c             	mov    0xc(%eax),%edx
    9276:	89 d0                	mov    %edx,%eax
    9278:	01 c0                	add    %eax,%eax
    927a:	01 c2                	add    %eax,%edx
    927c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    927f:	0f af 45 e8          	imul   -0x18(%ebp),%eax
    9283:	01 d0                	add    %edx,%eax
    9285:	89 45 f0             	mov    %eax,-0x10(%ebp)
               for ( ; sb > 0; sb-- )
    9288:	eb 30                	jmp    92ba <III_stereo+0x3fc>
               {  is_pos[i] = is_pos[sfb];
    928a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    928d:	8b 94 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%edx
    9294:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9297:	89 94 85 bc f6 ff ff 	mov    %edx,-0x944(%ebp,%eax,4)
                  is_ratio[i] = is_ratio[sfb];
    929e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    92a1:	dd 84 c5 b8 e4 ff ff 	fldl   -0x1b48(%ebp,%eax,8)
    92a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    92ab:	dd 9c c5 b8 e4 ff ff 	fstpl  -0x1b48(%ebp,%eax,8)
                  i++;
    92b2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
               }
               sb = sfBandIndex[sfreq].s[11]-sfBandIndex[sfreq].s[10];
               sfb = 3*sfBandIndex[sfreq].s[10] + j * sb;
               sb = sfBandIndex[sfreq].s[12]-sfBandIndex[sfreq].s[11];
               i = 3*sfBandIndex[sfreq].s[11] + j * sb;
               for ( ; sb > 0; sb-- )
    92b6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
    92ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    92be:	7f ca                	jg     928a <III_stereo+0x3cc>
   if ((stereo == 2) && i_stereo )
   {  if (gr_info->window_switching_flag && (gr_info->block_type == 2))
      {  if( gr_info->mixed_block_flag )
         {  int max_sfb = 0;

            for ( j=0; j<3; j++ )
    92c0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    92c4:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
    92c8:	0f 8e db fc ff ff    	jle    8fa9 <III_stereo+0xeb>
               {  is_pos[i] = is_pos[sfb];
                  is_ratio[i] = is_ratio[sfb];
                  i++;
               }
             }
             if ( max_sfb <= 3 )
    92ce:	83 7d dc 03          	cmpl   $0x3,-0x24(%ebp)
    92d2:	0f 8f 89 01 00 00    	jg     9461 <III_stereo+0x5a3>
             {  i = 2;
    92d8:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%ebp)
                ss = 17;
    92df:	c7 45 e4 11 00 00 00 	movl   $0x11,-0x1c(%ebp)
                sb = -1;
    92e6:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
                while ( i >= 0 )
    92ed:	eb 63                	jmp    9352 <III_stereo+0x494>
                {  if ( xr[1][i][ss] != 0.0 )
    92ef:	8b 45 08             	mov    0x8(%ebp),%eax
    92f2:	8d 88 00 12 00 00    	lea    0x1200(%eax),%ecx
    92f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
    92fb:	89 d0                	mov    %edx,%eax
    92fd:	c1 e0 03             	shl    $0x3,%eax
    9300:	01 d0                	add    %edx,%eax
    9302:	01 c0                	add    %eax,%eax
    9304:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9307:	01 d0                	add    %edx,%eax
    9309:	dd 04 c1             	fldl   (%ecx,%eax,8)
    930c:	d9 ee                	fldz   
    930e:	df e9                	fucomip %st(1),%st
    9310:	7a 0a                	jp     931c <III_stereo+0x45e>
    9312:	d9 ee                	fldz   
    9314:	df e9                	fucomip %st(1),%st
    9316:	dd d8                	fstp   %st(0)
    9318:	74 23                	je     933d <III_stereo+0x47f>
    931a:	eb 02                	jmp    931e <III_stereo+0x460>
    931c:	dd d8                	fstp   %st(0)
                   {  sb = i*18+ss;
    931e:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9321:	89 d0                	mov    %edx,%eax
    9323:	c1 e0 03             	shl    $0x3,%eax
    9326:	01 d0                	add    %edx,%eax
    9328:	01 c0                	add    %eax,%eax
    932a:	89 c2                	mov    %eax,%edx
    932c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    932f:	01 d0                	add    %edx,%eax
    9331:	89 45 e8             	mov    %eax,-0x18(%ebp)
                      i = -1;
    9334:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    933b:	eb 15                	jmp    9352 <III_stereo+0x494>
                   } else
                   {  ss--;
    933d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
                      if ( ss < 0 )
    9341:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    9345:	79 0b                	jns    9352 <III_stereo+0x494>
                      {  i--;
    9347:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
                         ss = 17;
    934b:	c7 45 e4 11 00 00 00 	movl   $0x11,-0x1c(%ebp)
             }
             if ( max_sfb <= 3 )
             {  i = 2;
                ss = 17;
                sb = -1;
                while ( i >= 0 )
    9352:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    9356:	79 97                	jns    92ef <III_stereo+0x431>
                      {  i--;
                         ss = 17;
                      }
                   }
                }
                i = 0;
    9358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
                while ( sfBandIndex[sfreq].l[i] <= sb )
    935f:	eb 04                	jmp    9365 <III_stereo+0x4a7>
                   i++;
    9361:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
                         ss = 17;
                      }
                   }
                }
                i = 0;
                while ( sfBandIndex[sfreq].l[i] <= sb )
    9365:	8b 55 c8             	mov    -0x38(%ebp),%edx
    9368:	89 d0                	mov    %edx,%eax
    936a:	c1 e0 03             	shl    $0x3,%eax
    936d:	01 d0                	add    %edx,%eax
    936f:	c1 e0 02             	shl    $0x2,%eax
    9372:	01 d0                	add    %edx,%eax
    9374:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9377:	01 d0                	add    %edx,%eax
    9379:	8b 04 85 80 e9 00 00 	mov    0xe980(,%eax,4),%eax
    9380:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    9383:	7e dc                	jle    9361 <III_stereo+0x4a3>
                   i++;
                sfb = i;
    9385:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9388:	89 45 f4             	mov    %eax,-0xc(%ebp)
                i = sfBandIndex[sfreq].l[i];
    938b:	8b 55 c8             	mov    -0x38(%ebp),%edx
    938e:	89 d0                	mov    %edx,%eax
    9390:	c1 e0 03             	shl    $0x3,%eax
    9393:	01 d0                	add    %edx,%eax
    9395:	c1 e0 02             	shl    $0x2,%eax
    9398:	01 d0                	add    %edx,%eax
    939a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    939d:	01 d0                	add    %edx,%eax
    939f:	8b 04 85 80 e9 00 00 	mov    0xe980(,%eax,4),%eax
    93a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
                for ( ; sfb<8; sfb++ )
    93a9:	e9 a9 00 00 00       	jmp    9457 <III_stereo+0x599>
                {  sb = sfBandIndex[sfreq].l[sfb+1]-sfBandIndex[sfreq].l[sfb];
    93ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    93b1:	8d 48 01             	lea    0x1(%eax),%ecx
    93b4:	8b 55 c8             	mov    -0x38(%ebp),%edx
    93b7:	89 d0                	mov    %edx,%eax
    93b9:	c1 e0 03             	shl    $0x3,%eax
    93bc:	01 d0                	add    %edx,%eax
    93be:	c1 e0 02             	shl    $0x2,%eax
    93c1:	01 d0                	add    %edx,%eax
    93c3:	01 c8                	add    %ecx,%eax
    93c5:	8b 0c 85 80 e9 00 00 	mov    0xe980(,%eax,4),%ecx
    93cc:	8b 55 c8             	mov    -0x38(%ebp),%edx
    93cf:	89 d0                	mov    %edx,%eax
    93d1:	c1 e0 03             	shl    $0x3,%eax
    93d4:	01 d0                	add    %edx,%eax
    93d6:	c1 e0 02             	shl    $0x2,%eax
    93d9:	01 d0                	add    %edx,%eax
    93db:	8b 55 f4             	mov    -0xc(%ebp),%edx
    93de:	01 d0                	add    %edx,%eax
    93e0:	8b 04 85 80 e9 00 00 	mov    0xe980(,%eax,4),%eax
    93e7:	29 c1                	sub    %eax,%ecx
    93e9:	89 c8                	mov    %ecx,%eax
    93eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
                   for ( ; sb > 0; sb--)
    93ee:	eb 5d                	jmp    944d <III_stereo+0x58f>
                   {  is_pos[i] = (*scalefac)[1].l[sfb];
    93f0:	8b 45 10             	mov    0x10(%ebp),%eax
    93f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    93f6:	83 c2 3e             	add    $0x3e,%edx
    93f9:	8b 14 90             	mov    (%eax,%edx,4),%edx
    93fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    93ff:	89 94 85 bc f6 ff ff 	mov    %edx,-0x944(%ebp,%eax,4)
                      if ( is_pos[i] != 7 )
    9406:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9409:	8b 84 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%eax
    9410:	83 f8 07             	cmp    $0x7,%eax
    9413:	74 30                	je     9445 <III_stereo+0x587>
                         is_ratio[i] = tan( is_pos[i] * (PI / 12));
    9415:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9418:	8b 84 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%eax
    941f:	89 85 b4 e4 ff ff    	mov    %eax,-0x1b4c(%ebp)
    9425:	db 85 b4 e4 ff ff    	fildl  -0x1b4c(%ebp)
    942b:	dd 05 60 d6 00 00    	fldl   0xd660
    9431:	de c9                	fmulp  %st,%st(1)
    9433:	dd 1c 24             	fstpl  (%esp)
    9436:	e8 ac b3 ff ff       	call   47e7 <tan>
    943b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    943e:	dd 9c c5 b8 e4 ff ff 	fstpl  -0x1b48(%ebp,%eax,8)
                      i++;
    9445:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
                   i++;
                sfb = i;
                i = sfBandIndex[sfreq].l[i];
                for ( ; sfb<8; sfb++ )
                {  sb = sfBandIndex[sfreq].l[sfb+1]-sfBandIndex[sfreq].l[sfb];
                   for ( ; sb > 0; sb--)
    9449:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
    944d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    9451:	7f 9d                	jg     93f0 <III_stereo+0x532>
                i = 0;
                while ( sfBandIndex[sfreq].l[i] <= sb )
                   i++;
                sfb = i;
                i = sfBandIndex[sfreq].l[i];
                for ( ; sfb<8; sfb++ )
    9453:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9457:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
    945b:	0f 8e 4d ff ff ff    	jle    93ae <III_stereo+0x4f0>
    9461:	e9 1e 03 00 00       	jmp    9784 <III_stereo+0x8c6>
                      i++;
                   }
                }
            }
         } else
         {  for ( j=0; j<3; j++ )
    9466:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    946d:	e9 08 03 00 00       	jmp    977a <III_stereo+0x8bc>
            {  int sfbcnt;
               sfbcnt = -1;
    9472:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
               for( sfb=12; sfb >=0; sfb-- )
    9479:	c7 45 f4 0c 00 00 00 	movl   $0xc,-0xc(%ebp)
    9480:	e9 0f 01 00 00       	jmp    9594 <III_stereo+0x6d6>
               {  int lines;
                  lines = sfBandIndex[sfreq].s[sfb+1]-sfBandIndex[sfreq].s[sfb];
    9485:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9488:	8d 48 01             	lea    0x1(%eax),%ecx
    948b:	8b 55 c8             	mov    -0x38(%ebp),%edx
    948e:	89 d0                	mov    %edx,%eax
    9490:	c1 e0 03             	shl    $0x3,%eax
    9493:	01 d0                	add    %edx,%eax
    9495:	c1 e0 02             	shl    $0x2,%eax
    9498:	01 d0                	add    %edx,%eax
    949a:	01 c8                	add    %ecx,%eax
    949c:	83 c0 14             	add    $0x14,%eax
    949f:	8b 0c 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%ecx
    94a6:	8b 55 c8             	mov    -0x38(%ebp),%edx
    94a9:	89 d0                	mov    %edx,%eax
    94ab:	c1 e0 03             	shl    $0x3,%eax
    94ae:	01 d0                	add    %edx,%eax
    94b0:	c1 e0 02             	shl    $0x2,%eax
    94b3:	01 d0                	add    %edx,%eax
    94b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    94b8:	01 d0                	add    %edx,%eax
    94ba:	83 c0 14             	add    $0x14,%eax
    94bd:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
    94c4:	29 c1                	sub    %eax,%ecx
    94c6:	89 c8                	mov    %ecx,%eax
    94c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
                  i = 3*sfBandIndex[sfreq].s[sfb] + (j+1) * lines - 1;
    94cb:	8b 55 c8             	mov    -0x38(%ebp),%edx
    94ce:	89 d0                	mov    %edx,%eax
    94d0:	c1 e0 03             	shl    $0x3,%eax
    94d3:	01 d0                	add    %edx,%eax
    94d5:	c1 e0 02             	shl    $0x2,%eax
    94d8:	01 d0                	add    %edx,%eax
    94da:	8b 55 f4             	mov    -0xc(%ebp),%edx
    94dd:	01 d0                	add    %edx,%eax
    94df:	83 c0 14             	add    $0x14,%eax
    94e2:	8b 14 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%edx
    94e9:	89 d0                	mov    %edx,%eax
    94eb:	01 c0                	add    %eax,%eax
    94ed:	01 c2                	add    %eax,%edx
    94ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
    94f2:	83 c0 01             	add    $0x1,%eax
    94f5:	0f af 45 cc          	imul   -0x34(%ebp),%eax
    94f9:	01 d0                	add    %edx,%eax
    94fb:	83 e8 01             	sub    $0x1,%eax
    94fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
                  while ( lines > 0 )
    9501:	e9 80 00 00 00       	jmp    9586 <III_stereo+0x6c8>
                  {  if ( xr[1][i/SSLIMIT][i%SSLIMIT] != 0.0 )
    9506:	8b 45 08             	mov    0x8(%ebp),%eax
    9509:	8d b0 00 12 00 00    	lea    0x1200(%eax),%esi
    950f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    9512:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    9517:	89 c8                	mov    %ecx,%eax
    9519:	f7 ea                	imul   %edx
    951b:	c1 fa 02             	sar    $0x2,%edx
    951e:	89 c8                	mov    %ecx,%eax
    9520:	c1 f8 1f             	sar    $0x1f,%eax
    9523:	89 d3                	mov    %edx,%ebx
    9525:	29 c3                	sub    %eax,%ebx
    9527:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    952a:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    952f:	89 c8                	mov    %ecx,%eax
    9531:	f7 ea                	imul   %edx
    9533:	c1 fa 02             	sar    $0x2,%edx
    9536:	89 c8                	mov    %ecx,%eax
    9538:	c1 f8 1f             	sar    $0x1f,%eax
    953b:	29 c2                	sub    %eax,%edx
    953d:	89 d0                	mov    %edx,%eax
    953f:	c1 e0 03             	shl    $0x3,%eax
    9542:	01 d0                	add    %edx,%eax
    9544:	01 c0                	add    %eax,%eax
    9546:	29 c1                	sub    %eax,%ecx
    9548:	89 ca                	mov    %ecx,%edx
    954a:	89 d8                	mov    %ebx,%eax
    954c:	c1 e0 03             	shl    $0x3,%eax
    954f:	01 d8                	add    %ebx,%eax
    9551:	01 c0                	add    %eax,%eax
    9553:	01 d0                	add    %edx,%eax
    9555:	dd 04 c6             	fldl   (%esi,%eax,8)
    9558:	d9 ee                	fldz   
    955a:	df e9                	fucomip %st(1),%st
    955c:	7a 0a                	jp     9568 <III_stereo+0x6aa>
    955e:	d9 ee                	fldz   
    9560:	df e9                	fucomip %st(1),%st
    9562:	dd d8                	fstp   %st(0)
    9564:	74 18                	je     957e <III_stereo+0x6c0>
    9566:	eb 02                	jmp    956a <III_stereo+0x6ac>
    9568:	dd d8                	fstp   %st(0)
                     {  sfbcnt = sfb;
    956a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    956d:	89 45 d0             	mov    %eax,-0x30(%ebp)
                        sfb = -10;
    9570:	c7 45 f4 f6 ff ff ff 	movl   $0xfffffff6,-0xc(%ebp)
                        lines = -10;
    9577:	c7 45 cc f6 ff ff ff 	movl   $0xfffffff6,-0x34(%ebp)
                     }
                     lines--;
    957e:	83 6d cc 01          	subl   $0x1,-0x34(%ebp)
                     i--;
    9582:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
               sfbcnt = -1;
               for( sfb=12; sfb >=0; sfb-- )
               {  int lines;
                  lines = sfBandIndex[sfreq].s[sfb+1]-sfBandIndex[sfreq].s[sfb];
                  i = 3*sfBandIndex[sfreq].s[sfb] + (j+1) * lines - 1;
                  while ( lines > 0 )
    9586:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
    958a:	0f 8f 76 ff ff ff    	jg     9506 <III_stereo+0x648>
            }
         } else
         {  for ( j=0; j<3; j++ )
            {  int sfbcnt;
               sfbcnt = -1;
               for( sfb=12; sfb >=0; sfb-- )
    9590:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    9594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    9598:	0f 89 e7 fe ff ff    	jns    9485 <III_stereo+0x5c7>
                     }
                     lines--;
                     i--;
                  }
               }
               sfb = sfbcnt + 1;
    959e:	8b 45 d0             	mov    -0x30(%ebp),%eax
    95a1:	83 c0 01             	add    $0x1,%eax
    95a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
               while( sfb<12 )
    95a7:	e9 f0 00 00 00       	jmp    969c <III_stereo+0x7de>
               {  sb = sfBandIndex[sfreq].s[sfb+1]-sfBandIndex[sfreq].s[sfb];
    95ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    95af:	8d 48 01             	lea    0x1(%eax),%ecx
    95b2:	8b 55 c8             	mov    -0x38(%ebp),%edx
    95b5:	89 d0                	mov    %edx,%eax
    95b7:	c1 e0 03             	shl    $0x3,%eax
    95ba:	01 d0                	add    %edx,%eax
    95bc:	c1 e0 02             	shl    $0x2,%eax
    95bf:	01 d0                	add    %edx,%eax
    95c1:	01 c8                	add    %ecx,%eax
    95c3:	83 c0 14             	add    $0x14,%eax
    95c6:	8b 0c 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%ecx
    95cd:	8b 55 c8             	mov    -0x38(%ebp),%edx
    95d0:	89 d0                	mov    %edx,%eax
    95d2:	c1 e0 03             	shl    $0x3,%eax
    95d5:	01 d0                	add    %edx,%eax
    95d7:	c1 e0 02             	shl    $0x2,%eax
    95da:	01 d0                	add    %edx,%eax
    95dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
    95df:	01 d0                	add    %edx,%eax
    95e1:	83 c0 14             	add    $0x14,%eax
    95e4:	8b 04 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%eax
    95eb:	29 c1                	sub    %eax,%ecx
    95ed:	89 c8                	mov    %ecx,%eax
    95ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
                  i = 3*sfBandIndex[sfreq].s[sfb] + j * sb;
    95f2:	8b 55 c8             	mov    -0x38(%ebp),%edx
    95f5:	89 d0                	mov    %edx,%eax
    95f7:	c1 e0 03             	shl    $0x3,%eax
    95fa:	01 d0                	add    %edx,%eax
    95fc:	c1 e0 02             	shl    $0x2,%eax
    95ff:	01 d0                	add    %edx,%eax
    9601:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9604:	01 d0                	add    %edx,%eax
    9606:	83 c0 14             	add    $0x14,%eax
    9609:	8b 14 85 8c e9 00 00 	mov    0xe98c(,%eax,4),%edx
    9610:	89 d0                	mov    %edx,%eax
    9612:	01 c0                	add    %eax,%eax
    9614:	01 c2                	add    %eax,%edx
    9616:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9619:	0f af 45 e8          	imul   -0x18(%ebp),%eax
    961d:	01 d0                	add    %edx,%eax
    961f:	89 45 f0             	mov    %eax,-0x10(%ebp)
                  for ( ; sb > 0; sb--)
    9622:	eb 6e                	jmp    9692 <III_stereo+0x7d4>
                  {  is_pos[i] = (*scalefac)[1].s[j][sfb];
    9624:	8b 4d 10             	mov    0x10(%ebp),%ecx
    9627:	8b 55 ec             	mov    -0x14(%ebp),%edx
    962a:	89 d0                	mov    %edx,%eax
    962c:	01 c0                	add    %eax,%eax
    962e:	01 d0                	add    %edx,%eax
    9630:	c1 e0 02             	shl    $0x2,%eax
    9633:	01 d0                	add    %edx,%eax
    9635:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9638:	01 d0                	add    %edx,%eax
    963a:	83 c0 52             	add    $0x52,%eax
    963d:	8b 54 81 0c          	mov    0xc(%ecx,%eax,4),%edx
    9641:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9644:	89 94 85 bc f6 ff ff 	mov    %edx,-0x944(%ebp,%eax,4)
                     if ( is_pos[i] != 7 )
    964b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    964e:	8b 84 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%eax
    9655:	83 f8 07             	cmp    $0x7,%eax
    9658:	74 30                	je     968a <III_stereo+0x7cc>
                        is_ratio[i] = tan( is_pos[i] * (PI / 12));
    965a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    965d:	8b 84 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%eax
    9664:	89 85 b4 e4 ff ff    	mov    %eax,-0x1b4c(%ebp)
    966a:	db 85 b4 e4 ff ff    	fildl  -0x1b4c(%ebp)
    9670:	dd 05 60 d6 00 00    	fldl   0xd660
    9676:	de c9                	fmulp  %st,%st(1)
    9678:	dd 1c 24             	fstpl  (%esp)
    967b:	e8 67 b1 ff ff       	call   47e7 <tan>
    9680:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9683:	dd 9c c5 b8 e4 ff ff 	fstpl  -0x1b48(%ebp,%eax,8)
                     i++;
    968a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
               }
               sfb = sfbcnt + 1;
               while( sfb<12 )
               {  sb = sfBandIndex[sfreq].s[sfb+1]-sfBandIndex[sfreq].s[sfb];
                  i = 3*sfBandIndex[sfreq].s[sfb] + j * sb;
                  for ( ; sb > 0; sb--)
    968e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
    9692:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    9696:	7f 8c                	jg     9624 <III_stereo+0x766>
                  {  is_pos[i] = (*scalefac)[1].s[j][sfb];
                     if ( is_pos[i] != 7 )
                        is_ratio[i] = tan( is_pos[i] * (PI / 12));
                     i++;
                  }
                  sfb++;
    9698:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
                     lines--;
                     i--;
                  }
               }
               sfb = sfbcnt + 1;
               while( sfb<12 )
    969c:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    96a0:	0f 8e 06 ff ff ff    	jle    95ac <III_stereo+0x6ee>
                     i++;
                  }
                  sfb++;
               }

               sb = sfBandIndex[sfreq].s[11]-sfBandIndex[sfreq].s[10];
    96a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
    96a9:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    96af:	05 fc e9 00 00       	add    $0xe9fc,%eax
    96b4:	8b 50 0c             	mov    0xc(%eax),%edx
    96b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
    96ba:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    96c0:	05 f8 e9 00 00       	add    $0xe9f8,%eax
    96c5:	8b 40 0c             	mov    0xc(%eax),%eax
    96c8:	29 c2                	sub    %eax,%edx
    96ca:	89 d0                	mov    %edx,%eax
    96cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
               sfb = 3*sfBandIndex[sfreq].s[10] + j * sb;
    96cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
    96d2:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    96d8:	05 f8 e9 00 00       	add    $0xe9f8,%eax
    96dd:	8b 50 0c             	mov    0xc(%eax),%edx
    96e0:	89 d0                	mov    %edx,%eax
    96e2:	01 c0                	add    %eax,%eax
    96e4:	01 c2                	add    %eax,%edx
    96e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    96e9:	0f af 45 e8          	imul   -0x18(%ebp),%eax
    96ed:	01 d0                	add    %edx,%eax
    96ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
               sb = sfBandIndex[sfreq].s[12]-sfBandIndex[sfreq].s[11];
    96f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
    96f5:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    96fb:	05 00 ea 00 00       	add    $0xea00,%eax
    9700:	8b 50 0c             	mov    0xc(%eax),%edx
    9703:	8b 45 c8             	mov    -0x38(%ebp),%eax
    9706:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    970c:	05 fc e9 00 00       	add    $0xe9fc,%eax
    9711:	8b 40 0c             	mov    0xc(%eax),%eax
    9714:	29 c2                	sub    %eax,%edx
    9716:	89 d0                	mov    %edx,%eax
    9718:	89 45 e8             	mov    %eax,-0x18(%ebp)
               i = 3*sfBandIndex[sfreq].s[11] + j * sb;
    971b:	8b 45 c8             	mov    -0x38(%ebp),%eax
    971e:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    9724:	05 fc e9 00 00       	add    $0xe9fc,%eax
    9729:	8b 50 0c             	mov    0xc(%eax),%edx
    972c:	89 d0                	mov    %edx,%eax
    972e:	01 c0                	add    %eax,%eax
    9730:	01 c2                	add    %eax,%edx
    9732:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9735:	0f af 45 e8          	imul   -0x18(%ebp),%eax
    9739:	01 d0                	add    %edx,%eax
    973b:	89 45 f0             	mov    %eax,-0x10(%ebp)
               for ( ; sb > 0; sb-- )
    973e:	eb 30                	jmp    9770 <III_stereo+0x8b2>
               {  is_pos[i] = is_pos[sfb];
    9740:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9743:	8b 94 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%edx
    974a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    974d:	89 94 85 bc f6 ff ff 	mov    %edx,-0x944(%ebp,%eax,4)
                  is_ratio[i] = is_ratio[sfb];
    9754:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9757:	dd 84 c5 b8 e4 ff ff 	fldl   -0x1b48(%ebp,%eax,8)
    975e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9761:	dd 9c c5 b8 e4 ff ff 	fstpl  -0x1b48(%ebp,%eax,8)
                  i++;
    9768:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)

               sb = sfBandIndex[sfreq].s[11]-sfBandIndex[sfreq].s[10];
               sfb = 3*sfBandIndex[sfreq].s[10] + j * sb;
               sb = sfBandIndex[sfreq].s[12]-sfBandIndex[sfreq].s[11];
               i = 3*sfBandIndex[sfreq].s[11] + j * sb;
               for ( ; sb > 0; sb-- )
    976c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
    9770:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    9774:	7f ca                	jg     9740 <III_stereo+0x882>
                      i++;
                   }
                }
            }
         } else
         {  for ( j=0; j<3; j++ )
    9776:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    977a:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
    977e:	0f 8e ee fc ff ff    	jle    9472 <III_stereo+0x5b4>
   for ( i=0; i<576; i++ )
      is_pos[i] = 7;

   if ((stereo == 2) && i_stereo )
   {  if (gr_info->window_switching_flag && (gr_info->block_type == 2))
      {  if( gr_info->mixed_block_flag )
    9784:	e9 f0 01 00 00       	jmp    9979 <III_stereo+0xabb>
                  i++;
               }
            }
         }
      } else
      {  i = 31;
    9789:	c7 45 f0 1f 00 00 00 	movl   $0x1f,-0x10(%ebp)
         ss = 17;
    9790:	c7 45 e4 11 00 00 00 	movl   $0x11,-0x1c(%ebp)
         sb = 0;
    9797:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
         while ( i >= 0 )
    979e:	eb 63                	jmp    9803 <III_stereo+0x945>
         {  if ( xr[1][i][ss] != 0.0 )
    97a0:	8b 45 08             	mov    0x8(%ebp),%eax
    97a3:	8d 88 00 12 00 00    	lea    0x1200(%eax),%ecx
    97a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
    97ac:	89 d0                	mov    %edx,%eax
    97ae:	c1 e0 03             	shl    $0x3,%eax
    97b1:	01 d0                	add    %edx,%eax
    97b3:	01 c0                	add    %eax,%eax
    97b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    97b8:	01 d0                	add    %edx,%eax
    97ba:	dd 04 c1             	fldl   (%ecx,%eax,8)
    97bd:	d9 ee                	fldz   
    97bf:	df e9                	fucomip %st(1),%st
    97c1:	7a 0a                	jp     97cd <III_stereo+0x90f>
    97c3:	d9 ee                	fldz   
    97c5:	df e9                	fucomip %st(1),%st
    97c7:	dd d8                	fstp   %st(0)
    97c9:	74 23                	je     97ee <III_stereo+0x930>
    97cb:	eb 02                	jmp    97cf <III_stereo+0x911>
    97cd:	dd d8                	fstp   %st(0)
            {  sb = i*18+ss;
    97cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
    97d2:	89 d0                	mov    %edx,%eax
    97d4:	c1 e0 03             	shl    $0x3,%eax
    97d7:	01 d0                	add    %edx,%eax
    97d9:	01 c0                	add    %eax,%eax
    97db:	89 c2                	mov    %eax,%edx
    97dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    97e0:	01 d0                	add    %edx,%eax
    97e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
               i = -1;
    97e5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    97ec:	eb 15                	jmp    9803 <III_stereo+0x945>
            } else
            {  ss--;
    97ee:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
               if ( ss < 0 )
    97f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    97f6:	79 0b                	jns    9803 <III_stereo+0x945>
               {  i--;
    97f8:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
                  ss = 17;
    97fc:	c7 45 e4 11 00 00 00 	movl   $0x11,-0x1c(%ebp)
         }
      } else
      {  i = 31;
         ss = 17;
         sb = 0;
         while ( i >= 0 )
    9803:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    9807:	79 97                	jns    97a0 <III_stereo+0x8e2>
               {  i--;
                  ss = 17;
               }
            }
         }
         i = 0;
    9809:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
         while ( sfBandIndex[sfreq].l[i] <= sb )
    9810:	eb 04                	jmp    9816 <III_stereo+0x958>
            i++;
    9812:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
                  ss = 17;
               }
            }
         }
         i = 0;
         while ( sfBandIndex[sfreq].l[i] <= sb )
    9816:	8b 55 c8             	mov    -0x38(%ebp),%edx
    9819:	89 d0                	mov    %edx,%eax
    981b:	c1 e0 03             	shl    $0x3,%eax
    981e:	01 d0                	add    %edx,%eax
    9820:	c1 e0 02             	shl    $0x2,%eax
    9823:	01 d0                	add    %edx,%eax
    9825:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9828:	01 d0                	add    %edx,%eax
    982a:	8b 04 85 80 e9 00 00 	mov    0xe980(,%eax,4),%eax
    9831:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    9834:	7e dc                	jle    9812 <III_stereo+0x954>
            i++;
         sfb = i;
    9836:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9839:	89 45 f4             	mov    %eax,-0xc(%ebp)
         i = sfBandIndex[sfreq].l[i];
    983c:	8b 55 c8             	mov    -0x38(%ebp),%edx
    983f:	89 d0                	mov    %edx,%eax
    9841:	c1 e0 03             	shl    $0x3,%eax
    9844:	01 d0                	add    %edx,%eax
    9846:	c1 e0 02             	shl    $0x2,%eax
    9849:	01 d0                	add    %edx,%eax
    984b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    984e:	01 d0                	add    %edx,%eax
    9850:	8b 04 85 80 e9 00 00 	mov    0xe980(,%eax,4),%eax
    9857:	89 45 f0             	mov    %eax,-0x10(%ebp)
         for ( ; sfb<21; sfb++ )
    985a:	e9 a9 00 00 00       	jmp    9908 <III_stereo+0xa4a>
         {  sb = sfBandIndex[sfreq].l[sfb+1] - sfBandIndex[sfreq].l[sfb];
    985f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9862:	8d 48 01             	lea    0x1(%eax),%ecx
    9865:	8b 55 c8             	mov    -0x38(%ebp),%edx
    9868:	89 d0                	mov    %edx,%eax
    986a:	c1 e0 03             	shl    $0x3,%eax
    986d:	01 d0                	add    %edx,%eax
    986f:	c1 e0 02             	shl    $0x2,%eax
    9872:	01 d0                	add    %edx,%eax
    9874:	01 c8                	add    %ecx,%eax
    9876:	8b 0c 85 80 e9 00 00 	mov    0xe980(,%eax,4),%ecx
    987d:	8b 55 c8             	mov    -0x38(%ebp),%edx
    9880:	89 d0                	mov    %edx,%eax
    9882:	c1 e0 03             	shl    $0x3,%eax
    9885:	01 d0                	add    %edx,%eax
    9887:	c1 e0 02             	shl    $0x2,%eax
    988a:	01 d0                	add    %edx,%eax
    988c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    988f:	01 d0                	add    %edx,%eax
    9891:	8b 04 85 80 e9 00 00 	mov    0xe980(,%eax,4),%eax
    9898:	29 c1                	sub    %eax,%ecx
    989a:	89 c8                	mov    %ecx,%eax
    989c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            for ( ; sb > 0; sb--)
    989f:	eb 5d                	jmp    98fe <III_stereo+0xa40>
            {  is_pos[i] = (*scalefac)[1].l[sfb];
    98a1:	8b 45 10             	mov    0x10(%ebp),%eax
    98a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    98a7:	83 c2 3e             	add    $0x3e,%edx
    98aa:	8b 14 90             	mov    (%eax,%edx,4),%edx
    98ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
    98b0:	89 94 85 bc f6 ff ff 	mov    %edx,-0x944(%ebp,%eax,4)
               if ( is_pos[i] != 7 )
    98b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    98ba:	8b 84 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%eax
    98c1:	83 f8 07             	cmp    $0x7,%eax
    98c4:	74 30                	je     98f6 <III_stereo+0xa38>
                  is_ratio[i] = tan( is_pos[i] * (PI / 12));
    98c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    98c9:	8b 84 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%eax
    98d0:	89 85 b4 e4 ff ff    	mov    %eax,-0x1b4c(%ebp)
    98d6:	db 85 b4 e4 ff ff    	fildl  -0x1b4c(%ebp)
    98dc:	dd 05 60 d6 00 00    	fldl   0xd660
    98e2:	de c9                	fmulp  %st,%st(1)
    98e4:	dd 1c 24             	fstpl  (%esp)
    98e7:	e8 fb ae ff ff       	call   47e7 <tan>
    98ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
    98ef:	dd 9c c5 b8 e4 ff ff 	fstpl  -0x1b48(%ebp,%eax,8)
               i++;
    98f6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
            i++;
         sfb = i;
         i = sfBandIndex[sfreq].l[i];
         for ( ; sfb<21; sfb++ )
         {  sb = sfBandIndex[sfreq].l[sfb+1] - sfBandIndex[sfreq].l[sfb];
            for ( ; sb > 0; sb--)
    98fa:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
    98fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    9902:	7f 9d                	jg     98a1 <III_stereo+0x9e3>
         i = 0;
         while ( sfBandIndex[sfreq].l[i] <= sb )
            i++;
         sfb = i;
         i = sfBandIndex[sfreq].l[i];
         for ( ; sfb<21; sfb++ )
    9904:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9908:	83 7d f4 14          	cmpl   $0x14,-0xc(%ebp)
    990c:	0f 8e 4d ff ff ff    	jle    985f <III_stereo+0x9a1>
               if ( is_pos[i] != 7 )
                  is_ratio[i] = tan( is_pos[i] * (PI / 12));
               i++;
            }
         }
         sfb = sfBandIndex[sfreq].l[20];
    9912:	8b 45 c8             	mov    -0x38(%ebp),%eax
    9915:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    991b:	05 d0 e9 00 00       	add    $0xe9d0,%eax
    9920:	8b 00                	mov    (%eax),%eax
    9922:	89 45 f4             	mov    %eax,-0xc(%ebp)
         for ( sb = 576 - sfBandIndex[sfreq].l[21]; sb > 0; sb-- )
    9925:	8b 45 c8             	mov    -0x38(%ebp),%eax
    9928:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
    992e:	05 d4 e9 00 00       	add    $0xe9d4,%eax
    9933:	8b 00                	mov    (%eax),%eax
    9935:	ba 40 02 00 00       	mov    $0x240,%edx
    993a:	29 c2                	sub    %eax,%edx
    993c:	89 d0                	mov    %edx,%eax
    993e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    9941:	eb 30                	jmp    9973 <III_stereo+0xab5>
         {  is_pos[i] = is_pos[sfb];
    9943:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9946:	8b 94 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%edx
    994d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9950:	89 94 85 bc f6 ff ff 	mov    %edx,-0x944(%ebp,%eax,4)
            is_ratio[i] = is_ratio[sfb];
    9957:	8b 45 f4             	mov    -0xc(%ebp),%eax
    995a:	dd 84 c5 b8 e4 ff ff 	fldl   -0x1b48(%ebp,%eax,8)
    9961:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9964:	dd 9c c5 b8 e4 ff ff 	fstpl  -0x1b48(%ebp,%eax,8)
            i++;
    996b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
                  is_ratio[i] = tan( is_pos[i] * (PI / 12));
               i++;
            }
         }
         sfb = sfBandIndex[sfreq].l[20];
         for ( sb = 576 - sfBandIndex[sfreq].l[21]; sb > 0; sb-- )
    996f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
    9973:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    9977:	7f ca                	jg     9943 <III_stereo+0xa85>
            i++;
         }
      }
   }

   for(ch=0;ch<2;ch++)
    9979:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    9980:	eb 55                	jmp    99d7 <III_stereo+0xb19>
      for(sb=0;sb<SBLIMIT;sb++)
    9982:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    9989:	eb 42                	jmp    99cd <III_stereo+0xb0f>
         for(ss=0;ss<SSLIMIT;ss++)
    998b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    9992:	eb 2f                	jmp    99c3 <III_stereo+0xb05>
            lr[ch][sb][ss] = 0;
    9994:	8b 55 e0             	mov    -0x20(%ebp),%edx
    9997:	89 d0                	mov    %edx,%eax
    9999:	c1 e0 03             	shl    $0x3,%eax
    999c:	01 d0                	add    %edx,%eax
    999e:	c1 e0 09             	shl    $0x9,%eax
    99a1:	89 c2                	mov    %eax,%edx
    99a3:	8b 45 0c             	mov    0xc(%ebp),%eax
    99a6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    99a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
    99ac:	89 d0                	mov    %edx,%eax
    99ae:	c1 e0 03             	shl    $0x3,%eax
    99b1:	01 d0                	add    %edx,%eax
    99b3:	01 c0                	add    %eax,%eax
    99b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    99b8:	01 d0                	add    %edx,%eax
    99ba:	d9 ee                	fldz   
    99bc:	dd 1c c1             	fstpl  (%ecx,%eax,8)
      }
   }

   for(ch=0;ch<2;ch++)
      for(sb=0;sb<SBLIMIT;sb++)
         for(ss=0;ss<SSLIMIT;ss++)
    99bf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    99c3:	83 7d e4 11          	cmpl   $0x11,-0x1c(%ebp)
    99c7:	7e cb                	jle    9994 <III_stereo+0xad6>
         }
      }
   }

   for(ch=0;ch<2;ch++)
      for(sb=0;sb<SBLIMIT;sb++)
    99c9:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    99cd:	83 7d e8 1f          	cmpl   $0x1f,-0x18(%ebp)
    99d1:	7e b8                	jle    998b <III_stereo+0xacd>
            i++;
         }
      }
   }

   for(ch=0;ch<2;ch++)
    99d3:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    99d7:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
    99db:	7e a5                	jle    9982 <III_stereo+0xac4>
      for(sb=0;sb<SBLIMIT;sb++)
         for(ss=0;ss<SSLIMIT;ss++)
            lr[ch][sb][ss] = 0;

   if (stereo==2)
    99dd:	83 7d c4 02          	cmpl   $0x2,-0x3c(%ebp)
    99e1:	0f 85 3d 02 00 00    	jne    9c24 <III_stereo+0xd66>
      for(sb=0;sb<SBLIMIT;sb++)
    99e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    99ee:	e9 25 02 00 00       	jmp    9c18 <III_stereo+0xd5a>
         for(ss=0;ss<SSLIMIT;ss++) {
    99f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    99fa:	e9 0b 02 00 00       	jmp    9c0a <III_stereo+0xd4c>
            i = (sb*18)+ss;
    99ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9a02:	89 d0                	mov    %edx,%eax
    9a04:	c1 e0 03             	shl    $0x3,%eax
    9a07:	01 d0                	add    %edx,%eax
    9a09:	01 c0                	add    %eax,%eax
    9a0b:	89 c2                	mov    %eax,%edx
    9a0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    9a10:	01 d0                	add    %edx,%eax
    9a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
            if ( is_pos[i] == 7 ) {
    9a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9a18:	8b 84 85 bc f6 ff ff 	mov    -0x944(%ebp,%eax,4),%eax
    9a1f:	83 f8 07             	cmp    $0x7,%eax
    9a22:	0f 85 2c 01 00 00    	jne    9b54 <III_stereo+0xc96>
               if ( ms_stereo ) {
    9a28:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
    9a2c:	0f 84 b5 00 00 00    	je     9ae7 <III_stereo+0xc29>
                  lr[0][sb][ss] = (xr[0][sb][ss]+xr[1][sb][ss])/1.41421356;
    9a32:	8b 4d 08             	mov    0x8(%ebp),%ecx
    9a35:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9a38:	89 d0                	mov    %edx,%eax
    9a3a:	c1 e0 03             	shl    $0x3,%eax
    9a3d:	01 d0                	add    %edx,%eax
    9a3f:	01 c0                	add    %eax,%eax
    9a41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9a44:	01 d0                	add    %edx,%eax
    9a46:	dd 04 c1             	fldl   (%ecx,%eax,8)
    9a49:	8b 45 08             	mov    0x8(%ebp),%eax
    9a4c:	8d 88 00 12 00 00    	lea    0x1200(%eax),%ecx
    9a52:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9a55:	89 d0                	mov    %edx,%eax
    9a57:	c1 e0 03             	shl    $0x3,%eax
    9a5a:	01 d0                	add    %edx,%eax
    9a5c:	01 c0                	add    %eax,%eax
    9a5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9a61:	01 d0                	add    %edx,%eax
    9a63:	dd 04 c1             	fldl   (%ecx,%eax,8)
    9a66:	de c1                	faddp  %st,%st(1)
    9a68:	dd 05 68 d6 00 00    	fldl   0xd668
    9a6e:	de f9                	fdivrp %st,%st(1)
    9a70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    9a73:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9a76:	89 d0                	mov    %edx,%eax
    9a78:	c1 e0 03             	shl    $0x3,%eax
    9a7b:	01 d0                	add    %edx,%eax
    9a7d:	01 c0                	add    %eax,%eax
    9a7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9a82:	01 d0                	add    %edx,%eax
    9a84:	dd 1c c1             	fstpl  (%ecx,%eax,8)
                  lr[1][sb][ss] = (xr[0][sb][ss]-xr[1][sb][ss])/1.41421356;
    9a87:	8b 45 0c             	mov    0xc(%ebp),%eax
    9a8a:	8d 98 00 12 00 00    	lea    0x1200(%eax),%ebx
    9a90:	8b 4d 08             	mov    0x8(%ebp),%ecx
    9a93:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9a96:	89 d0                	mov    %edx,%eax
    9a98:	c1 e0 03             	shl    $0x3,%eax
    9a9b:	01 d0                	add    %edx,%eax
    9a9d:	01 c0                	add    %eax,%eax
    9a9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9aa2:	01 d0                	add    %edx,%eax
    9aa4:	dd 04 c1             	fldl   (%ecx,%eax,8)
    9aa7:	8b 45 08             	mov    0x8(%ebp),%eax
    9aaa:	8d 88 00 12 00 00    	lea    0x1200(%eax),%ecx
    9ab0:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9ab3:	89 d0                	mov    %edx,%eax
    9ab5:	c1 e0 03             	shl    $0x3,%eax
    9ab8:	01 d0                	add    %edx,%eax
    9aba:	01 c0                	add    %eax,%eax
    9abc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9abf:	01 d0                	add    %edx,%eax
    9ac1:	dd 04 c1             	fldl   (%ecx,%eax,8)
    9ac4:	de e9                	fsubrp %st,%st(1)
    9ac6:	dd 05 68 d6 00 00    	fldl   0xd668
    9acc:	de f9                	fdivrp %st,%st(1)
    9ace:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9ad1:	89 d0                	mov    %edx,%eax
    9ad3:	c1 e0 03             	shl    $0x3,%eax
    9ad6:	01 d0                	add    %edx,%eax
    9ad8:	01 c0                	add    %eax,%eax
    9ada:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9add:	01 d0                	add    %edx,%eax
    9adf:	dd 1c c3             	fstpl  (%ebx,%eax,8)
    9ae2:	e9 1f 01 00 00       	jmp    9c06 <III_stereo+0xd48>
               }
               else {
                  lr[0][sb][ss] = xr[0][sb][ss];
    9ae7:	8b 4d 08             	mov    0x8(%ebp),%ecx
    9aea:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9aed:	89 d0                	mov    %edx,%eax
    9aef:	c1 e0 03             	shl    $0x3,%eax
    9af2:	01 d0                	add    %edx,%eax
    9af4:	01 c0                	add    %eax,%eax
    9af6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9af9:	01 d0                	add    %edx,%eax
    9afb:	dd 04 c1             	fldl   (%ecx,%eax,8)
    9afe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    9b01:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9b04:	89 d0                	mov    %edx,%eax
    9b06:	c1 e0 03             	shl    $0x3,%eax
    9b09:	01 d0                	add    %edx,%eax
    9b0b:	01 c0                	add    %eax,%eax
    9b0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9b10:	01 d0                	add    %edx,%eax
    9b12:	dd 1c c1             	fstpl  (%ecx,%eax,8)
                  lr[1][sb][ss] = xr[1][sb][ss];
    9b15:	8b 45 0c             	mov    0xc(%ebp),%eax
    9b18:	8d 88 00 12 00 00    	lea    0x1200(%eax),%ecx
    9b1e:	8b 45 08             	mov    0x8(%ebp),%eax
    9b21:	8d 98 00 12 00 00    	lea    0x1200(%eax),%ebx
    9b27:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9b2a:	89 d0                	mov    %edx,%eax
    9b2c:	c1 e0 03             	shl    $0x3,%eax
    9b2f:	01 d0                	add    %edx,%eax
    9b31:	01 c0                	add    %eax,%eax
    9b33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9b36:	01 d0                	add    %edx,%eax
    9b38:	dd 04 c3             	fldl   (%ebx,%eax,8)
    9b3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9b3e:	89 d0                	mov    %edx,%eax
    9b40:	c1 e0 03             	shl    $0x3,%eax
    9b43:	01 d0                	add    %edx,%eax
    9b45:	01 c0                	add    %eax,%eax
    9b47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9b4a:	01 d0                	add    %edx,%eax
    9b4c:	dd 1c c1             	fstpl  (%ecx,%eax,8)
    9b4f:	e9 b2 00 00 00       	jmp    9c06 <III_stereo+0xd48>
               }
            }
            else if (i_stereo ) {
    9b54:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
    9b58:	0f 84 94 00 00 00    	je     9bf2 <III_stereo+0xd34>
               lr[0][sb][ss] = xr[0][sb][ss] * (is_ratio[i]/(1+is_ratio[i]));
    9b5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    9b61:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9b64:	89 d0                	mov    %edx,%eax
    9b66:	c1 e0 03             	shl    $0x3,%eax
    9b69:	01 d0                	add    %edx,%eax
    9b6b:	01 c0                	add    %eax,%eax
    9b6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9b70:	01 d0                	add    %edx,%eax
    9b72:	dd 04 c1             	fldl   (%ecx,%eax,8)
    9b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9b78:	dd 84 c5 b8 e4 ff ff 	fldl   -0x1b48(%ebp,%eax,8)
    9b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9b82:	dd 84 c5 b8 e4 ff ff 	fldl   -0x1b48(%ebp,%eax,8)
    9b89:	d9 e8                	fld1   
    9b8b:	de c1                	faddp  %st,%st(1)
    9b8d:	de f9                	fdivrp %st,%st(1)
    9b8f:	de c9                	fmulp  %st,%st(1)
    9b91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    9b94:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9b97:	89 d0                	mov    %edx,%eax
    9b99:	c1 e0 03             	shl    $0x3,%eax
    9b9c:	01 d0                	add    %edx,%eax
    9b9e:	01 c0                	add    %eax,%eax
    9ba0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9ba3:	01 d0                	add    %edx,%eax
    9ba5:	dd 1c c1             	fstpl  (%ecx,%eax,8)
               lr[1][sb][ss] = xr[0][sb][ss] * (1/(1+is_ratio[i]));
    9ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
    9bab:	8d 98 00 12 00 00    	lea    0x1200(%eax),%ebx
    9bb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
    9bb4:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9bb7:	89 d0                	mov    %edx,%eax
    9bb9:	c1 e0 03             	shl    $0x3,%eax
    9bbc:	01 d0                	add    %edx,%eax
    9bbe:	01 c0                	add    %eax,%eax
    9bc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9bc3:	01 d0                	add    %edx,%eax
    9bc5:	dd 04 c1             	fldl   (%ecx,%eax,8)
    9bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9bcb:	dd 84 c5 b8 e4 ff ff 	fldl   -0x1b48(%ebp,%eax,8)
    9bd2:	d9 e8                	fld1   
    9bd4:	de c1                	faddp  %st,%st(1)
    9bd6:	d9 e8                	fld1   
    9bd8:	de f1                	fdivp  %st,%st(1)
    9bda:	de c9                	fmulp  %st,%st(1)
    9bdc:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9bdf:	89 d0                	mov    %edx,%eax
    9be1:	c1 e0 03             	shl    $0x3,%eax
    9be4:	01 d0                	add    %edx,%eax
    9be6:	01 c0                	add    %eax,%eax
    9be8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9beb:	01 d0                	add    %edx,%eax
    9bed:	dd 1c c3             	fstpl  (%ebx,%eax,8)
    9bf0:	eb 14                	jmp    9c06 <III_stereo+0xd48>
            }
            else {
               printf(0,"Error in streo processing\n");
    9bf2:	c7 44 24 04 00 c6 00 	movl   $0xc600,0x4(%esp)
    9bf9:	00 
    9bfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    9c01:	e8 3c a7 ff ff       	call   4342 <printf>
         for(ss=0;ss<SSLIMIT;ss++)
            lr[ch][sb][ss] = 0;

   if (stereo==2)
      for(sb=0;sb<SBLIMIT;sb++)
         for(ss=0;ss<SSLIMIT;ss++) {
    9c06:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    9c0a:	83 7d e4 11          	cmpl   $0x11,-0x1c(%ebp)
    9c0e:	0f 8e eb fd ff ff    	jle    99ff <III_stereo+0xb41>
      for(sb=0;sb<SBLIMIT;sb++)
         for(ss=0;ss<SSLIMIT;ss++)
            lr[ch][sb][ss] = 0;

   if (stereo==2)
      for(sb=0;sb<SBLIMIT;sb++)
    9c14:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    9c18:	83 7d e8 1f          	cmpl   $0x1f,-0x18(%ebp)
    9c1c:	0f 8e d1 fd ff ff    	jle    99f3 <III_stereo+0xb35>
    9c22:	eb 54                	jmp    9c78 <III_stereo+0xdba>
            else {
               printf(0,"Error in streo processing\n");
            }
         }
   else  /* mono , bypass xr[0][][] to lr[0][][]*/
      for(sb=0;sb<SBLIMIT;sb++)
    9c24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    9c2b:	eb 45                	jmp    9c72 <III_stereo+0xdb4>
         for(ss=0;ss<SSLIMIT;ss++)
    9c2d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    9c34:	eb 32                	jmp    9c68 <III_stereo+0xdaa>
            lr[0][sb][ss] = xr[0][sb][ss];
    9c36:	8b 4d 08             	mov    0x8(%ebp),%ecx
    9c39:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9c3c:	89 d0                	mov    %edx,%eax
    9c3e:	c1 e0 03             	shl    $0x3,%eax
    9c41:	01 d0                	add    %edx,%eax
    9c43:	01 c0                	add    %eax,%eax
    9c45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9c48:	01 d0                	add    %edx,%eax
    9c4a:	dd 04 c1             	fldl   (%ecx,%eax,8)
    9c4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    9c50:	8b 55 e8             	mov    -0x18(%ebp),%edx
    9c53:	89 d0                	mov    %edx,%eax
    9c55:	c1 e0 03             	shl    $0x3,%eax
    9c58:	01 d0                	add    %edx,%eax
    9c5a:	01 c0                	add    %eax,%eax
    9c5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    9c5f:	01 d0                	add    %edx,%eax
    9c61:	dd 1c c1             	fstpl  (%ecx,%eax,8)
               printf(0,"Error in streo processing\n");
            }
         }
   else  /* mono , bypass xr[0][][] to lr[0][][]*/
      for(sb=0;sb<SBLIMIT;sb++)
         for(ss=0;ss<SSLIMIT;ss++)
    9c64:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    9c68:	83 7d e4 11          	cmpl   $0x11,-0x1c(%ebp)
    9c6c:	7e c8                	jle    9c36 <III_stereo+0xd78>
            else {
               printf(0,"Error in streo processing\n");
            }
         }
   else  /* mono , bypass xr[0][][] to lr[0][][]*/
      for(sb=0;sb<SBLIMIT;sb++)
    9c6e:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    9c72:	83 7d e8 1f          	cmpl   $0x1f,-0x18(%ebp)
    9c76:	7e b5                	jle    9c2d <III_stereo+0xd6f>
         for(ss=0;ss<SSLIMIT;ss++)
            lr[0][sb][ss] = xr[0][sb][ss];

}
    9c78:	81 c4 50 1b 00 00    	add    $0x1b50,%esp
    9c7e:	5b                   	pop    %ebx
    9c7f:	5e                   	pop    %esi
    9c80:	5d                   	pop    %ebp
    9c81:	c3                   	ret    

00009c82 <III_antialias>:


double Ci[8]={-0.6,-0.535,-0.33,-0.185,-0.095,-0.041,-0.0142,-0.0037};
void III_antialias(double xr[SBLIMIT][SSLIMIT], double hybridIn[SBLIMIT][SSLIMIT], struct gr_info_s *gr_info, struct frame_params *fr_ps)
{
    9c82:	55                   	push   %ebp
    9c83:	89 e5                	mov    %esp,%ebp
    9c85:	83 ec 48             	sub    $0x48,%esp
   static int    init = 1;
   static double ca[8],cs[8];
   double        bu,bd;  /* upper and lower butterfly inputs */
   int           ss,sb,sblim;

   if (init) {
    9c88:	a1 e0 eb 00 00       	mov    0xebe0,%eax
    9c8d:	85 c0                	test   %eax,%eax
    9c8f:	74 68                	je     9cf9 <III_antialias+0x77>
      int i;
      double    sq;
      for (i=0;i<8;i++) {
    9c91:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    9c98:	eb 4f                	jmp    9ce9 <III_antialias+0x67>
         sq=sqrt(1.0+Ci[i]*Ci[i]);
    9c9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    9c9d:	dd 04 c5 a0 eb 00 00 	fldl   0xeba0(,%eax,8)
    9ca4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    9ca7:	dd 04 c5 a0 eb 00 00 	fldl   0xeba0(,%eax,8)
    9cae:	de c9                	fmulp  %st,%st(1)
    9cb0:	d9 e8                	fld1   
    9cb2:	de c1                	faddp  %st,%st(1)
    9cb4:	dd 1c 24             	fstpl  (%esp)
    9cb7:	e8 de ac ff ff       	call   499a <sqrt>
    9cbc:	dd 5d e0             	fstpl  -0x20(%ebp)
         cs[i] = 1.0/sq;
    9cbf:	d9 e8                	fld1   
    9cc1:	dc 75 e0             	fdivl  -0x20(%ebp)
    9cc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    9cc7:	dd 1c c5 40 ec 00 00 	fstpl  0xec40(,%eax,8)
         ca[i] = Ci[i]/sq;
    9cce:	8b 45 e8             	mov    -0x18(%ebp),%eax
    9cd1:	dd 04 c5 a0 eb 00 00 	fldl   0xeba0(,%eax,8)
    9cd8:	dc 75 e0             	fdivl  -0x20(%ebp)
    9cdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    9cde:	dd 1c c5 80 ec 00 00 	fstpl  0xec80(,%eax,8)
   int           ss,sb,sblim;

   if (init) {
      int i;
      double    sq;
      for (i=0;i<8;i++) {
    9ce5:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    9ce9:	83 7d e8 07          	cmpl   $0x7,-0x18(%ebp)
    9ced:	7e ab                	jle    9c9a <III_antialias+0x18>
         sq=sqrt(1.0+Ci[i]*Ci[i]);
         cs[i] = 1.0/sq;
         ca[i] = Ci[i]/sq;
      }
      init = 0;
    9cef:	c7 05 e0 eb 00 00 00 	movl   $0x0,0xebe0
    9cf6:	00 00 00 
   }

   /* clear all inputs */

    for(sb=0;sb<SBLIMIT;sb++)
    9cf9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    9d00:	eb 4c                	jmp    9d4e <III_antialias+0xcc>
       for(ss=0;ss<SSLIMIT;ss++)
    9d02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9d09:	eb 39                	jmp    9d44 <III_antialias+0xc2>
          hybridIn[sb][ss] = xr[sb][ss];
    9d0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9d0e:	89 d0                	mov    %edx,%eax
    9d10:	c1 e0 03             	shl    $0x3,%eax
    9d13:	01 d0                	add    %edx,%eax
    9d15:	c1 e0 04             	shl    $0x4,%eax
    9d18:	89 c2                	mov    %eax,%edx
    9d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
    9d1d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    9d20:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9d23:	89 d0                	mov    %edx,%eax
    9d25:	c1 e0 03             	shl    $0x3,%eax
    9d28:	01 d0                	add    %edx,%eax
    9d2a:	c1 e0 04             	shl    $0x4,%eax
    9d2d:	89 c2                	mov    %eax,%edx
    9d2f:	8b 45 08             	mov    0x8(%ebp),%eax
    9d32:	01 c2                	add    %eax,%edx
    9d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9d37:	dd 04 c2             	fldl   (%edx,%eax,8)
    9d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9d3d:	dd 1c c1             	fstpl  (%ecx,%eax,8)
   }

   /* clear all inputs */

    for(sb=0;sb<SBLIMIT;sb++)
       for(ss=0;ss<SSLIMIT;ss++)
    9d40:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9d44:	83 7d f4 11          	cmpl   $0x11,-0xc(%ebp)
    9d48:	7e c1                	jle    9d0b <III_antialias+0x89>
      init = 0;
   }

   /* clear all inputs */

    for(sb=0;sb<SBLIMIT;sb++)
    9d4a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    9d4e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
    9d52:	7e ae                	jle    9d02 <III_antialias+0x80>
       for(ss=0;ss<SSLIMIT;ss++)
          hybridIn[sb][ss] = xr[sb][ss];

   if  (gr_info->window_switching_flag && (gr_info->block_type == 2) &&
    9d54:	8b 45 10             	mov    0x10(%ebp),%eax
    9d57:	8b 40 10             	mov    0x10(%eax),%eax
    9d5a:	85 c0                	test   %eax,%eax
    9d5c:	74 1a                	je     9d78 <III_antialias+0xf6>
    9d5e:	8b 45 10             	mov    0x10(%ebp),%eax
    9d61:	8b 40 14             	mov    0x14(%eax),%eax
    9d64:	83 f8 02             	cmp    $0x2,%eax
    9d67:	75 0f                	jne    9d78 <III_antialias+0xf6>
       !gr_info->mixed_block_flag ) return;
    9d69:	8b 45 10             	mov    0x10(%ebp),%eax
    9d6c:	8b 40 18             	mov    0x18(%eax),%eax

    for(sb=0;sb<SBLIMIT;sb++)
       for(ss=0;ss<SSLIMIT;ss++)
          hybridIn[sb][ss] = xr[sb][ss];

   if  (gr_info->window_switching_flag && (gr_info->block_type == 2) &&
    9d6f:	85 c0                	test   %eax,%eax
    9d71:	75 05                	jne    9d78 <III_antialias+0xf6>
       !gr_info->mixed_block_flag ) return;
    9d73:	e9 1c 01 00 00       	jmp    9e94 <III_antialias+0x212>

   if ( gr_info->window_switching_flag && gr_info->mixed_block_flag &&
    9d78:	8b 45 10             	mov    0x10(%ebp),%eax
    9d7b:	8b 40 10             	mov    0x10(%eax),%eax
    9d7e:	85 c0                	test   %eax,%eax
    9d80:	74 1e                	je     9da0 <III_antialias+0x11e>
    9d82:	8b 45 10             	mov    0x10(%ebp),%eax
    9d85:	8b 40 18             	mov    0x18(%eax),%eax
    9d88:	85 c0                	test   %eax,%eax
    9d8a:	74 14                	je     9da0 <III_antialias+0x11e>
     (gr_info->block_type == 2))
    9d8c:	8b 45 10             	mov    0x10(%ebp),%eax
    9d8f:	8b 40 14             	mov    0x14(%eax),%eax
          hybridIn[sb][ss] = xr[sb][ss];

   if  (gr_info->window_switching_flag && (gr_info->block_type == 2) &&
       !gr_info->mixed_block_flag ) return;

   if ( gr_info->window_switching_flag && gr_info->mixed_block_flag &&
    9d92:	83 f8 02             	cmp    $0x2,%eax
    9d95:	75 09                	jne    9da0 <III_antialias+0x11e>
     (gr_info->block_type == 2))
      sblim = 1;
    9d97:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    9d9e:	eb 07                	jmp    9da7 <III_antialias+0x125>
   else
      sblim = SBLIMIT-1;
    9da0:	c7 45 ec 1f 00 00 00 	movl   $0x1f,-0x14(%ebp)

   /* 31 alias-reduction operations between each pair of sub-bands */
   /* with 8 butterflies between each pair                         */

   for(sb=0;sb<sblim;sb++)
    9da7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    9dae:	e9 d5 00 00 00       	jmp    9e88 <III_antialias+0x206>
      for(ss=0;ss<8;ss++) {
    9db3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9dba:	e9 bb 00 00 00       	jmp    9e7a <III_antialias+0x1f8>
         bu = xr[sb][17-ss];
    9dbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9dc2:	89 d0                	mov    %edx,%eax
    9dc4:	c1 e0 03             	shl    $0x3,%eax
    9dc7:	01 d0                	add    %edx,%eax
    9dc9:	c1 e0 04             	shl    $0x4,%eax
    9dcc:	89 c2                	mov    %eax,%edx
    9dce:	8b 45 08             	mov    0x8(%ebp),%eax
    9dd1:	01 c2                	add    %eax,%edx
    9dd3:	b8 11 00 00 00       	mov    $0x11,%eax
    9dd8:	2b 45 f4             	sub    -0xc(%ebp),%eax
    9ddb:	dd 04 c2             	fldl   (%edx,%eax,8)
    9dde:	dd 5d d8             	fstpl  -0x28(%ebp)
         bd = xr[sb+1][ss];
    9de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9de4:	8d 50 01             	lea    0x1(%eax),%edx
    9de7:	89 d0                	mov    %edx,%eax
    9de9:	c1 e0 03             	shl    $0x3,%eax
    9dec:	01 d0                	add    %edx,%eax
    9dee:	c1 e0 04             	shl    $0x4,%eax
    9df1:	89 c2                	mov    %eax,%edx
    9df3:	8b 45 08             	mov    0x8(%ebp),%eax
    9df6:	01 c2                	add    %eax,%edx
    9df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9dfb:	dd 04 c2             	fldl   (%edx,%eax,8)
    9dfe:	dd 5d d0             	fstpl  -0x30(%ebp)
         hybridIn[sb][17-ss] = (bu * cs[ss]) - (bd * ca[ss]);
    9e01:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9e04:	89 d0                	mov    %edx,%eax
    9e06:	c1 e0 03             	shl    $0x3,%eax
    9e09:	01 d0                	add    %edx,%eax
    9e0b:	c1 e0 04             	shl    $0x4,%eax
    9e0e:	89 c2                	mov    %eax,%edx
    9e10:	8b 45 0c             	mov    0xc(%ebp),%eax
    9e13:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    9e16:	b8 11 00 00 00       	mov    $0x11,%eax
    9e1b:	2b 45 f4             	sub    -0xc(%ebp),%eax
    9e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9e21:	dd 04 d5 40 ec 00 00 	fldl   0xec40(,%edx,8)
    9e28:	dc 4d d8             	fmull  -0x28(%ebp)
    9e2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9e2e:	dd 04 d5 80 ec 00 00 	fldl   0xec80(,%edx,8)
    9e35:	dc 4d d0             	fmull  -0x30(%ebp)
    9e38:	de e9                	fsubrp %st,%st(1)
    9e3a:	dd 1c c1             	fstpl  (%ecx,%eax,8)
         hybridIn[sb+1][ss] = (bd * cs[ss]) + (bu * ca[ss]);
    9e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9e40:	8d 50 01             	lea    0x1(%eax),%edx
    9e43:	89 d0                	mov    %edx,%eax
    9e45:	c1 e0 03             	shl    $0x3,%eax
    9e48:	01 d0                	add    %edx,%eax
    9e4a:	c1 e0 04             	shl    $0x4,%eax
    9e4d:	89 c2                	mov    %eax,%edx
    9e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
    9e52:	01 c2                	add    %eax,%edx
    9e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9e57:	dd 04 c5 40 ec 00 00 	fldl   0xec40(,%eax,8)
    9e5e:	dc 4d d0             	fmull  -0x30(%ebp)
    9e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9e64:	dd 04 c5 80 ec 00 00 	fldl   0xec80(,%eax,8)
    9e6b:	dc 4d d8             	fmull  -0x28(%ebp)
    9e6e:	de c1                	faddp  %st,%st(1)
    9e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9e73:	dd 1c c2             	fstpl  (%edx,%eax,8)

   /* 31 alias-reduction operations between each pair of sub-bands */
   /* with 8 butterflies between each pair                         */

   for(sb=0;sb<sblim;sb++)
      for(ss=0;ss<8;ss++) {
    9e76:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9e7a:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
    9e7e:	0f 8e 3b ff ff ff    	jle    9dbf <III_antialias+0x13d>
      sblim = SBLIMIT-1;

   /* 31 alias-reduction operations between each pair of sub-bands */
   /* with 8 butterflies between each pair                         */

   for(sb=0;sb<sblim;sb++)
    9e84:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    9e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9e8b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    9e8e:	0f 8c 1f ff ff ff    	jl     9db3 <III_antialias+0x131>
         bu = xr[sb][17-ss];
         bd = xr[sb+1][ss];
         hybridIn[sb][17-ss] = (bu * cs[ss]) - (bd * ca[ss]);
         hybridIn[sb+1][ss] = (bd * cs[ss]) + (bu * ca[ss]);
         }
}
    9e94:	c9                   	leave  
    9e95:	c3                   	ret    

00009e96 <inv_mdct>:


void inv_mdct(double in[18], double out[36], int block_type)
{
    9e96:	55                   	push   %ebp
    9e97:	89 e5                	mov    %esp,%ebp
    9e99:	81 ec a8 00 00 00    	sub    $0xa8,%esp
	double  tmp[12],sum;
	static  double  win[4][36];
	static  int init=0;
	static  double COS[4*36];

    if(init==0){
    9e9f:	a1 c0 ec 00 00       	mov    0xecc0,%eax
    9ea4:	85 c0                	test   %eax,%eax
    9ea6:	0f 85 59 02 00 00    	jne    a105 <inv_mdct+0x26f>

    /* type 0 */
      for(i=0;i<36;i++)
    9eac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9eb3:	eb 29                	jmp    9ede <inv_mdct+0x48>
         win[0][i] = sin( PI/36 *(i+0.5) );
    9eb5:	db 45 f4             	fildl  -0xc(%ebp)
    9eb8:	dd 05 70 d6 00 00    	fldl   0xd670
    9ebe:	de c1                	faddp  %st,%st(1)
    9ec0:	dd 05 78 d6 00 00    	fldl   0xd678
    9ec6:	de c9                	fmulp  %st,%st(1)
    9ec8:	dd 1c 24             	fstpl  (%esp)
    9ecb:	e8 53 a8 ff ff       	call   4723 <sin>
    9ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9ed3:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
	static  double COS[4*36];

    if(init==0){

    /* type 0 */
      for(i=0;i<36;i++)
    9eda:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9ede:	83 7d f4 23          	cmpl   $0x23,-0xc(%ebp)
    9ee2:	7e d1                	jle    9eb5 <inv_mdct+0x1f>
         win[0][i] = sin( PI/36 *(i+0.5) );

    /* type 1*/
      for(i=0;i<18;i++)
    9ee4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9eeb:	eb 2c                	jmp    9f19 <inv_mdct+0x83>
         win[1][i] = sin( PI/36 *(i+0.5) );
    9eed:	db 45 f4             	fildl  -0xc(%ebp)
    9ef0:	dd 05 70 d6 00 00    	fldl   0xd670
    9ef6:	de c1                	faddp  %st,%st(1)
    9ef8:	dd 05 78 d6 00 00    	fldl   0xd678
    9efe:	de c9                	fmulp  %st,%st(1)
    9f00:	dd 1c 24             	fstpl  (%esp)
    9f03:	e8 1b a8 ff ff       	call   4723 <sin>
    9f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9f0b:	83 c0 24             	add    $0x24,%eax
    9f0e:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
    /* type 0 */
      for(i=0;i<36;i++)
         win[0][i] = sin( PI/36 *(i+0.5) );

    /* type 1*/
      for(i=0;i<18;i++)
    9f15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9f19:	83 7d f4 11          	cmpl   $0x11,-0xc(%ebp)
    9f1d:	7e ce                	jle    9eed <inv_mdct+0x57>
         win[1][i] = sin( PI/36 *(i+0.5) );
      for(i=18;i<24;i++)
    9f1f:	c7 45 f4 12 00 00 00 	movl   $0x12,-0xc(%ebp)
    9f26:	eb 13                	jmp    9f3b <inv_mdct+0xa5>
         win[1][i] = 1.0;
    9f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9f2b:	83 c0 24             	add    $0x24,%eax
    9f2e:	d9 e8                	fld1   
    9f30:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
         win[0][i] = sin( PI/36 *(i+0.5) );

    /* type 1*/
      for(i=0;i<18;i++)
         win[1][i] = sin( PI/36 *(i+0.5) );
      for(i=18;i<24;i++)
    9f37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9f3b:	83 7d f4 17          	cmpl   $0x17,-0xc(%ebp)
    9f3f:	7e e7                	jle    9f28 <inv_mdct+0x92>
         win[1][i] = 1.0;
      for(i=24;i<30;i++)
    9f41:	c7 45 f4 18 00 00 00 	movl   $0x18,-0xc(%ebp)
    9f48:	eb 34                	jmp    9f7e <inv_mdct+0xe8>
         win[1][i] = sin( PI/12 *(i+0.5-18) );
    9f4a:	db 45 f4             	fildl  -0xc(%ebp)
    9f4d:	dd 05 70 d6 00 00    	fldl   0xd670
    9f53:	de c1                	faddp  %st,%st(1)
    9f55:	dd 05 80 d6 00 00    	fldl   0xd680
    9f5b:	de e9                	fsubrp %st,%st(1)
    9f5d:	dd 05 60 d6 00 00    	fldl   0xd660
    9f63:	de c9                	fmulp  %st,%st(1)
    9f65:	dd 1c 24             	fstpl  (%esp)
    9f68:	e8 b6 a7 ff ff       	call   4723 <sin>
    9f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9f70:	83 c0 24             	add    $0x24,%eax
    9f73:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
    /* type 1*/
      for(i=0;i<18;i++)
         win[1][i] = sin( PI/36 *(i+0.5) );
      for(i=18;i<24;i++)
         win[1][i] = 1.0;
      for(i=24;i<30;i++)
    9f7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9f7e:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
    9f82:	7e c6                	jle    9f4a <inv_mdct+0xb4>
         win[1][i] = sin( PI/12 *(i+0.5-18) );
      for(i=30;i<36;i++)
    9f84:	c7 45 f4 1e 00 00 00 	movl   $0x1e,-0xc(%ebp)
    9f8b:	eb 13                	jmp    9fa0 <inv_mdct+0x10a>
         win[1][i] = 0.0;
    9f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9f90:	83 c0 24             	add    $0x24,%eax
    9f93:	d9 ee                	fldz   
    9f95:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
         win[1][i] = sin( PI/36 *(i+0.5) );
      for(i=18;i<24;i++)
         win[1][i] = 1.0;
      for(i=24;i<30;i++)
         win[1][i] = sin( PI/12 *(i+0.5-18) );
      for(i=30;i<36;i++)
    9f9c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9fa0:	83 7d f4 23          	cmpl   $0x23,-0xc(%ebp)
    9fa4:	7e e7                	jle    9f8d <inv_mdct+0xf7>
         win[1][i] = 0.0;

    /* type 3*/
      for(i=0;i<6;i++)
    9fa6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9fad:	eb 13                	jmp    9fc2 <inv_mdct+0x12c>
         win[3][i] = 0.0;
    9faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9fb2:	83 c0 6c             	add    $0x6c,%eax
    9fb5:	d9 ee                	fldz   
    9fb7:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
         win[1][i] = sin( PI/12 *(i+0.5-18) );
      for(i=30;i<36;i++)
         win[1][i] = 0.0;

    /* type 3*/
      for(i=0;i<6;i++)
    9fbe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9fc2:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
    9fc6:	7e e7                	jle    9faf <inv_mdct+0x119>
         win[3][i] = 0.0;
      for(i=6;i<12;i++)
    9fc8:	c7 45 f4 06 00 00 00 	movl   $0x6,-0xc(%ebp)
    9fcf:	eb 34                	jmp    a005 <inv_mdct+0x16f>
         win[3][i] = sin( PI/12 *(i+0.5-6) );
    9fd1:	db 45 f4             	fildl  -0xc(%ebp)
    9fd4:	dd 05 70 d6 00 00    	fldl   0xd670
    9fda:	de c1                	faddp  %st,%st(1)
    9fdc:	dd 05 88 d6 00 00    	fldl   0xd688
    9fe2:	de e9                	fsubrp %st,%st(1)
    9fe4:	dd 05 60 d6 00 00    	fldl   0xd660
    9fea:	de c9                	fmulp  %st,%st(1)
    9fec:	dd 1c 24             	fstpl  (%esp)
    9fef:	e8 2f a7 ff ff       	call   4723 <sin>
    9ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9ff7:	83 c0 6c             	add    $0x6c,%eax
    9ffa:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
         win[1][i] = 0.0;

    /* type 3*/
      for(i=0;i<6;i++)
         win[3][i] = 0.0;
      for(i=6;i<12;i++)
    a001:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a005:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    a009:	7e c6                	jle    9fd1 <inv_mdct+0x13b>
         win[3][i] = sin( PI/12 *(i+0.5-6) );
      for(i=12;i<18;i++)
    a00b:	c7 45 f4 0c 00 00 00 	movl   $0xc,-0xc(%ebp)
    a012:	eb 13                	jmp    a027 <inv_mdct+0x191>
         win[3][i] =1.0;
    a014:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a017:	83 c0 6c             	add    $0x6c,%eax
    a01a:	d9 e8                	fld1   
    a01c:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
    /* type 3*/
      for(i=0;i<6;i++)
         win[3][i] = 0.0;
      for(i=6;i<12;i++)
         win[3][i] = sin( PI/12 *(i+0.5-6) );
      for(i=12;i<18;i++)
    a023:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a027:	83 7d f4 11          	cmpl   $0x11,-0xc(%ebp)
    a02b:	7e e7                	jle    a014 <inv_mdct+0x17e>
         win[3][i] =1.0;
      for(i=18;i<36;i++)
    a02d:	c7 45 f4 12 00 00 00 	movl   $0x12,-0xc(%ebp)
    a034:	eb 2c                	jmp    a062 <inv_mdct+0x1cc>
         win[3][i] = sin( PI/36*(i+0.5) );
    a036:	db 45 f4             	fildl  -0xc(%ebp)
    a039:	dd 05 70 d6 00 00    	fldl   0xd670
    a03f:	de c1                	faddp  %st,%st(1)
    a041:	dd 05 78 d6 00 00    	fldl   0xd678
    a047:	de c9                	fmulp  %st,%st(1)
    a049:	dd 1c 24             	fstpl  (%esp)
    a04c:	e8 d2 a6 ff ff       	call   4723 <sin>
    a051:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a054:	83 c0 6c             	add    $0x6c,%eax
    a057:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
         win[3][i] = 0.0;
      for(i=6;i<12;i++)
         win[3][i] = sin( PI/12 *(i+0.5-6) );
      for(i=12;i<18;i++)
         win[3][i] =1.0;
      for(i=18;i<36;i++)
    a05e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a062:	83 7d f4 23          	cmpl   $0x23,-0xc(%ebp)
    a066:	7e ce                	jle    a036 <inv_mdct+0x1a0>
         win[3][i] = sin( PI/36*(i+0.5) );

    /* type 2*/
      for(i=0;i<12;i++)
    a068:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a06f:	eb 2c                	jmp    a09d <inv_mdct+0x207>
         win[2][i] = sin( PI/12*(i+0.5) ) ;
    a071:	db 45 f4             	fildl  -0xc(%ebp)
    a074:	dd 05 70 d6 00 00    	fldl   0xd670
    a07a:	de c1                	faddp  %st,%st(1)
    a07c:	dd 05 60 d6 00 00    	fldl   0xd660
    a082:	de c9                	fmulp  %st,%st(1)
    a084:	dd 1c 24             	fstpl  (%esp)
    a087:	e8 97 a6 ff ff       	call   4723 <sin>
    a08c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a08f:	83 c0 48             	add    $0x48,%eax
    a092:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
         win[3][i] =1.0;
      for(i=18;i<36;i++)
         win[3][i] = sin( PI/36*(i+0.5) );

    /* type 2*/
      for(i=0;i<12;i++)
    a099:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a09d:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    a0a1:	7e ce                	jle    a071 <inv_mdct+0x1db>
         win[2][i] = sin( PI/12*(i+0.5) ) ;
      for(i=12;i<36;i++)
    a0a3:	c7 45 f4 0c 00 00 00 	movl   $0xc,-0xc(%ebp)
    a0aa:	eb 13                	jmp    a0bf <inv_mdct+0x229>
         win[2][i] = 0.0 ;
    a0ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a0af:	83 c0 48             	add    $0x48,%eax
    a0b2:	d9 ee                	fldz   
    a0b4:	dd 1c c5 e0 ec 00 00 	fstpl  0xece0(,%eax,8)
         win[3][i] = sin( PI/36*(i+0.5) );

    /* type 2*/
      for(i=0;i<12;i++)
         win[2][i] = sin( PI/12*(i+0.5) ) ;
      for(i=12;i<36;i++)
    a0bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a0bf:	83 7d f4 23          	cmpl   $0x23,-0xc(%ebp)
    a0c3:	7e e7                	jle    a0ac <inv_mdct+0x216>
         win[2][i] = 0.0 ;

      for (i=0; i<4*36; i++)
    a0c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a0cc:	eb 21                	jmp    a0ef <inv_mdct+0x259>
         COS[i] = cos(PI/(2*36) * i);
    a0ce:	db 45 f4             	fildl  -0xc(%ebp)
    a0d1:	dd 05 90 d6 00 00    	fldl   0xd690
    a0d7:	de c9                	fmulp  %st,%st(1)
    a0d9:	dd 1c 24             	fstpl  (%esp)
    a0dc:	e8 e1 a6 ff ff       	call   47c2 <cos>
    a0e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a0e4:	dd 1c c5 60 f1 00 00 	fstpl  0xf160(,%eax,8)
      for(i=0;i<12;i++)
         win[2][i] = sin( PI/12*(i+0.5) ) ;
      for(i=12;i<36;i++)
         win[2][i] = 0.0 ;

      for (i=0; i<4*36; i++)
    a0eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a0ef:	81 7d f4 8f 00 00 00 	cmpl   $0x8f,-0xc(%ebp)
    a0f6:	7e d6                	jle    a0ce <inv_mdct+0x238>
         COS[i] = cos(PI/(2*36) * i);

      init++;
    a0f8:	a1 c0 ec 00 00       	mov    0xecc0,%eax
    a0fd:	83 c0 01             	add    $0x1,%eax
    a100:	a3 c0 ec 00 00       	mov    %eax,0xecc0
    }

    for(i=0;i<36;i++)
    a105:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a10c:	eb 17                	jmp    a125 <inv_mdct+0x28f>
       out[i]=0;
    a10e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a111:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    a118:	8b 45 0c             	mov    0xc(%ebp),%eax
    a11b:	01 d0                	add    %edx,%eax
    a11d:	d9 ee                	fldz   
    a11f:	dd 18                	fstpl  (%eax)
         COS[i] = cos(PI/(2*36) * i);

      init++;
    }

    for(i=0;i<36;i++)
    a121:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a125:	83 7d f4 23          	cmpl   $0x23,-0xc(%ebp)
    a129:	7e e3                	jle    a10e <inv_mdct+0x278>
       out[i]=0;

    if(block_type == 2){
    a12b:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
    a12f:	0f 85 85 01 00 00    	jne    a2ba <inv_mdct+0x424>
       N=12;
    a135:	c7 45 dc 0c 00 00 00 	movl   $0xc,-0x24(%ebp)
       for(i=0;i<3;i++){
    a13c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a143:	e9 63 01 00 00       	jmp    a2ab <inv_mdct+0x415>
          for(p= 0;p<N;p++){
    a148:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    a14f:	e9 df 00 00 00       	jmp    a233 <inv_mdct+0x39d>
             sum = 0.0;
    a154:	d9 ee                	fldz   
    a156:	dd 5d e0             	fstpl  -0x20(%ebp)
             for(m=0;m<N/2;m++)
    a159:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    a160:	e9 8f 00 00 00       	jmp    a1f4 <inv_mdct+0x35e>
                sum += in[i+3*m] * cos( PI/(2*N)*(2*p+1+N/2)*(2*m+1) );
    a165:	8b 55 f0             	mov    -0x10(%ebp),%edx
    a168:	89 d0                	mov    %edx,%eax
    a16a:	01 c0                	add    %eax,%eax
    a16c:	01 c2                	add    %eax,%edx
    a16e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a171:	01 d0                	add    %edx,%eax
    a173:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    a17a:	8b 45 08             	mov    0x8(%ebp),%eax
    a17d:	01 d0                	add    %edx,%eax
    a17f:	dd 00                	fldl   (%eax)
    a181:	dd 9d 68 ff ff ff    	fstpl  -0x98(%ebp)
    a187:	8b 45 dc             	mov    -0x24(%ebp),%eax
    a18a:	01 c0                	add    %eax,%eax
    a18c:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    a192:	db 85 74 ff ff ff    	fildl  -0x8c(%ebp)
    a198:	dd 05 98 d6 00 00    	fldl   0xd698
    a19e:	de f1                	fdivp  %st,%st(1)
    a1a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a1a3:	01 c0                	add    %eax,%eax
    a1a5:	8d 50 01             	lea    0x1(%eax),%edx
    a1a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
    a1ab:	89 c1                	mov    %eax,%ecx
    a1ad:	c1 e9 1f             	shr    $0x1f,%ecx
    a1b0:	01 c8                	add    %ecx,%eax
    a1b2:	d1 f8                	sar    %eax
    a1b4:	01 d0                	add    %edx,%eax
    a1b6:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    a1bc:	db 85 74 ff ff ff    	fildl  -0x8c(%ebp)
    a1c2:	de c9                	fmulp  %st,%st(1)
    a1c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a1c7:	01 c0                	add    %eax,%eax
    a1c9:	83 c0 01             	add    $0x1,%eax
    a1cc:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    a1d2:	db 85 74 ff ff ff    	fildl  -0x8c(%ebp)
    a1d8:	de c9                	fmulp  %st,%st(1)
    a1da:	dd 1c 24             	fstpl  (%esp)
    a1dd:	e8 e0 a5 ff ff       	call   47c2 <cos>
    a1e2:	dc 8d 68 ff ff ff    	fmull  -0x98(%ebp)
    a1e8:	dd 45 e0             	fldl   -0x20(%ebp)
    a1eb:	de c1                	faddp  %st,%st(1)
    a1ed:	dd 5d e0             	fstpl  -0x20(%ebp)
    if(block_type == 2){
       N=12;
       for(i=0;i<3;i++){
          for(p= 0;p<N;p++){
             sum = 0.0;
             for(m=0;m<N/2;m++)
    a1f0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    a1f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
    a1f7:	89 c2                	mov    %eax,%edx
    a1f9:	c1 ea 1f             	shr    $0x1f,%edx
    a1fc:	01 d0                	add    %edx,%eax
    a1fe:	d1 f8                	sar    %eax
    a200:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    a203:	0f 8f 5c ff ff ff    	jg     a165 <inv_mdct+0x2cf>
                sum += in[i+3*m] * cos( PI/(2*N)*(2*p+1+N/2)*(2*m+1) );
             tmp[p] = sum * win[block_type][p] ;
    a209:	8b 55 10             	mov    0x10(%ebp),%edx
    a20c:	89 d0                	mov    %edx,%eax
    a20e:	c1 e0 03             	shl    $0x3,%eax
    a211:	01 d0                	add    %edx,%eax
    a213:	c1 e0 02             	shl    $0x2,%eax
    a216:	8b 55 ec             	mov    -0x14(%ebp),%edx
    a219:	01 d0                	add    %edx,%eax
    a21b:	dd 04 c5 e0 ec 00 00 	fldl   0xece0(,%eax,8)
    a222:	dc 4d e0             	fmull  -0x20(%ebp)
    a225:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a228:	dd 9c c5 78 ff ff ff 	fstpl  -0x88(%ebp,%eax,8)
       out[i]=0;

    if(block_type == 2){
       N=12;
       for(i=0;i<3;i++){
          for(p= 0;p<N;p++){
    a22f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    a233:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a236:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    a239:	0f 8c 15 ff ff ff    	jl     a154 <inv_mdct+0x2be>
             sum = 0.0;
             for(m=0;m<N/2;m++)
                sum += in[i+3*m] * cos( PI/(2*N)*(2*p+1+N/2)*(2*m+1) );
             tmp[p] = sum * win[block_type][p] ;
          }
          for(p=0;p<N;p++)
    a23f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    a246:	eb 57                	jmp    a29f <inv_mdct+0x409>
             out[6*i+p+6] += tmp[p];
    a248:	8b 55 f4             	mov    -0xc(%ebp),%edx
    a24b:	89 d0                	mov    %edx,%eax
    a24d:	01 c0                	add    %eax,%eax
    a24f:	01 d0                	add    %edx,%eax
    a251:	01 c0                	add    %eax,%eax
    a253:	89 c2                	mov    %eax,%edx
    a255:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a258:	01 d0                	add    %edx,%eax
    a25a:	83 c0 06             	add    $0x6,%eax
    a25d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    a264:	8b 45 0c             	mov    0xc(%ebp),%eax
    a267:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    a26a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    a26d:	89 d0                	mov    %edx,%eax
    a26f:	01 c0                	add    %eax,%eax
    a271:	01 d0                	add    %edx,%eax
    a273:	01 c0                	add    %eax,%eax
    a275:	89 c2                	mov    %eax,%edx
    a277:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a27a:	01 d0                	add    %edx,%eax
    a27c:	83 c0 06             	add    $0x6,%eax
    a27f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    a286:	8b 45 0c             	mov    0xc(%ebp),%eax
    a289:	01 d0                	add    %edx,%eax
    a28b:	dd 00                	fldl   (%eax)
    a28d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a290:	dd 84 c5 78 ff ff ff 	fldl   -0x88(%ebp,%eax,8)
    a297:	de c1                	faddp  %st,%st(1)
    a299:	dd 19                	fstpl  (%ecx)
             sum = 0.0;
             for(m=0;m<N/2;m++)
                sum += in[i+3*m] * cos( PI/(2*N)*(2*p+1+N/2)*(2*m+1) );
             tmp[p] = sum * win[block_type][p] ;
          }
          for(p=0;p<N;p++)
    a29b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    a29f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a2a2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    a2a5:	7c a1                	jl     a248 <inv_mdct+0x3b2>
    for(i=0;i<36;i++)
       out[i]=0;

    if(block_type == 2){
       N=12;
       for(i=0;i<3;i++){
    a2a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a2ab:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
    a2af:	0f 8e 93 fe ff ff    	jle    a148 <inv_mdct+0x2b2>
    a2b5:	e9 da 00 00 00       	jmp    a394 <inv_mdct+0x4fe>
          for(p=0;p<N;p++)
             out[6*i+p+6] += tmp[p];
       }
    }
    else{
      N=36;
    a2ba:	c7 45 dc 24 00 00 00 	movl   $0x24,-0x24(%ebp)
      for(p= 0;p<N;p++){
    a2c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    a2c8:	e9 bb 00 00 00       	jmp    a388 <inv_mdct+0x4f2>
         sum = 0.0;
    a2cd:	d9 ee                	fldz   
    a2cf:	dd 5d e0             	fstpl  -0x20(%ebp)
         for(m=0;m<N/2;m++)
    a2d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    a2d9:	eb 6a                	jmp    a345 <inv_mdct+0x4af>
           sum += in[m] * COS[((2*p+1+N/2)*(2*m+1))%(4*36)];
    a2db:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a2de:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    a2e5:	8b 45 08             	mov    0x8(%ebp),%eax
    a2e8:	01 d0                	add    %edx,%eax
    a2ea:	dd 00                	fldl   (%eax)
    a2ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a2ef:	01 c0                	add    %eax,%eax
    a2f1:	8d 50 01             	lea    0x1(%eax),%edx
    a2f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
    a2f7:	89 c1                	mov    %eax,%ecx
    a2f9:	c1 e9 1f             	shr    $0x1f,%ecx
    a2fc:	01 c8                	add    %ecx,%eax
    a2fe:	d1 f8                	sar    %eax
    a300:	01 c2                	add    %eax,%edx
    a302:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a305:	01 c0                	add    %eax,%eax
    a307:	83 c0 01             	add    $0x1,%eax
    a30a:	89 d1                	mov    %edx,%ecx
    a30c:	0f af c8             	imul   %eax,%ecx
    a30f:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
    a314:	89 c8                	mov    %ecx,%eax
    a316:	f7 ea                	imul   %edx
    a318:	c1 fa 05             	sar    $0x5,%edx
    a31b:	89 c8                	mov    %ecx,%eax
    a31d:	c1 f8 1f             	sar    $0x1f,%eax
    a320:	29 c2                	sub    %eax,%edx
    a322:	89 d0                	mov    %edx,%eax
    a324:	c1 e0 03             	shl    $0x3,%eax
    a327:	01 d0                	add    %edx,%eax
    a329:	c1 e0 04             	shl    $0x4,%eax
    a32c:	29 c1                	sub    %eax,%ecx
    a32e:	89 ca                	mov    %ecx,%edx
    a330:	dd 04 d5 60 f1 00 00 	fldl   0xf160(,%edx,8)
    a337:	de c9                	fmulp  %st,%st(1)
    a339:	dd 45 e0             	fldl   -0x20(%ebp)
    a33c:	de c1                	faddp  %st,%st(1)
    a33e:	dd 5d e0             	fstpl  -0x20(%ebp)
    }
    else{
      N=36;
      for(p= 0;p<N;p++){
         sum = 0.0;
         for(m=0;m<N/2;m++)
    a341:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    a345:	8b 45 dc             	mov    -0x24(%ebp),%eax
    a348:	89 c2                	mov    %eax,%edx
    a34a:	c1 ea 1f             	shr    $0x1f,%edx
    a34d:	01 d0                	add    %edx,%eax
    a34f:	d1 f8                	sar    %eax
    a351:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    a354:	7f 85                	jg     a2db <inv_mdct+0x445>
           sum += in[m] * COS[((2*p+1+N/2)*(2*m+1))%(4*36)];
         out[p] = sum * win[block_type][p];
    a356:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a359:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    a360:	8b 45 0c             	mov    0xc(%ebp),%eax
    a363:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    a366:	8b 55 10             	mov    0x10(%ebp),%edx
    a369:	89 d0                	mov    %edx,%eax
    a36b:	c1 e0 03             	shl    $0x3,%eax
    a36e:	01 d0                	add    %edx,%eax
    a370:	c1 e0 02             	shl    $0x2,%eax
    a373:	8b 55 ec             	mov    -0x14(%ebp),%edx
    a376:	01 d0                	add    %edx,%eax
    a378:	dd 04 c5 e0 ec 00 00 	fldl   0xece0(,%eax,8)
    a37f:	dc 4d e0             	fmull  -0x20(%ebp)
    a382:	dd 19                	fstpl  (%ecx)
             out[6*i+p+6] += tmp[p];
       }
    }
    else{
      N=36;
      for(p= 0;p<N;p++){
    a384:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    a388:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a38b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    a38e:	0f 8c 39 ff ff ff    	jl     a2cd <inv_mdct+0x437>
         for(m=0;m<N/2;m++)
           sum += in[m] * COS[((2*p+1+N/2)*(2*m+1))%(4*36)];
         out[p] = sum * win[block_type][p];
      }
    }
}
    a394:	c9                   	leave  
    a395:	c3                   	ret    

0000a396 <III_hybrid>:


void III_hybrid(double fsIn[SSLIMIT], double tsOut[SSLIMIT], int sb, int ch, struct gr_info_s *gr_info, struct frame_params *fr_ps)
/* fsIn:freq samples per subband in */
/* tsOut:time samples per subband out */
{
    a396:	55                   	push   %ebp
    a397:	89 e5                	mov    %esp,%ebp
    a399:	53                   	push   %ebx
    a39a:	81 ec 54 01 00 00    	sub    $0x154,%esp
   double rawout[36];
   static double prevblck[2][SBLIMIT][SSLIMIT];
   static int init = 1;
   int bt;

   if (init) {
    a3a0:	a1 e4 eb 00 00       	mov    0xebe4,%eax
    a3a5:	85 c0                	test   %eax,%eax
    a3a7:	74 6f                	je     a418 <III_hybrid+0x82>
      int i,j,k;

      for(i=0;i<2;i++)
    a3a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    a3b0:	eb 56                	jmp    a408 <III_hybrid+0x72>
         for(j=0;j<SBLIMIT;j++)
    a3b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    a3b9:	eb 43                	jmp    a3fe <III_hybrid+0x68>
            for(k=0;k<SSLIMIT;k++)
    a3bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    a3c2:	eb 30                	jmp    a3f4 <III_hybrid+0x5e>
               prevblck[i][j][k]=0.0;
    a3c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a3c7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    a3ca:	89 c2                	mov    %eax,%edx
    a3cc:	c1 e2 03             	shl    $0x3,%edx
    a3cf:	01 c2                	add    %eax,%edx
    a3d1:	8d 04 12             	lea    (%edx,%edx,1),%eax
    a3d4:	89 c2                	mov    %eax,%edx
    a3d6:	89 c8                	mov    %ecx,%eax
    a3d8:	c1 e0 03             	shl    $0x3,%eax
    a3db:	01 c8                	add    %ecx,%eax
    a3dd:	c1 e0 06             	shl    $0x6,%eax
    a3e0:	01 c2                	add    %eax,%edx
    a3e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    a3e5:	01 d0                	add    %edx,%eax
    a3e7:	d9 ee                	fldz   
    a3e9:	dd 1c c5 e0 f5 00 00 	fstpl  0xf5e0(,%eax,8)
   if (init) {
      int i,j,k;

      for(i=0;i<2;i++)
         for(j=0;j<SBLIMIT;j++)
            for(k=0;k<SSLIMIT;k++)
    a3f0:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    a3f4:	83 7d e8 11          	cmpl   $0x11,-0x18(%ebp)
    a3f8:	7e ca                	jle    a3c4 <III_hybrid+0x2e>

   if (init) {
      int i,j,k;

      for(i=0;i<2;i++)
         for(j=0;j<SBLIMIT;j++)
    a3fa:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    a3fe:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
    a402:	7e b7                	jle    a3bb <III_hybrid+0x25>
   int bt;

   if (init) {
      int i,j,k;

      for(i=0;i<2;i++)
    a404:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    a408:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    a40c:	7e a4                	jle    a3b2 <III_hybrid+0x1c>
         for(j=0;j<SBLIMIT;j++)
            for(k=0;k<SSLIMIT;k++)
               prevblck[i][j][k]=0.0;
      init = 0;
    a40e:	c7 05 e4 eb 00 00 00 	movl   $0x0,0xebe4
    a415:	00 00 00 
   }

   bt = (gr_info->window_switching_flag && gr_info->mixed_block_flag &&
    a418:	8b 45 18             	mov    0x18(%ebp),%eax
    a41b:	8b 40 10             	mov    0x10(%eax),%eax
    a41e:	85 c0                	test   %eax,%eax
    a420:	74 10                	je     a432 <III_hybrid+0x9c>
    a422:	8b 45 18             	mov    0x18(%ebp),%eax
    a425:	8b 40 18             	mov    0x18(%eax),%eax
    a428:	85 c0                	test   %eax,%eax
    a42a:	74 06                	je     a432 <III_hybrid+0x9c>
    a42c:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
    a430:	7e 08                	jle    a43a <III_hybrid+0xa4>
          (sb < 2)) ? 0 : gr_info->block_type;
    a432:	8b 45 18             	mov    0x18(%ebp),%eax
    a435:	8b 40 14             	mov    0x14(%eax),%eax
            for(k=0;k<SSLIMIT;k++)
               prevblck[i][j][k]=0.0;
      init = 0;
   }

   bt = (gr_info->window_switching_flag && gr_info->mixed_block_flag &&
    a438:	eb 05                	jmp    a43f <III_hybrid+0xa9>
    a43a:	b8 00 00 00 00       	mov    $0x0,%eax
    a43f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          (sb < 2)) ? 0 : gr_info->block_type;

   inv_mdct( fsIn, rawout, bt);
    a442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    a445:	89 44 24 08          	mov    %eax,0x8(%esp)
    a449:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
    a44f:	89 44 24 04          	mov    %eax,0x4(%esp)
    a453:	8b 45 08             	mov    0x8(%ebp),%eax
    a456:	89 04 24             	mov    %eax,(%esp)
    a459:	e8 38 fa ff ff       	call   9e96 <inv_mdct>

   /* overlap addition */
   for(ss=0; ss<SSLIMIT; ss++) {
    a45e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a465:	e9 83 00 00 00       	jmp    a4ed <III_hybrid+0x157>
      tsOut[ss] = rawout[ss] + prevblck[ch][sb][ss];
    a46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a46d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    a474:	8b 45 0c             	mov    0xc(%ebp),%eax
    a477:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    a47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a47d:	dd 84 c5 c0 fe ff ff 	fldl   -0x140(%ebp,%eax,8)
    a484:	8b 45 10             	mov    0x10(%ebp),%eax
    a487:	8b 4d 14             	mov    0x14(%ebp),%ecx
    a48a:	89 c2                	mov    %eax,%edx
    a48c:	c1 e2 03             	shl    $0x3,%edx
    a48f:	01 c2                	add    %eax,%edx
    a491:	8d 04 12             	lea    (%edx,%edx,1),%eax
    a494:	89 c2                	mov    %eax,%edx
    a496:	89 c8                	mov    %ecx,%eax
    a498:	c1 e0 03             	shl    $0x3,%eax
    a49b:	01 c8                	add    %ecx,%eax
    a49d:	c1 e0 06             	shl    $0x6,%eax
    a4a0:	01 c2                	add    %eax,%edx
    a4a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a4a5:	01 d0                	add    %edx,%eax
    a4a7:	dd 04 c5 e0 f5 00 00 	fldl   0xf5e0(,%eax,8)
    a4ae:	de c1                	faddp  %st,%st(1)
    a4b0:	dd 1b                	fstpl  (%ebx)
      prevblck[ch][sb][ss] = rawout[ss+18];
    a4b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a4b5:	83 c0 12             	add    $0x12,%eax
    a4b8:	dd 84 c5 c0 fe ff ff 	fldl   -0x140(%ebp,%eax,8)
    a4bf:	8b 45 10             	mov    0x10(%ebp),%eax
    a4c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
    a4c5:	89 c2                	mov    %eax,%edx
    a4c7:	c1 e2 03             	shl    $0x3,%edx
    a4ca:	01 c2                	add    %eax,%edx
    a4cc:	8d 04 12             	lea    (%edx,%edx,1),%eax
    a4cf:	89 c2                	mov    %eax,%edx
    a4d1:	89 c8                	mov    %ecx,%eax
    a4d3:	c1 e0 03             	shl    $0x3,%eax
    a4d6:	01 c8                	add    %ecx,%eax
    a4d8:	c1 e0 06             	shl    $0x6,%eax
    a4db:	01 c2                	add    %eax,%edx
    a4dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a4e0:	01 d0                	add    %edx,%eax
    a4e2:	dd 1c c5 e0 f5 00 00 	fstpl  0xf5e0(,%eax,8)
          (sb < 2)) ? 0 : gr_info->block_type;

   inv_mdct( fsIn, rawout, bt);

   /* overlap addition */
   for(ss=0; ss<SSLIMIT; ss++) {
    a4e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a4ed:	83 7d f4 11          	cmpl   $0x11,-0xc(%ebp)
    a4f1:	0f 8e 73 ff ff ff    	jle    a46a <III_hybrid+0xd4>
      tsOut[ss] = rawout[ss] + prevblck[ch][sb][ss];
      prevblck[ch][sb][ss] = rawout[ss+18];
   }
}
    a4f7:	81 c4 54 01 00 00    	add    $0x154,%esp
    a4fd:	5b                   	pop    %ebx
    a4fe:	5d                   	pop    %ebp
    a4ff:	c3                   	ret    

0000a500 <create_syn_filter>:


/* create in synthesis filter */
void create_syn_filter(double filter[64][SBLIMIT])
{
    a500:	55                   	push   %ebp
    a501:	89 e5                	mov    %esp,%ebp
    a503:	57                   	push   %edi
    a504:	56                   	push   %esi
    a505:	53                   	push   %ebx
    a506:	83 ec 1c             	sub    $0x1c,%esp
	register int i,k;

	for (i=0; i<64; i++)
    a509:	be 00 00 00 00       	mov    $0x0,%esi
    a50e:	e9 1c 01 00 00       	jmp    a62f <create_syn_filter+0x12f>
		for (k=0; k<32; k++) {
    a513:	bb 00 00 00 00       	mov    $0x0,%ebx
    a518:	e9 06 01 00 00       	jmp    a623 <create_syn_filter+0x123>
			if ((filter[i][k] = 1e9*cos((double)((PI64*i+PI4)*(2*k+1)))) >= 0)
    a51d:	89 f0                	mov    %esi,%eax
    a51f:	c1 e0 08             	shl    $0x8,%eax
    a522:	89 c2                	mov    %eax,%edx
    a524:	8b 45 08             	mov    0x8(%ebp),%eax
    a527:	8d 3c 02             	lea    (%edx,%eax,1),%edi
    a52a:	89 75 e0             	mov    %esi,-0x20(%ebp)
    a52d:	db 45 e0             	fildl  -0x20(%ebp)
    a530:	dd 05 a0 d6 00 00    	fldl   0xd6a0
    a536:	de c9                	fmulp  %st,%st(1)
    a538:	dd 05 a8 d6 00 00    	fldl   0xd6a8
    a53e:	de c1                	faddp  %st,%st(1)
    a540:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
    a543:	83 c0 01             	add    $0x1,%eax
    a546:	89 45 e0             	mov    %eax,-0x20(%ebp)
    a549:	db 45 e0             	fildl  -0x20(%ebp)
    a54c:	de c9                	fmulp  %st,%st(1)
    a54e:	dd 1c 24             	fstpl  (%esp)
    a551:	e8 6c a2 ff ff       	call   47c2 <cos>
    a556:	dd 05 b0 d6 00 00    	fldl   0xd6b0
    a55c:	de c9                	fmulp  %st,%st(1)
    a55e:	dd 1c df             	fstpl  (%edi,%ebx,8)
    a561:	dd 04 df             	fldl   (%edi,%ebx,8)
    a564:	d9 ee                	fldz   
    a566:	d9 c9                	fxch   %st(1)
    a568:	df e9                	fucomip %st(1),%st
    a56a:	dd d8                	fstp   %st(0)
    a56c:	72 47                	jb     a5b5 <create_syn_filter+0xb5>
				filter[i][k] = (int)(filter[i][k]+0.5);
    a56e:	89 f0                	mov    %esi,%eax
    a570:	c1 e0 08             	shl    $0x8,%eax
    a573:	89 c2                	mov    %eax,%edx
    a575:	8b 45 08             	mov    0x8(%ebp),%eax
    a578:	01 c2                	add    %eax,%edx
    a57a:	89 f0                	mov    %esi,%eax
    a57c:	c1 e0 08             	shl    $0x8,%eax
    a57f:	89 c1                	mov    %eax,%ecx
    a581:	8b 45 08             	mov    0x8(%ebp),%eax
    a584:	01 c8                	add    %ecx,%eax
    a586:	dd 04 d8             	fldl   (%eax,%ebx,8)
    a589:	dd 05 70 d6 00 00    	fldl   0xd670
    a58f:	de c1                	faddp  %st,%st(1)
    a591:	d9 7d e6             	fnstcw -0x1a(%ebp)
    a594:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
    a598:	b4 0c                	mov    $0xc,%ah
    a59a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
    a59e:	d9 6d e4             	fldcw  -0x1c(%ebp)
    a5a1:	db 5d e0             	fistpl -0x20(%ebp)
    a5a4:	d9 6d e6             	fldcw  -0x1a(%ebp)
    a5a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
    a5aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    a5ad:	db 45 e0             	fildl  -0x20(%ebp)
    a5b0:	dd 1c da             	fstpl  (%edx,%ebx,8)
    a5b3:	eb 45                	jmp    a5fa <create_syn_filter+0xfa>
				//modf(filter[i][k]+0.5, &filter[i][k]);
			else
				filter[i][k] = (int)(filter[i][k]-0.5);
    a5b5:	89 f0                	mov    %esi,%eax
    a5b7:	c1 e0 08             	shl    $0x8,%eax
    a5ba:	89 c2                	mov    %eax,%edx
    a5bc:	8b 45 08             	mov    0x8(%ebp),%eax
    a5bf:	01 c2                	add    %eax,%edx
    a5c1:	89 f0                	mov    %esi,%eax
    a5c3:	c1 e0 08             	shl    $0x8,%eax
    a5c6:	89 c1                	mov    %eax,%ecx
    a5c8:	8b 45 08             	mov    0x8(%ebp),%eax
    a5cb:	01 c8                	add    %ecx,%eax
    a5cd:	dd 04 d8             	fldl   (%eax,%ebx,8)
    a5d0:	dd 05 70 d6 00 00    	fldl   0xd670
    a5d6:	de e9                	fsubrp %st,%st(1)
    a5d8:	d9 7d e6             	fnstcw -0x1a(%ebp)
    a5db:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
    a5df:	b4 0c                	mov    $0xc,%ah
    a5e1:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
    a5e5:	d9 6d e4             	fldcw  -0x1c(%ebp)
    a5e8:	db 5d e0             	fistpl -0x20(%ebp)
    a5eb:	d9 6d e6             	fldcw  -0x1a(%ebp)
    a5ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
    a5f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    a5f4:	db 45 e0             	fildl  -0x20(%ebp)
    a5f7:	dd 1c da             	fstpl  (%edx,%ebx,8)
				//modf(filter[i][k]-0.5, &filter[i][k]);
			filter[i][k] *= 1e-9;
    a5fa:	89 f0                	mov    %esi,%eax
    a5fc:	c1 e0 08             	shl    $0x8,%eax
    a5ff:	89 c2                	mov    %eax,%edx
    a601:	8b 45 08             	mov    0x8(%ebp),%eax
    a604:	01 d0                	add    %edx,%eax
    a606:	89 f2                	mov    %esi,%edx
    a608:	89 d1                	mov    %edx,%ecx
    a60a:	c1 e1 08             	shl    $0x8,%ecx
    a60d:	8b 55 08             	mov    0x8(%ebp),%edx
    a610:	01 ca                	add    %ecx,%edx
    a612:	dd 04 da             	fldl   (%edx,%ebx,8)
    a615:	dd 05 b8 d6 00 00    	fldl   0xd6b8
    a61b:	de c9                	fmulp  %st,%st(1)
    a61d:	dd 1c d8             	fstpl  (%eax,%ebx,8)
void create_syn_filter(double filter[64][SBLIMIT])
{
	register int i,k;

	for (i=0; i<64; i++)
		for (k=0; k<32; k++) {
    a620:	83 c3 01             	add    $0x1,%ebx
    a623:	83 fb 1f             	cmp    $0x1f,%ebx
    a626:	0f 8e f1 fe ff ff    	jle    a51d <create_syn_filter+0x1d>
/* create in synthesis filter */
void create_syn_filter(double filter[64][SBLIMIT])
{
	register int i,k;

	for (i=0; i<64; i++)
    a62c:	83 c6 01             	add    $0x1,%esi
    a62f:	83 fe 3f             	cmp    $0x3f,%esi
    a632:	0f 8e db fe ff ff    	jle    a513 <create_syn_filter+0x13>
			else
				filter[i][k] = (int)(filter[i][k]-0.5);
				//modf(filter[i][k]-0.5, &filter[i][k]);
			filter[i][k] *= 1e-9;
		}
}
    a638:	83 c4 1c             	add    $0x1c,%esp
    a63b:	5b                   	pop    %ebx
    a63c:	5e                   	pop    %esi
    a63d:	5f                   	pop    %edi
    a63e:	5d                   	pop    %ebp
    a63f:	c3                   	ret    

0000a640 <read_syn_window>:



/* read in synthesis window */
void read_syn_window(double window[HAN_SIZE])
{
    a640:	55                   	push   %ebp
    a641:	89 e5                	mov    %esp,%ebp
    a643:	57                   	push   %edi
    a644:	56                   	push   %esi
    a645:	53                   	push   %ebx
    a646:	81 ec 14 10 00 00    	sub    $0x1014,%esp
	double gb_window[HAN_SIZE] = {0.0000000000, -0.0000152590, -0.0000152590, -0.0000152590,
    a64c:	8d 95 e8 ef ff ff    	lea    -0x1018(%ebp),%edx
    a652:	bb 20 c6 00 00       	mov    $0xc620,%ebx
    a657:	b8 00 04 00 00       	mov    $0x400,%eax
    a65c:	89 d7                	mov    %edx,%edi
    a65e:	89 de                	mov    %ebx,%esi
    a660:	89 c1                	mov    %eax,%ecx
    a662:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		0.0000762940, 0.0000762940, 0.0000610350, 0.0000610350,
		0.0000457760, 0.0000457760, 0.0000305180, 0.0000305180,
		0.0000305180, 0.0000305180, 0.0000152590, 0.0000152590,
		0.0000152590, 0.0000152590, 0.0000152590, 0.0000152590,
	};
	window = gb_window;
    a664:	8d 85 e8 ef ff ff    	lea    -0x1018(%ebp),%eax
    a66a:	89 45 ec             	mov    %eax,-0x14(%ebp)
}
    a66d:	81 c4 14 10 00 00    	add    $0x1014,%esp
    a673:	5b                   	pop    %ebx
    a674:	5e                   	pop    %esi
    a675:	5f                   	pop    %edi
    a676:	5d                   	pop    %ebp
    a677:	c3                   	ret    

0000a678 <SubBandSynthesis>:

int SubBandSynthesis (double *bandPtr, int channel, short *samples)
{
    a678:	55                   	push   %ebp
    a679:	89 e5                	mov    %esp,%ebp
    a67b:	57                   	push   %edi
    a67c:	56                   	push   %esi
    a67d:	53                   	push   %ebx
    a67e:	83 ec 2c             	sub    $0x2c,%esp
	static NN *filter;
	typedef double BB[2][2*HAN_SIZE];
	static BB *buf;
	static int bufOffset[2] = {64,64};
	static double *window;
	int clip = 0;               /* count & return how many samples clipped */
    a681:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	if (init) {
    a688:	a1 e8 eb 00 00       	mov    0xebe8,%eax
    a68d:	85 c0                	test   %eax,%eax
    a68f:	74 6f                	je     a700 <SubBandSynthesis+0x88>
		buf = (BB *) mem_alloc(sizeof(BB),"BB");
    a691:	c7 44 24 04 20 d6 00 	movl   $0xd620,0x4(%esp)
    a698:	00 
    a699:	c7 04 24 00 40 00 00 	movl   $0x4000,(%esp)
    a6a0:	e8 15 a8 ff ff       	call   4eba <mem_alloc>
    a6a5:	a3 e0 19 01 00       	mov    %eax,0x119e0
		filter = (NN *) mem_alloc(sizeof(NN), "NN");
    a6aa:	c7 44 24 04 23 d6 00 	movl   $0xd623,0x4(%esp)
    a6b1:	00 
    a6b2:	c7 04 24 00 40 00 00 	movl   $0x4000,(%esp)
    a6b9:	e8 fc a7 ff ff       	call   4eba <mem_alloc>
    a6be:	a3 e4 19 01 00       	mov    %eax,0x119e4
		create_syn_filter(*filter);
    a6c3:	a1 e4 19 01 00       	mov    0x119e4,%eax
    a6c8:	89 04 24             	mov    %eax,(%esp)
    a6cb:	e8 30 fe ff ff       	call   a500 <create_syn_filter>
		window = (double *) mem_alloc(sizeof(double) * HAN_SIZE, "WIN");
    a6d0:	c7 44 24 04 26 d6 00 	movl   $0xd626,0x4(%esp)
    a6d7:	00 
    a6d8:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    a6df:	e8 d6 a7 ff ff       	call   4eba <mem_alloc>
    a6e4:	a3 e8 19 01 00       	mov    %eax,0x119e8
		read_syn_window(window);
    a6e9:	a1 e8 19 01 00       	mov    0x119e8,%eax
    a6ee:	89 04 24             	mov    %eax,(%esp)
    a6f1:	e8 4a ff ff ff       	call   a640 <read_syn_window>
		init = 0;
    a6f6:	c7 05 e8 eb 00 00 00 	movl   $0x0,0xebe8
    a6fd:	00 00 00 
	}
/*    if (channel == 0) */
	bufOffset[channel] = (bufOffset[channel] - 64) & 0x3ff;
    a700:	8b 45 0c             	mov    0xc(%ebp),%eax
    a703:	8b 04 85 ec eb 00 00 	mov    0xebec(,%eax,4),%eax
    a70a:	83 e8 40             	sub    $0x40,%eax
    a70d:	25 ff 03 00 00       	and    $0x3ff,%eax
    a712:	89 c2                	mov    %eax,%edx
    a714:	8b 45 0c             	mov    0xc(%ebp),%eax
    a717:	89 14 85 ec eb 00 00 	mov    %edx,0xebec(,%eax,4)
	bufOffsetPtr = &((*buf)[channel][bufOffset[channel]]);
    a71e:	8b 15 e0 19 01 00    	mov    0x119e0,%edx
    a724:	8b 45 0c             	mov    0xc(%ebp),%eax
    a727:	8b 04 85 ec eb 00 00 	mov    0xebec(,%eax,4),%eax
    a72e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    a731:	c1 e1 0a             	shl    $0xa,%ecx
    a734:	01 c8                	add    %ecx,%eax
    a736:	c1 e0 03             	shl    $0x3,%eax
    a739:	8d 3c 02             	lea    (%edx,%eax,1),%edi

	for (i=0; i<64; i++) {
    a73c:	bb 00 00 00 00       	mov    $0x0,%ebx
    a741:	eb 40                	jmp    a783 <SubBandSynthesis+0x10b>
		sum = 0;
    a743:	d9 ee                	fldz   
		for (k=0; k<32; k++)
    a745:	be 00 00 00 00       	mov    $0x0,%esi
    a74a:	eb 26                	jmp    a772 <SubBandSynthesis+0xfa>
			sum += bandPtr[k] * (*filter)[i][k];
    a74c:	89 f0                	mov    %esi,%eax
    a74e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    a755:	8b 45 08             	mov    0x8(%ebp),%eax
    a758:	01 d0                	add    %edx,%eax
    a75a:	dd 00                	fldl   (%eax)
    a75c:	a1 e4 19 01 00       	mov    0x119e4,%eax
    a761:	89 da                	mov    %ebx,%edx
    a763:	c1 e2 05             	shl    $0x5,%edx
    a766:	01 f2                	add    %esi,%edx
    a768:	dd 04 d0             	fldl   (%eax,%edx,8)
    a76b:	de c9                	fmulp  %st,%st(1)
    a76d:	de c1                	faddp  %st,%st(1)
	bufOffset[channel] = (bufOffset[channel] - 64) & 0x3ff;
	bufOffsetPtr = &((*buf)[channel][bufOffset[channel]]);

	for (i=0; i<64; i++) {
		sum = 0;
		for (k=0; k<32; k++)
    a76f:	83 c6 01             	add    $0x1,%esi
    a772:	83 fe 1f             	cmp    $0x1f,%esi
    a775:	7e d5                	jle    a74c <SubBandSynthesis+0xd4>
			sum += bandPtr[k] * (*filter)[i][k];
		bufOffsetPtr[i] = sum;
    a777:	89 d8                	mov    %ebx,%eax
    a779:	c1 e0 03             	shl    $0x3,%eax
    a77c:	01 f8                	add    %edi,%eax
    a77e:	dd 18                	fstpl  (%eax)
	}
/*    if (channel == 0) */
	bufOffset[channel] = (bufOffset[channel] - 64) & 0x3ff;
	bufOffsetPtr = &((*buf)[channel][bufOffset[channel]]);

	for (i=0; i<64; i++) {
    a780:	83 c3 01             	add    $0x1,%ebx
    a783:	83 fb 3f             	cmp    $0x3f,%ebx
    a786:	7e bb                	jle    a743 <SubBandSynthesis+0xcb>
			sum += bandPtr[k] * (*filter)[i][k];
		bufOffsetPtr[i] = sum;
	}
	/*  S(i,j) = D(j+32i) * U(j+32i+((i+1)>>1)*64)  */
	/*  samples(i,j) = MWindow(j+32i) * bufPtr(j+32i+((i+1)>>1)*64)  */
	for (j=0; j<32; j++) {
    a788:	bf 00 00 00 00       	mov    $0x0,%edi
    a78d:	e9 c7 00 00 00       	jmp    a859 <SubBandSynthesis+0x1e1>
		sum = 0;
    a792:	d9 ee                	fldz   
		for (i=0; i<16; i++) {
    a794:	bb 00 00 00 00       	mov    $0x0,%ebx
    a799:	eb 4c                	jmp    a7e7 <SubBandSynthesis+0x16f>
			k = j + (i<<5);
    a79b:	89 d8                	mov    %ebx,%eax
    a79d:	c1 e0 05             	shl    $0x5,%eax
    a7a0:	8d 34 38             	lea    (%eax,%edi,1),%esi
			sum += window[k] * (*buf) [channel] [( (k + ( ((i+1)>>1) <<6) ) +
    a7a3:	a1 e8 19 01 00       	mov    0x119e8,%eax
    a7a8:	89 f2                	mov    %esi,%edx
    a7aa:	c1 e2 03             	shl    $0x3,%edx
    a7ad:	01 d0                	add    %edx,%eax
    a7af:	dd 00                	fldl   (%eax)
    a7b1:	a1 e0 19 01 00       	mov    0x119e0,%eax
    a7b6:	8d 53 01             	lea    0x1(%ebx),%edx
    a7b9:	d1 fa                	sar    %edx
    a7bb:	c1 e2 06             	shl    $0x6,%edx
    a7be:	8d 0c 32             	lea    (%edx,%esi,1),%ecx
												bufOffset[channel]) & 0x3ff];
    a7c1:	8b 55 0c             	mov    0xc(%ebp),%edx
    a7c4:	8b 14 95 ec eb 00 00 	mov    0xebec(,%edx,4),%edx
	/*  samples(i,j) = MWindow(j+32i) * bufPtr(j+32i+((i+1)>>1)*64)  */
	for (j=0; j<32; j++) {
		sum = 0;
		for (i=0; i<16; i++) {
			k = j + (i<<5);
			sum += window[k] * (*buf) [channel] [( (k + ( ((i+1)>>1) <<6) ) +
    a7cb:	01 ca                	add    %ecx,%edx
												bufOffset[channel]) & 0x3ff];
    a7cd:	89 d1                	mov    %edx,%ecx
    a7cf:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
	/*  samples(i,j) = MWindow(j+32i) * bufPtr(j+32i+((i+1)>>1)*64)  */
	for (j=0; j<32; j++) {
		sum = 0;
		for (i=0; i<16; i++) {
			k = j + (i<<5);
			sum += window[k] * (*buf) [channel] [( (k + ( ((i+1)>>1) <<6) ) +
    a7d5:	8b 55 0c             	mov    0xc(%ebp),%edx
    a7d8:	c1 e2 0a             	shl    $0xa,%edx
    a7db:	01 ca                	add    %ecx,%edx
    a7dd:	dd 04 d0             	fldl   (%eax,%edx,8)
    a7e0:	de c9                	fmulp  %st,%st(1)
    a7e2:	de c1                	faddp  %st,%st(1)
	}
	/*  S(i,j) = D(j+32i) * U(j+32i+((i+1)>>1)*64)  */
	/*  samples(i,j) = MWindow(j+32i) * bufPtr(j+32i+((i+1)>>1)*64)  */
	for (j=0; j<32; j++) {
		sum = 0;
		for (i=0; i<16; i++) {
    a7e4:	83 c3 01             	add    $0x1,%ebx
    a7e7:	83 fb 0f             	cmp    $0xf,%ebx
    a7ea:	7e af                	jle    a79b <SubBandSynthesis+0x123>
			sum += window[k] * (*buf) [channel] [( (k + ( ((i+1)>>1) <<6) ) +
												bufOffset[channel]) & 0x3ff];
		}
		{
			/*long foo = (sum > 0) ? sum * SCALE + 0.5 : sum * SCALE - 0.5; */
			long foo = sum * SCALE;
    a7ec:	dd 05 c0 d6 00 00    	fldl   0xd6c0
    a7f2:	de c9                	fmulp  %st,%st(1)
    a7f4:	d9 7d d6             	fnstcw -0x2a(%ebp)
    a7f7:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
    a7fb:	b4 0c                	mov    $0xc,%ah
    a7fd:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
    a801:	d9 6d d4             	fldcw  -0x2c(%ebp)
    a804:	db 5d e0             	fistpl -0x20(%ebp)
    a807:	d9 6d d6             	fldcw  -0x2a(%ebp)
			if (foo >= (long) SCALE)      {samples[j] = SCALE-1; ++clip;}
    a80a:	81 7d e0 ff 7f 00 00 	cmpl   $0x7fff,-0x20(%ebp)
    a811:	7e 15                	jle    a828 <SubBandSynthesis+0x1b0>
    a813:	89 f8                	mov    %edi,%eax
    a815:	8d 14 00             	lea    (%eax,%eax,1),%edx
    a818:	8b 45 10             	mov    0x10(%ebp),%eax
    a81b:	01 d0                	add    %edx,%eax
    a81d:	66 c7 00 ff 7f       	movw   $0x7fff,(%eax)
    a822:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    a826:	eb 2e                	jmp    a856 <SubBandSynthesis+0x1de>
			else if (foo < (long) -SCALE) {samples[j] = -SCALE;  ++clip;}
    a828:	81 7d e0 00 80 ff ff 	cmpl   $0xffff8000,-0x20(%ebp)
    a82f:	7d 15                	jge    a846 <SubBandSynthesis+0x1ce>
    a831:	89 f8                	mov    %edi,%eax
    a833:	8d 14 00             	lea    (%eax,%eax,1),%edx
    a836:	8b 45 10             	mov    0x10(%ebp),%eax
    a839:	01 d0                	add    %edx,%eax
    a83b:	66 c7 00 00 80       	movw   $0x8000,(%eax)
    a840:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    a844:	eb 10                	jmp    a856 <SubBandSynthesis+0x1de>
			else                           samples[j] = foo;
    a846:	89 f8                	mov    %edi,%eax
    a848:	8d 14 00             	lea    (%eax,%eax,1),%edx
    a84b:	8b 45 10             	mov    0x10(%ebp),%eax
    a84e:	01 c2                	add    %eax,%edx
    a850:	8b 45 e0             	mov    -0x20(%ebp),%eax
    a853:	66 89 02             	mov    %ax,(%edx)
			sum += bandPtr[k] * (*filter)[i][k];
		bufOffsetPtr[i] = sum;
	}
	/*  S(i,j) = D(j+32i) * U(j+32i+((i+1)>>1)*64)  */
	/*  samples(i,j) = MWindow(j+32i) * bufPtr(j+32i+((i+1)>>1)*64)  */
	for (j=0; j<32; j++) {
    a856:	83 c7 01             	add    $0x1,%edi
    a859:	83 ff 1f             	cmp    $0x1f,%edi
    a85c:	0f 8e 30 ff ff ff    	jle    a792 <SubBandSynthesis+0x11a>
			if (foo >= (long) SCALE)      {samples[j] = SCALE-1; ++clip;}
			else if (foo < (long) -SCALE) {samples[j] = -SCALE;  ++clip;}
			else                           samples[j] = foo;
		}
	}
    return(clip);
    a862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
    a865:	83 c4 2c             	add    $0x2c,%esp
    a868:	5b                   	pop    %ebx
    a869:	5e                   	pop    %esi
    a86a:	5f                   	pop    %edi
    a86b:	5d                   	pop    %ebp
    a86c:	c3                   	ret    

0000a86d <out_fifo>:

void out_fifo(short pcm_sample[2][SSLIMIT][SBLIMIT], int num, struct frame_params *fr_ps, unsigned long *psampFrames)
{
    a86d:	55                   	push   %ebp
    a86e:	89 e5                	mov    %esp,%ebp
    a870:	83 ec 10             	sub    $0x10,%esp
	int i,j,l;
	int stereo = fr_ps->stereo;
    a873:	8b 45 10             	mov    0x10(%ebp),%eax
    a876:	8b 40 08             	mov    0x8(%eax),%eax
    a879:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//int sblimit = fr_ps->sblimit;
	static long k = 0;

        for (i=0;i<num;i++) for (j=0;j<SBLIMIT;j++) {
    a87c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    a883:	eb 75                	jmp    a8fa <out_fifo+0x8d>
    a885:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    a88c:	eb 62                	jmp    a8f0 <out_fifo+0x83>
            (*psampFrames)++;
    a88e:	8b 45 14             	mov    0x14(%ebp),%eax
    a891:	8b 00                	mov    (%eax),%eax
    a893:	8d 50 01             	lea    0x1(%eax),%edx
    a896:	8b 45 14             	mov    0x14(%ebp),%eax
    a899:	89 10                	mov    %edx,(%eax)
            for (l=0;l<stereo;l++) {
    a89b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a8a2:	eb 40                	jmp    a8e4 <out_fifo+0x77>
                if (!(k%1600) && k) {
    a8a4:	8b 0d ec 19 01 00    	mov    0x119ec,%ecx
    a8aa:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    a8af:	89 c8                	mov    %ecx,%eax
    a8b1:	f7 ea                	imul   %edx
    a8b3:	c1 fa 09             	sar    $0x9,%edx
    a8b6:	89 c8                	mov    %ecx,%eax
    a8b8:	c1 f8 1f             	sar    $0x1f,%eax
    a8bb:	29 c2                	sub    %eax,%edx
    a8bd:	89 d0                	mov    %edx,%eax
    a8bf:	69 c0 40 06 00 00    	imul   $0x640,%eax,%eax
    a8c5:	29 c1                	sub    %eax,%ecx
    a8c7:	89 c8                	mov    %ecx,%eax
    a8c9:	85 c0                	test   %eax,%eax
    a8cb:	75 13                	jne    a8e0 <out_fifo+0x73>
    a8cd:	a1 ec 19 01 00       	mov    0x119ec,%eax
    a8d2:	85 c0                	test   %eax,%eax
    a8d4:	74 0a                	je     a8e0 <out_fifo+0x73>
                    //fwrite(outsamp,2,1600,outFile);
                    k = 0;
    a8d6:	c7 05 ec 19 01 00 00 	movl   $0x0,0x119ec
    a8dd:	00 00 00 
	//int sblimit = fr_ps->sblimit;
	static long k = 0;

        for (i=0;i<num;i++) for (j=0;j<SBLIMIT;j++) {
            (*psampFrames)++;
            for (l=0;l<stereo;l++) {
    a8e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a8e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    a8ea:	7c b8                	jl     a8a4 <out_fifo+0x37>
	int i,j,l;
	int stereo = fr_ps->stereo;
	//int sblimit = fr_ps->sblimit;
	static long k = 0;

        for (i=0;i<num;i++) for (j=0;j<SBLIMIT;j++) {
    a8ec:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    a8f0:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
    a8f4:	7e 98                	jle    a88e <out_fifo+0x21>
    a8f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    a8fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a8fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
    a900:	7c 83                	jl     a885 <out_fifo+0x18>
                    k = 0;
                }
                //outsamp[k++] = pcm_sample[l][i][j];
            }
        }
}
    a902:	c9                   	leave  
    a903:	c3                   	ret    

0000a904 <buffer_CRC>:


void  buffer_CRC(Bit_stream_struc *bs, unsigned int *old_crc)
{
    a904:	55                   	push   %ebp
    a905:	89 e5                	mov    %esp,%ebp
    a907:	83 ec 18             	sub    $0x18,%esp
    *old_crc = getbits(bs, 16);
    a90a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
    a911:	00 
    a912:	8b 45 08             	mov    0x8(%ebp),%eax
    a915:	89 04 24             	mov    %eax,(%esp)
    a918:	e8 8b a8 ff ff       	call   51a8 <getbits>
    a91d:	8b 55 0c             	mov    0xc(%ebp),%edx
    a920:	89 02                	mov    %eax,(%edx)
}
    a922:	c9                   	leave  
    a923:	c3                   	ret    

0000a924 <main_data_slots>:

extern int bitrate[3][15];
extern double s_freq[4];
/* Return the number of slots for main data of current frame, */
int main_data_slots(struct frame_params fr_ps)
{
    a924:	55                   	push   %ebp
    a925:	89 e5                	mov    %esp,%ebp
    a927:	83 ec 18             	sub    $0x18,%esp
	int nSlots;

	nSlots = (144 * bitrate[2][fr_ps.header->bitrate_index])
    a92a:	8b 45 08             	mov    0x8(%ebp),%eax
    a92d:	8b 40 0c             	mov    0xc(%eax),%eax
    a930:	83 c0 1e             	add    $0x1e,%eax
    a933:	8b 14 85 40 e7 00 00 	mov    0xe740(,%eax,4),%edx
    a93a:	89 d0                	mov    %edx,%eax
    a93c:	c1 e0 03             	shl    $0x3,%eax
    a93f:	01 d0                	add    %edx,%eax
    a941:	c1 e0 04             	shl    $0x4,%eax
			/ s_freq[fr_ps.header->sampling_frequency];
    a944:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a947:	db 45 ec             	fildl  -0x14(%ebp)
    a94a:	8b 45 08             	mov    0x8(%ebp),%eax
    a94d:	8b 40 10             	mov    0x10(%eax),%eax
    a950:	dd 04 c5 00 e8 00 00 	fldl   0xe800(,%eax,8)
    a957:	de f9                	fdivrp %st,%st(1)
/* Return the number of slots for main data of current frame, */
int main_data_slots(struct frame_params fr_ps)
{
	int nSlots;

	nSlots = (144 * bitrate[2][fr_ps.header->bitrate_index])
    a959:	d9 7d ea             	fnstcw -0x16(%ebp)
    a95c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
    a960:	b4 0c                	mov    $0xc,%ah
    a962:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
    a966:	d9 6d e8             	fldcw  -0x18(%ebp)
    a969:	db 5d fc             	fistpl -0x4(%ebp)
    a96c:	d9 6d ea             	fldcw  -0x16(%ebp)
			/ s_freq[fr_ps.header->sampling_frequency];
	if (fr_ps.header->padding) nSlots++;
    a96f:	8b 45 08             	mov    0x8(%ebp),%eax
    a972:	8b 40 14             	mov    0x14(%eax),%eax
    a975:	85 c0                	test   %eax,%eax
    a977:	74 04                	je     a97d <main_data_slots+0x59>
    a979:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	nSlots -= 4;
    a97d:	83 6d fc 04          	subl   $0x4,-0x4(%ebp)
	if (fr_ps.header->error_protection)
    a981:	8b 45 08             	mov    0x8(%ebp),%eax
    a984:	8b 40 08             	mov    0x8(%eax),%eax
    a987:	85 c0                	test   %eax,%eax
    a989:	74 04                	je     a98f <main_data_slots+0x6b>
		nSlots -= 2;
    a98b:	83 6d fc 02          	subl   $0x2,-0x4(%ebp)
	if (fr_ps.stereo == 1)
    a98f:	8b 45 10             	mov    0x10(%ebp),%eax
    a992:	83 f8 01             	cmp    $0x1,%eax
    a995:	75 06                	jne    a99d <main_data_slots+0x79>
		nSlots -= 17;
    a997:	83 6d fc 11          	subl   $0x11,-0x4(%ebp)
    a99b:	eb 04                	jmp    a9a1 <main_data_slots+0x7d>
	else
		nSlots -=32;
    a99d:	83 6d fc 20          	subl   $0x20,-0x4(%ebp)
	return(nSlots);
    a9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    a9a4:	c9                   	leave  
    a9a5:	c3                   	ret    
