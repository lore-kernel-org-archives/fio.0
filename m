Return-Path: <prvs=3677b97be=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: Fix I/O direction adjustment step for random
 read/write
Date: Wed, 15 Apr 2020 03:14:19 +0000
Message-ID: 
 <CH2PR04MB69026B226BF1B42AB3CA968EE7DB0@CH2PR04MB6902.namprd04.prod.outlook.com>
References: <20200414100017.266406-1-shinichiro.kawasaki@wdc.com>
 <BY5PR04MB6900394C987DCB70F353B332E7DB0@BY5PR04MB6900.namprd04.prod.outlook.com>
 <BY5PR04MB6900A95BCDD74273505C5D17E7DB0@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200415030527.fuvrfjpjsdixz34q@shindev.dhcp.fujisawa.hgst.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

On 2020/04/15 12:05, Shinichiro Kawasaki wrote:=0A=
> On Apr 15, 2020 / 01:09, Damien Le Moal wrote:=0A=
>> On 2020/04/15 10:03, Damien Le Moal wrote:=0A=
>>> On 2020/04/14 19:00, Shin'ichiro Kawasaki wrote:=0A=
>>>> Commit fb0259fb ("zbd: Ensure first I/O is write for random read/write=
 to=0A=
>>>> sequential zones") introduced a step to change direction of io_u from=
=0A=
>>>> read to write when that is the first I/O of the random read/write=0A=
>>>> workload to zoned block devices. However, such direction adjustment=0A=
>>>> results in inconsistent I/O length when read block size and write bloc=
k=0A=
>>>> size are different.=0A=
>>>>=0A=
>>>> To avoid the inconsistency between I/O direction and I/O length,=0A=
>>>> adjust the I/O direction before the I/O length is set. Move the step=
=0A=
>>>> from zbd_adjust_block() to set_rw_ddir(). To minimize changes in=0A=
>>>> set_rw_ddir(), introduce zbd_adjust_ddir() helper function.=0A=
>>>>=0A=
>>>> Fixes: fb0259fb ("zbd: Ensure first I/O is write for random read/write=
 to sequential zones")=0A=
>>>> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
>>>> ---=0A=
>>>>  io_u.c |  2 ++=0A=
>>>>  zbd.c  | 34 ++++++++++++++++++++++++----------=0A=
>>>>  zbd.h  |  2 ++=0A=
>>>>  3 files changed, 28 insertions(+), 10 deletions(-)=0A=
>>>>=0A=
>>>> diff --git a/io_u.c b/io_u.c=0A=
>>>> index 5d62a76c..234dd268 100644=0A=
>>>> --- a/io_u.c=0A=
>>>> +++ b/io_u.c=0A=
>>>> @@ -746,6 +746,8 @@ static void set_rw_ddir(struct thread_data *td, st=
ruct io_u *io_u)=0A=
>>>>  {=0A=
>>>>  	enum fio_ddir ddir =3D get_rw_ddir(td);=0A=
>>>>  =0A=
>>>> +	zbd_adjust_ddir(td, io_u, &ddir);=0A=
>>>> +=0A=
>>>>  	if (td_trimwrite(td)) {=0A=
>>>>  		struct fio_file *f =3D io_u->file;=0A=
>>>>  		if (f->last_pos[DDIR_WRITE] =3D=3D f->last_pos[DDIR_TRIM])=0A=
>>>> diff --git a/zbd.c b/zbd.c=0A=
>>>> index de0c5bf4..82810511 100644=0A=
>>>> --- a/zbd.c=0A=
>>>> +++ b/zbd.c=0A=
>>>> @@ -1331,6 +1331,30 @@ void setup_zbd_zone_mode(struct thread_data *td=
, struct io_u *io_u)=0A=
>>>>  	}=0A=
>>>>  }=0A=
>>>>  =0A=
>>>> +/**=0A=
>>>> + * zbd_adjust_ddir - Adjust the I/O direction to zoned block devices.=
=0A=
>>>=0A=
>>> zbd_adjust_ddir - Adjust an I/O direction for zonemode=3Dzbd.=0A=
> =0A=
> Thanks. Will rephrase as commented.=0A=
> =0A=
>>>=0A=
>>>> + *=0A=
>>>> + * @td: FIO thread data.=0A=
>>>> + * @io_u: FIO I/O unit.=0A=
>>>> + * @ddir: Data direction to adjust.=0A=
>>>> + */=0A=
>>>> +void zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,=0A=
>>>> +		     enum fio_ddir *ddir)=0A=
>>>=0A=
>>> Why use a pointer for ddir ? Simply have this function return an enum f=
io_ddir=0A=
>>> similarly to what get_rw_ddir() does.=0A=
>>>=0A=
>>> enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u=
,=0A=
>>> 			      enum fio_ddir ddir)=0A=
> =0A=
> Ok, it looks better to have simlairity with get_rw_ddir(). Will change as=
=0A=
> suggested.=0A=
> =0A=
>>>=0A=
>>>> +{=0A=
>>>> +	/*=0A=
>>>> +	 * In case read direction is chosen for the first random I/O, fio wi=
th=0A=
>>>> +	 * zonemode=3Dzbd stops because no data can be read from zoned block=
=0A=
>>>> +	 * devices with all empty zones. Overwrite the first I/O direction a=
s=0A=
>>>> +	 * write to make sure data to read exists.=0A=
>>>> +	 */=0A=
>>>> +	if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD &&=0A=
>>>> +	    td_rw(td) &&=0A=
>>>> +	    *ddir =3D=3D DDIR_READ &&=0A=
>>>> +	    !io_u->file->zbd_info->sectors_with_data &&=0A=
>>>> +	    !td->o.read_beyond_wp)=0A=
>>>> +		*ddir =3D DDIR_WRITE;=0A=
>>>=0A=
>>> Aouch. Really long condition... This is bad for performance for cases t=
hat do=0A=
>>> not care about zonemode=3Dzbd. I think it is much better to split this =
and return=0A=
>>> early for the cases that do not need change. So something like:=0A=
>>>=0A=
>>> enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u=
,=0A=
>>> 			      enum fio_ddir ddir)=0A=
>>> {=0A=
>>> 	if (td->o.zone_mode !=3D ZONE_MODE_ZBD ||=0A=
>>> 	    ddir !=3D DDIR_READ)=0A=
>>> 		return ddir;=0A=
>>>=0A=
>>> 	if (io_u->file->zbd_info->sectors_with_data ||=0A=
>>> 	    td->o.read_beyond_wp)=0A=
>>> 		return DDIR_READ;=0A=
>>>=0A=
>>> 	return DDIR_WRITE;=0A=
>>> }=0A=
>>>=0A=
>>> That is a lot more readable in my opinion.=0A=
>>=0A=
>> Forgot to carry over your explanation comment. Better include it as that=
=0A=
>> clarifies the code and why the change in direction is needed.=0A=
> =0A=
> Thanks. Will modify the function as suggested keeping the comment. I thin=
k check=0A=
> with td_rw() is required also to ensure that the workload mixes the read =
and=0A=
> write. I'll include it in the first if group.=0A=
=0A=
Ah, yes indeed, it is needed.=0A=
=0A=
> =0A=
>>=0A=
>>>=0A=
>>>> +}=0A=
>>>> +=0A=
>>>>  /**=0A=
>>>>   * zbd_adjust_block - adjust the offset and length as necessary for Z=
BD drives=0A=
>>>>   * @td: FIO thread data.=0A=
>>>> @@ -1364,16 +1388,6 @@ enum io_u_action zbd_adjust_block(struct thread=
_data *td, struct io_u *io_u)=0A=
>>>>  	if (!zbd_zone_swr(zb))=0A=
>>>>  		return io_u_accept;=0A=
>>>>  =0A=
>>>> -	/*=0A=
>>>> -	 * In case read direction is chosen for the first random I/O, fio wi=
th=0A=
>>>> -	 * zonemode=3Dzbd stops because no data can be read from zoned block=
=0A=
>>>> -	 * devices with all empty zones. Overwrite the first I/O direction a=
s=0A=
>>>> -	 * write to make sure data to read exists.=0A=
>>>> -	 */=0A=
>>>> -	if (td_rw(td) && !f->zbd_info->sectors_with_data=0A=
>>>> -	    && !td->o.read_beyond_wp)=0A=
>>>> -		io_u->ddir =3D DDIR_WRITE;=0A=
>>>> -=0A=
>>>>  	/*=0A=
>>>>  	 * Accept the I/O offset for reads if reading beyond the write point=
er=0A=
>>>>  	 * is enabled.=0A=
>>>> diff --git a/zbd.h b/zbd.h=0A=
>>>> index 4eaf902e..196853ab 100644=0A=
>>>> --- a/zbd.h=0A=
>>>> +++ b/zbd.h=0A=
>>>> @@ -82,6 +82,8 @@ int zbd_init(struct thread_data *td);=0A=
>>>>  void zbd_file_reset(struct thread_data *td, struct fio_file *f);=0A=
>>>>  bool zbd_unaligned_write(int error_code);=0A=
>>>>  void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u);=
=0A=
>>>> +void zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,=0A=
>>>> +		     enum fio_ddir *ddir);=0A=
>>>>  enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u=
 *io_u);=0A=
>>>>  char *zbd_write_status(const struct thread_stat *ts);=0A=
>>>>  =0A=
>>>>=0A=
>>>=0A=
>>>=0A=
>>=0A=
>>=0A=
>> -- =0A=
>> Damien Le Moal=0A=
>> Western Digital Research=0A=
>>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

