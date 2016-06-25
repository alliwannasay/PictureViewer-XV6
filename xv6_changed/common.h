#ifndef	_COMMON_H_
#define	_COMMON_H_


/* MPEG ͷ����- Mode Values */
#define	MPG_MD_STEREO           0
#define	MPG_MD_JOINT_STEREO     1
#define	MPG_MD_DUAL_CHANNEL     2
#define	MPG_MD_MONO             3

#define	SYNC_WORD			(long)0xfff
#define	SYNC_WORD_LENGTH	12

#define	ALIGNING			8

#define	MINIMUM				4    /* ��������Сֵ�� bytes ��*/
#define	MAX_LENGTH			32	/* �ӱ����������ʵ���󳤶� */

#define	BINARY				0	/*�����������ļ�*/
#define	READ_MODE			0	/*����ģʽ*/

#define	FALSE				0
#define	TRUE				1

#define	MIN(A, B)			((A) < (B) ? (A) : (B))

#define	SBLIMIT				32
#define	SSLIMIT				18
#define	BUFFER_SIZE			4096
#define	HAN_SIZE			512
#define	SCALE				32768

#define	PI					3.14159265358979
#define	PI64				PI/64
#define	PI4					PI/4

/* ͷ��Ϣ Structure */
typedef struct {
    int version;
    int lay;
    int error_protection;
    int bitrate_index;
    int sampling_frequency;
    int padding;
    int extension;
    int mode;
    int mode_ext;
    int copyright;
    int original;
    int emphasis;
} layer, *the_layer;


/* Header�н����������ĸ��ṹ */
struct frame_params{
    layer       *header;        /* ͷ��Ϣ */
    int         actual_mode;    /* when writing IS, may forget if 0 chs */
    int         stereo;         /* 1 Ϊ mono, 2 Ϊ stereo */
    int         jsbound;        /* ����������ĵ�һ������ */
    int         sblimit;        /* �����Ӵ������� */
} ;

typedef struct  bit_stream_struc {
    int        pt;            /* �������豸ָ�� */
    unsigned char *buf;         /* ���������� */
    int         buf_size;       /* �����������С( bytes) */
    long        totbit;         /* �������ı��ؼ��� */
    int         buf_byte_idx;   /* ָ�򻺳������ֽ� */
    int         buf_bit_idx;    /* ָ�򻺳������ֽ��ױ��� */
    int         mode;           /* ��������ģʽ����/д��*/
    int         eob;            /* ������������ */
    int         eobs;           /* ������������־ */
    char        format;

    /*  rd ģʽ�ļ���ʽ (BINARY/ASCII) */
} Bit_stream_struc;

/* Layer III ������Ϣ */
struct III_side_info_t {
	unsigned main_data_begin;
	unsigned private_bits;
	struct {
		unsigned scfsi[4];
		struct gr_info_s {
			unsigned part2_3_length;
			unsigned big_values;
			unsigned global_gain;
			unsigned scalefac_compress;
			unsigned window_switching_flag;
			unsigned block_type;
			unsigned mixed_block_flag;
			unsigned table_select[3];
			unsigned subblock_gain[3];
			unsigned region0_count;
			unsigned region1_count;
			unsigned preflag;
			unsigned scalefac_scale;
			unsigned count1table_select;
		} gr[2];
	} ch[2];
};

typedef struct {
	int l[23];			/* [cb] */
	int s[3][13];		/* [window][cb] */
} III_scalefac_t[2];	/* [ch] */

int OpenTableFile(char *name);

void WriteHdr(struct frame_params *fr_ps);

void *mem_alloc(unsigned long block, char *item);
void alloc_buffer(Bit_stream_struc *bs, int size);
void desalloc_buffer(Bit_stream_struc *bs);

void open_bit_stream_r(Bit_stream_struc *bs, char *bs_filenam, int size);
void close_bit_stream_r(Bit_stream_struc *bs);
int	end_bs(Bit_stream_struc *bs);
unsigned long sstell(Bit_stream_struc *bs);
void refill_buffer(Bit_stream_struc *bs);

unsigned int get1bit(Bit_stream_struc *bs);
unsigned long getbits(Bit_stream_struc *bs, int N);
int seek_sync(Bit_stream_struc *bs, unsigned long sync, int N);

int js_bound(int lay, int m_ext);
void hdr_to_frps(struct frame_params *fr_ps);

void hputbuf(unsigned int val, int N);
unsigned long hsstell();
unsigned long hgetbits(int N);
unsigned int hget1bit();
void rewindNbits(int N);
void rewindNbytes(int N);

#endif	/*_COMMON_H_*/
