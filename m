Return-Path: <prvs=365e504d7=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/3] zbd: Ensure first I/O is write for random read/write
 to sequential zones
Date: Mon, 13 Apr 2020 09:09:50 +0000
Message-ID: 
 <BY5PR04MB6900229BAD532C3D83C92367E7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
 <20200413083300.256784-4-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 2020/04/13 17:33, Shin'ichiro Kawasaki wrote:=0A=
> In case read is chosen for the first random I/O for sequential write=0A=
> required zones, fio stops because no data can be read from the zones with=
=0A=
> empty status. Enforce to write at the first I/O to make sure data to read=
=0A=
> exists for the following read operations.=0A=
> =0A=
> The unexpected fio stop symptom was observed with test case #30 of=0A=
> t/zbd/test-zbd-support. When the test case was run repeatedly resetting=
=0A=
> all zones with -r option, it often passes with too short run time.=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  zbd.c | 10 ++++++++++=0A=
>  1 file changed, 10 insertions(+)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 0b0d4f40..abfa802c 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -1348,6 +1348,16 @@ enum io_u_action zbd_adjust_block(struct thread_da=
ta *td, struct io_u *io_u)=0A=
>  	if (!zbd_zone_swr(zb))=0A=
>  		return io_u_accept;=0A=
>  =0A=
> +	/*=0A=
> +	 * In case read direction is chosen for the first random I/O, fio with=
=0A=
> +	 * zonemode=3Dzbd stops because no data can be read from zoned block=0A=
> +	 * devices with all empty zones. Overwrite the first I/O direction as=
=0A=
> +	 * write to make sure data to read exists.=0A=
> +	 */=0A=
> +	if (td_rw(td) && !f->zbd_info->sectors_with_data=0A=
> +	    && !td->o.read_beyond_wp)=0A=
> +		io_u->ddir =3D DDIR_WRITE;=0A=
> +=0A=
>  	/*=0A=
>  	 * Accept the I/O offset for reads if reading beyond the write pointer=
=0A=
>  	 * is enabled.=0A=
> =0A=
=0A=
Looks OK to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoaal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

