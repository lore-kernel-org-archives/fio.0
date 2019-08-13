Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Subject: Re: [PATCH 3/5] Refine packed annotations in stat.h
References: <20190813020136.15798-1-bvanassche@acm.org>
 <20190813020136.15798-4-bvanassche@acm.org>
 <cfaf773a-8fe0-ceaa-3b7d-bbfe7116e2bf@kernel.dk>
 <a5ab1f27-72b6-7d27-5eae-be61294df3f9@acm.org>
 <2ae2b675-2da9-c4a2-4b29-cb21afc19b1f@kernel.dk>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <d0e9560f-2584-f439-fd27-e1ccfc768da8@acm.org>
Date: Tue, 13 Aug 2019 13:51:28 -0700
MIME-Version: 1.0
In-Reply-To: <2ae2b675-2da9-c4a2-4b29-cb21afc19b1f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/13/19 1:25 PM, Jens Axboe wrote:
> On 8/13/19 9:12 AM, Bart Van Assche wrote:
>> On 8/12/19 7:53 PM, Jens Axboe wrote:
>>> On 8/12/19 8:01 PM, Bart Van Assche wrote:
>>>> Instead of declaring the whole structure packed, only declare non-al=
igned
>>>> members packed. This patch is an alternative way to fix the followin=
g gcc 9
>>>> compiler warnings:
>>>>
>>>> eta.c: In function 'calc_thread_status':
>>>> eta.c:510:7: error: taking address of packed member of 'struct jobs_=
eta' may result in an unaligned pointer value [-Werror=3Daddress-of-packe=
d-member]
>>>>      510 |     je->rate);
>>>>          |     ~~^~~~~~
>>>> eta.c:522:66: error: taking address of packed member of 'struct jobs=
_eta' may result in an unaligned pointer value [-Werror=3Daddress-of-pack=
ed-member]
>>>>      522 |  calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_b=
ytes, je->rate);
>>>>          |                                                          =
      ~~^~~~~~
>>>> eta.c:523:64: error: taking address of packed member of 'struct jobs=
_eta' may result in an unaligned pointer value [-Werror=3Daddress-of-pack=
ed-member]
>>>>      523 |  calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_io=
ps, je->iops);
>>>>          |
>>>
>>> This seems fragile. Not that we change the struct all the time, or ev=
en often,
>>> but it'd be easy to add members and end up with different layout on 3=
2-bit
>>> vs 64-bit.
>>>
>>> How do we improve on that?
>>
>> Hi Jens,
>>
>> Do you agree that the "BUILD_BUG_ON(sizeof(struct jobs_eta) !=3D 160)"=

>> statement added by the previous patch should catch such differences? 1=
60
>> bytes namely is the size of an entirely packed jobs_eta structure.
>=20
> I guess that's good enough, though it'd be nice to check for holes
> explicitly. I wonder if there's an easy way to do that, though...

Hi Jens,

The pahole tool should be able to check for holes. Unfortunately that
tool doesn't seem to work very well on Ubuntu:

$ pahole -H 1 *.o
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x12d> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x175> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x58> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x15e> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x44> not handled!
die__process_function: tag not supported (INVALID)!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xb5> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xf2> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x48> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x4cc> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x1ab> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x4b6> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x736> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x4ba> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x187> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x4e4> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x42> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xd1> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xfd> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xaf> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x103> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x73> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xb5> not handled!
struct _IO_FILE {
	int                        _flags;               /*     0     4 */

	/* XXX 4 bytes hole, try to pack */

	char *                     _IO_read_ptr;         /*     8     8 */
	char *                     _IO_read_end;         /*    16     8 */
	char *                     _IO_read_base;        /*    24     8 */
	char *                     _IO_write_base;       /*    32     8 */
	char *                     _IO_write_ptr;        /*    40     8 */
	char *                     _IO_write_end;        /*    48     8 */
	char *                     _IO_buf_base;         /*    56     8 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	char *                     _IO_buf_end;          /*    64     8 */
	char *                     _IO_save_base;        /*    72     8 */
	char *                     _IO_backup_base;      /*    80     8 */
	char *                     _IO_save_end;         /*    88     8 */
	struct _IO_marker *        _markers;             /*    96     8 */
	struct _IO_FILE *          _chain;               /*   104     8 */
	int                        _fileno;              /*   112     4 */
	int                        _flags2;              /*   116     4 */
	__off_t                    _old_offset;          /*   120     8 */
	/* --- cacheline 2 boundary (128 bytes) --- */
	short unsigned int         _cur_column;          /*   128     2 */
	signed char                _vtable_offset;       /*   130     1 */
	char                       _shortbuf[1];         /*   131     1 */

	/* XXX 4 bytes hole, try to pack */

	_IO_lock_t *               _lock;                /*   136     8 */
	__off64_t                  _offset;              /*   144     8 */
	struct _IO_codecvt *       _codecvt;             /*   152     8 */
	struct _IO_wide_data *     _wide_data;           /*   160     8 */
	struct _IO_FILE *          _freeres_list;        /*   168     8 */
	void *                     _freeres_buf;         /*   176     8 */
	size_t                     __pad5;               /*   184     8 */
	/* --- cacheline 3 boundary (192 bytes) --- */
	int                        _mode;                /*   192     4 */
	char                       _unused2[20];         /*   196    20 */

	/* size: 216, cachelines: 4, members: 29 */
	/* sum members: 208, holes: 2, sum holes: 8 */
	/* last cacheline: 24 bytes */
};
struct fio_filelock {
	uint32_t                   hash;                 /*     0     4 */

	/* XXX 4 bytes hole, try to pack */

	struct fio_sem             lock;                 /*     8   104 */

	/* XXX last struct has 4 bytes of padding */

	/* --- cacheline 1 boundary (64 bytes) was 48 bytes ago --- */
	struct flist_head          list;                 /*   112    16 */
	/* --- cacheline 2 boundary (128 bytes) --- */
	unsigned int               references;           /*   128     4 */

	/* size: 136, cachelines: 3, members: 4 */
	/* sum members: 128, holes: 1, sum holes: 4 */
	/* padding: 4 */
	/* paddings: 1, sum paddings: 4 */
	/* last cacheline: 8 bytes */
};
struct io_u_ring {
	unsigned int               head;                 /*     0     4 */
	unsigned int               tail;                 /*     4     4 */
	unsigned int               max;                  /*     8     4 */

	/* XXX 4 bytes hole, try to pack */

	struct io_u * *            ring;                 /*    16     8 */

	/* size: 24, cachelines: 1, members: 4 */
	/* sum members: 20, holes: 1, sum holes: 4 */
	/* last cacheline: 24 bytes */
};
struct json_object {
	struct json_pair * *       pairs;                /*     0     8 */
	int                        pair_cnt;             /*     8     4 */

	/* XXX 4 bytes hole, try to pack */

	struct json_value *        parent;               /*    16     8 */

	/* size: 24, cachelines: 1, members: 3 */
	/* sum members: 20, holes: 1, sum holes: 4 */
	/* last cacheline: 24 bytes */
};
struct json_array {
	struct json_value * *      values;               /*     0     8 */
	int                        value_cnt;            /*     8     4 */

	/* XXX 4 bytes hole, try to pack */

	struct json_value *        parent;      die__process_unit:
DW_TAG_restrict_type (0x37) @ <0x283> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xfc> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x14d> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x127> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xae> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x4f> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x4ba> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xda> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x552> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xa5> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xfb> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x59> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x72> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x4ca> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xe5> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x4ba> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xe5> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0xf6> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x5d> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x41> not handled!
die__process_unit: DW_TAG_restrict_type (0x37) @ <0x4c5> not handled!
         /*    16     8 */

	/* size: 24, cachelines: 1, members: 3 */
	/* sum members: 20, holes: 1, sum holes: 4 */
	/* last cacheline: 24 bytes */
};
struct json_value {
	int                        type;                 /*     0     4 */

	/* XXX 4 bytes hole, try to pack */

	union {
		long long int      integer_number;       /*           8 */
		double             float_number;         /*           8 */
		char *             string;               /*           8 */
		struct json_object * object;             /*           8 */
		struct json_array * array;               /*           8 */
	};                                               /*     8     8 */
	int                        parent_type;          /*    16     4 */

	/* XXX 4 bytes hole, try to pack */

	union {
		struct json_pair * parent_pair;          /*           8 */
		struct json_array * parent_array;        /*           8 */
	};                                               /*    24     8 */

	/* size: 32, cachelines: 1, members: 4 */
	/* sum members: 24, holes: 2, sum holes: 8 */
	/* last cacheline: 32 bytes */
};

Bart.


