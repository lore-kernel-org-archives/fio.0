Return-Path: <prvs=393ca294f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/9] verify: decouple seed generation from buffer fill
Date: Mon, 11 May 2020 00:56:56 +0000
Message-ID: 
 <BY5PR04MB690068D07234C9EA048C26E4E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/06 2:56, Alexey Dobriyan wrote:=0A=
> It is nicer this way and there will be more code in this area=0A=
> with ZBD verification.=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
>  backend.c |  6 ------=0A=
>  verify.c  | 20 +++++++-------------=0A=
>  2 files changed, 7 insertions(+), 19 deletions(-)=0A=
> =0A=
> diff --git a/backend.c b/backend.c=0A=
> index feb34e51..452975cf 100644=0A=
> --- a/backend.c=0A=
> +++ b/backend.c=0A=
> @@ -1006,12 +1006,6 @@ static void do_io(struct thread_data *td, uint64_t=
 *bytes_done)=0A=
>  		if (td->o.verify !=3D VERIFY_NONE && io_u->ddir =3D=3D DDIR_READ &&=0A=
>  		    ((io_u->flags & IO_U_F_VER_LIST) || !td_rw(td))) {=0A=
>  =0A=
> -			if (!td->o.verify_pattern_bytes) {=0A=
> -				io_u->rand_seed =3D __rand(&td->verify_state);=0A=
> -				if (sizeof(int) !=3D sizeof(long *))=0A=
> -					io_u->rand_seed *=3D __rand(&td->verify_state);=0A=
> -			}=0A=
> -=0A=
>  			if (verify_state_should_stop(td, io_u)) {=0A=
>  				put_io_u(td, io_u);=0A=
>  				break;=0A=
> diff --git a/verify.c b/verify.c=0A=
> index cf299ebf..b7fa6693 100644=0A=
> --- a/verify.c=0A=
> +++ b/verify.c=0A=
> @@ -46,15 +46,6 @@ static void __fill_buffer(struct thread_options *o, ui=
nt64_t seed, void *p,=0A=
>  	__fill_random_buf_percentage(seed, p, o->compress_percentage, len, len,=
 o->buffer_pattern, o->buffer_pattern_bytes);=0A=
>  }=0A=
>  =0A=
> -static uint64_t fill_buffer(struct thread_data *td, void *p,=0A=
> -			    unsigned int len)=0A=
> -{=0A=
> -	struct frand_state *fs =3D &td->verify_state;=0A=
> -	struct thread_options *o =3D &td->o;=0A=
> -=0A=
> -	return fill_random_buf_percentage(fs, p, o->compress_percentage, len, l=
en, o->buffer_pattern, o->buffer_pattern_bytes);=0A=
> -}=0A=
> -=0A=
>  void fill_verify_pattern(struct thread_data *td, void *p, unsigned int l=
en,=0A=
>  			 struct io_u *io_u, uint64_t seed, int use_seed)=0A=
>  {=0A=
> @@ -63,10 +54,13 @@ void fill_verify_pattern(struct thread_data *td, void=
 *p, unsigned int len,=0A=
>  	if (!o->verify_pattern_bytes) {=0A=
>  		dprint(FD_VERIFY, "fill random bytes len=3D%u\n", len);=0A=
>  =0A=
> -		if (use_seed)=0A=
> -			__fill_buffer(o, seed, p, len);=0A=
> -		else=0A=
> -			io_u->rand_seed =3D fill_buffer(td, p, len);=0A=
> +		if (!use_seed) {=0A=
> +			seed =3D __rand(&td->verify_state);=0A=
> +			if (sizeof(int) !=3D sizeof(long *))=0A=
> +				seed *=3D (unsigned long)__rand(&td->verify_state);=0A=
> +		}=0A=
> +		io_u->rand_seed =3D seed;=0A=
> +		__fill_buffer(o, seed, p, len);=0A=
>  		return;=0A=
>  	}=0A=
>  =0A=
> =0A=
=0A=
Looks OK to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

