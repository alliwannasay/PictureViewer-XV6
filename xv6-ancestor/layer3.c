#include <stdio.h>
#include <stdlib.h>
#include "common.h"
#include "decode.h"

void main(int argc, char**argv)
{
	FILE *musicout;
	Bit_stream_struc  bs;
	frame_params fr_ps;
	III_side_info_t III_side_info;
	III_scalefac_t III_scalefac;
	unsigned int old_crc;
	layer info;
	int sync, clip;
	int done = FALSE;
	unsigned long frameNum=0;
	unsigned long bitsPerSlot;
	unsigned long sample_frames;

	typedef short PCM[2][SSLIMIT][SBLIMIT];
	PCM *pcm_sample;

	pcm_sample = (PCM *) mem_alloc((long) sizeof(PCM), "PCM Samp");
	/*if (argc==1) {
		printf("Useage:decode file.mp3 output.pcm\n");
		return;
	}*/

	fr_ps.header = &info;

	if ((musicout = fopen("out.pcm", "w+b")) == NULL) {
		printf ("Could not create \"%s\".\n", "out.pcm");
		exit(1);
	}

    open_bit_stream_r(&bs, "in.mp3", BUFFER_SIZE);

	sample_frames = 0;
	while(!end_bs(&bs)) {
		//����֡ͬ��
		sync = seek_sync(&bs, SYNC_WORD, SYNC_WORD_LENGTH);
		if (!sync) {
			done = TRUE;
			printf("\nFrame cannot be located\n");
			out_fifo(*pcm_sample, 3, &fr_ps, done, musicout, &sample_frames);
			break;
		}
		//����֡ͷ
		decode_info(&bs, &fr_ps);
		//��fr_ps.header�е���Ϣ�����fr_ps���������
		hdr_to_frps(&fr_ps);
		//��������Ϣ
		if(frameNum == 0)
		   WriteHdr(&fr_ps);
		printf("\r%05lu", frameNum++);
		if (info.error_protection)
			buffer_CRC(&bs, &old_crc);
		switch (info.lay) {
		case 3:
		{
			int nSlots, main_data_end, flush_main;
			int bytes_to_discard, gr, ch, ss, sb;
			static int frame_start = 0;

			bitsPerSlot = 8;
			
			//ȡSide��Ϣ
			III_get_side_info(&bs, &III_side_info, &fr_ps);
			nSlots = main_data_slots(fr_ps);

			 //��������(Audio Data)
			for (; nSlots > 0; nSlots--)  /* read main data. */
				hputbuf((unsigned int) getbits(&bs,8), 8);
			main_data_end = hsstell() / 8; /*of privious frame*/
			if ( flush_main=(hsstell() % bitsPerSlot) ) {
				hgetbits((int)(bitsPerSlot - flush_main));
				main_data_end ++;
			}
			bytes_to_discard = frame_start - main_data_end - III_side_info.main_data_begin ;
			if( main_data_end > 4096 ) {   frame_start -= 4096;
				rewindNbytes( 4096 );
			}

			frame_start += main_data_slots(fr_ps);
			if (bytes_to_discard < 0) {
				printf("Not enough main data to decode frame %d.  Frame discarded.\n",
						frameNum - 1); break;
			}
			for (; bytes_to_discard > 0; bytes_to_discard--) hgetbits(8);

			clip = 0;
			for (gr=0;gr<2;gr++) {
				double lr[2][SBLIMIT][SSLIMIT],ro[2][SBLIMIT][SSLIMIT];
				//������
				for (ch=0; ch<fr_ps.stereo; ch++) {
					long int is[SBLIMIT][SSLIMIT];   /*������������*/
					int part2_start;
					part2_start = hsstell();
					//��ȡ��������
					III_get_scale_factors(&III_scalefac,&III_side_info, gr, ch, &fr_ps);
					//Huffman����
					III_hufman_decode(is, &III_side_info, ch, gr, part2_start, &fr_ps);
					//����������
					III_dequantize_sample(is, ro[ch], &III_scalefac, &(III_side_info.ch[ch].gr[gr]), ch, &fr_ps);
				}
				//����������
				III_stereo(ro, lr, &III_scalefac, &(III_side_info.ch[0].gr[gr]), &fr_ps);
				for (ch=0; ch<fr_ps.stereo; ch++) {
					double re[SBLIMIT][SSLIMIT];
					double hybridIn[SBLIMIT][SSLIMIT];/* Hybrid filter input */
					double hybridOut[SBLIMIT][SSLIMIT];/* Hybrid filter out */
					double polyPhaseIn[SBLIMIT];     /* PolyPhase Input. */

					III_reorder(lr[ch], re, &(III_side_info.ch[ch].gr[gr]), &fr_ps);
					//����ݴ���
					III_antialias(re, hybridIn, /* Antialias butterflies. */
								&(III_side_info.ch[ch].gr[gr]), &fr_ps);
					//IMDCT
					for (sb=0; sb<SBLIMIT; sb++) { /* Hybrid synthesis. */
						III_hybrid(hybridIn[sb], hybridOut[sb], sb, ch,	&(III_side_info.ch[ch].gr[gr]), &fr_ps);
					}
					for (ss=0;ss<18;ss++)	//����Ƶ�ʵ���
						for (sb=0; sb<SBLIMIT; sb++)
							if ((ss%2) && (sb%2))
								hybridOut[sb][ss] = -hybridOut[sb][ss];
					for (ss=0;ss<18;ss++) { //����ϳ�
						for (sb=0; sb<SBLIMIT; sb++)
							polyPhaseIn[sb] = hybridOut[sb][ss];
						//�Ӵ��ϳ�
						clip += SubBandSynthesis(polyPhaseIn, ch, &((*pcm_sample)[ch][ss][0]));
					}
				}
				//PCM���
				/* Output PCM sample points for one granule(����). */
				out_fifo(*pcm_sample, 18, &fr_ps, done, musicout, &sample_frames);
			}
			if(clip > 0)
				printf("\n%d samples clipped.\n", clip);
		}
			break;
		default:
			printf("\nOnly layer III supported!\n");
			exit(1);
			break;
		}
	}
	close_bit_stream_r(&bs);
	fclose(musicout);
	printf("\nDecoding done.\n");
	return;
}