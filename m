Return-Path: <prvs=393ca294f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 8/9] zbd: support verification
Date: Mon, 11 May 2020 01:59:44 +0000
Message-ID: 
 <BY5PR04MB6900AFD896A44DC670646763E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
 <20200505175634.2517-8-adobriyan@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/06 2:57, Alexey Dobriyan wrote:=0A=
> Verification is not supported in ZBD mode which is codified in this=0A=
> assert:=0A=
> =0A=
> 	if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {=0A=
> 		assert(td->o.verify =3D=3D VERIFY_NONE);=0A=
=0A=
This is not correct. Verification works just fine. The above assert is ther=
e=0A=
because if verify is enabled, zone reset is not done and full zone are igno=
red:=0A=
=0A=
static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,=
=0A=
                          uint32_t zone_idx)=0A=
{=0A=
	...=0A=
=0A=
        /*=0A=
         * Skip full zones with data verification enabled because resetting=
 a=0A=
         * zone causes data loss and hence causes verification to fail.=0A=
         */=0A=
        if (td->o.verify !=3D VERIFY_NONE && zbd_zone_full(f, z, min_bs))=
=0A=
                return false;=0A=
	...=0A=
=0A=
There are many test cases in t/zbd/test-zbd-support that have the verify op=
tion=0A=
to test it. This support is likely not perfect and may have problems, but s=
aying=0A=
that it is not supported is an overstatement.=0A=
=0A=
> However, sequential write property is excellent for actually doing=0A=
> verification if write_list and seeds are maintained per-zone.=0A=
> It will work automatically with=0A=
> * overlapping jobs=0A=
> * zone resets in the middle of job=0A=
> * different write block sizes=0A=
> =0A=
> This also paves the way to "verify before zone reset" and=0A=
> "verify zeroes after wp" features.=0A=
> =0A=
> Introduce=0A=
> *) per-zone seed,=0A=
> 	incremented with each reset, so that patterns differ=0A=
> *) per-zone random generator state,=0A=
> 	reseeded with each zone reset=0A=
> *) per-zone write I/O list=0A=
> 	linked list is natural for sequential writes=0A=
=0A=
What about conventional zones ? They can be randomly writen.=0A=
=0A=
> =0A=
> *) per-zone verify_mutex=0A=
> 	This will be used for verify-zeroes-after-wp, definitely.=0A=
=0A=
Zeroes-after-wp is not a given. SMR drives likely report that by default bu=
t if=0A=
a "format pattern" is set on SAS drives, that is the pattern that will be=
=0A=
returned. So checking for zeroes will not always work. We should always ass=
ume=0A=
"garbage" after the wp.=0A=
=0A=
> 	Currently it is more a peace of mind member otherwise list=0A=
> 	corruption asserts trigger IIRC.=0A=
> 	TODO: explain why it is needed.=0A=
> =0A=
> Delete ->verify_block -- obsoleted.=0A=
> =0A=
> There are also some funny things going on with flushing and resetting=0A=
> files in the middle of I/O but non-overlapping case more or less works.=
=0A=
=0A=
"more or less" ? Is it working or is it not ? Please clarify the exact=0A=
improvements and what remains to be fixed.=0A=
=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
>  backend.c | 44 +++++++++++++++++++++++++++++---=0A=
>  fio.h     |  2 ++=0A=
>  init.c    |  1 +=0A=
>  io_u.c    |  2 +-=0A=
>  iolog.c   | 24 ++++++++++++------=0A=
>  iolog.h   |  1 +=0A=
>  verify.c  | 45 ++++++++++++++++++++++++++-------=0A=
>  verify.h  |  4 ++-=0A=
>  zbd.c     | 75 ++++++++++++++++++++++++++++---------------------------=
=0A=
>  zbd.h     | 20 +++++++++++++--=0A=
>  10 files changed, 158 insertions(+), 60 deletions(-)=0A=
> =0A=
> diff --git a/backend.c b/backend.c=0A=
> index 452975cf..05ca5dc1 100644=0A=
> --- a/backend.c=0A=
> +++ b/backend.c=0A=
> @@ -48,6 +48,7 @@=0A=
>  #include "rate-submit.h"=0A=
>  #include "helper_thread.h"=0A=
>  #include "pshared.h"=0A=
> +#include "zbd.h"=0A=
>  #include "zone-dist.h"=0A=
>  =0A=
>  static struct fio_sem *startup_sem;=0A=
> @@ -615,7 +616,7 @@ static enum fio_q_status io_u_submit(struct thread_da=
ta *td, struct io_u *io_u)=0A=
>   * The main verify engine. Runs over the writes we previously submitted,=
=0A=
>   * reads the blocks back in, and checks the crc/md5 of the data.=0A=
>   */=0A=
> -static void do_verify(struct thread_data *td, uint64_t verify_bytes)=0A=
> +static void do_verify(struct thread_data *td, uint64_t verify_bytes, str=
uct fio_file *td_f, struct fio_zone_info *zi, bool sync)=0A=
>  {=0A=
>  	struct fio_file *f;=0A=
>  	struct io_u *io_u;=0A=
> @@ -629,8 +630,12 @@ static void do_verify(struct thread_data *td, uint64=
_t verify_bytes)=0A=
>  	 * read from disk.=0A=
>  	 */=0A=
>  	for_each_file(td, f, i) {=0A=
> +		if (td_f && f !=3D td_f)=0A=
> +			continue;=0A=
>  		if (!fio_file_open(f))=0A=
>  			continue;=0A=
> +		if (!sync)=0A=
> +			continue;=0A=
=0A=
Why are these changes needed ?=0A=
=0A=
>  		if (fio_io_sync(td, f))=0A=
>  			break;=0A=
>  		if (file_invalidate_cache(td, f))=0A=
> @@ -677,7 +682,7 @@ static void do_verify(struct thread_data *td, uint64_=
t verify_bytes)=0A=
>  			if (!io_u)=0A=
>  				break;=0A=
>  =0A=
> -			if (get_next_verify(td, io_u)) {=0A=
> +			if (get_next_verify(td, io_u, td_f, zi)) {=0A=
>  				put_io_u(td, io_u);=0A=
>  				break;=0A=
>  			}=0A=
> @@ -1516,6 +1521,35 @@ static uint64_t do_dry_run(struct thread_data *td)=
=0A=
>  	return td->bytes_done[DDIR_WRITE] + td->bytes_done[DDIR_TRIM];=0A=
>  }=0A=
>  =0A=
> +static void do_verify_zbd(struct thread_data *td, uint64_t verify_bytes)=
=0A=
> +{=0A=
> +	struct fio_file *f;=0A=
> +	unsigned int i;=0A=
> +=0A=
> +	for_each_file(td, f, i) {=0A=
> +		struct zoned_block_device_info *zbd =3D f->zbd_info;=0A=
> +		bool sync =3D true;=0A=
> +=0A=
> +		if (!zbd)=0A=
> +			continue;=0A=
> +=0A=
> +		for (uint32_t z =3D f->min_zone; z < f->max_zone; z++) {=0A=
> +			struct fio_zone_info *zi =3D &zbd->zone_info[z];=0A=
> +=0A=
> +			if (!zbd_zone_swr(zi))=0A=
> +				continue;=0A=
> +=0A=
> +			if (pthread_mutex_trylock(&zi->verify_mutex) !=3D 0) {=0A=
> +				/* Someone else is verifying this zone. */=0A=
> +				continue;=0A=
> +			}=0A=
> +			do_verify(td, verify_bytes, f, zi, sync);=0A=
> +			pthread_mutex_unlock(&zi->verify_mutex);=0A=
> +			sync =3D false;=0A=
> +		}=0A=
> +	}=0A=
> +}=0A=
=0A=
Can't we move this to zbd.c ?=0A=
=0A=
> +=0A=
>  struct fork_data {=0A=
>  	struct thread_data *td;=0A=
>  	struct sk_out *sk_out;=0A=
> @@ -1839,7 +1873,11 @@ static void *thread_main(void *data)=0A=
>  =0A=
>  		fio_gettime(&td->start, NULL);=0A=
>  =0A=
> -		do_verify(td, verify_bytes);=0A=
> +		if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD) {=0A=
> +			do_verify_zbd(td, verify_bytes);=0A=
> +		} else {=0A=
> +			do_verify(td, verify_bytes, NULL, NULL, true);=0A=
> +		}=0A=
=0A=
No need for the "{}" brackets.=0A=
=0A=
>  =0A=
>  		/*=0A=
>  		 * See comment further up for why this is done here.=0A=
> diff --git a/fio.h b/fio.h=0A=
> index 20ca80e2..42df7a50 100644=0A=
> --- a/fio.h=0A=
> +++ b/fio.h=0A=
> @@ -140,6 +140,7 @@ enum {=0A=
>  	FIO_RAND_POISSON2_OFF,=0A=
>  	FIO_RAND_POISSON3_OFF,=0A=
>  	FIO_RAND_PRIO_CMDS,=0A=
> +	FIO_RAND_ZBD,=0A=
=0A=
FIO_RAND_ZBD_VERIFY ?=0A=
=0A=
>  	FIO_RAND_NR_OFFS,=0A=
>  };=0A=
>  =0A=
> @@ -256,6 +257,7 @@ struct thread_data {=0A=
>  	struct frand_state buf_state;=0A=
>  	struct frand_state buf_state_prev;=0A=
>  	struct frand_state dedupe_state;=0A=
> +	struct frand_state zbd_state;=0A=
=0A=
A more explicit name may be better. Something like "zone_verify_state" or=
=0A=
"zbd_verify_state" ?=0A=
=0A=
>  	struct frand_state zone_state;=0A=
>  	struct frand_state prio_state;=0A=
>  =0A=
> diff --git a/init.c b/init.c=0A=
> index b5315334..d41a23ff 100644=0A=
> --- a/init.c=0A=
> +++ b/init.c=0A=
> @@ -1029,6 +1029,7 @@ static void td_fill_rand_seeds_internal(struct thre=
ad_data *td, bool use64)=0A=
>  	init_rand_seed(&td->poisson_state[1], td->rand_seeds[FIO_RAND_POISSON2_=
OFF], 0);=0A=
>  	init_rand_seed(&td->poisson_state[2], td->rand_seeds[FIO_RAND_POISSON3_=
OFF], 0);=0A=
>  	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], false=
);=0A=
> +	init_rand_seed(&td->zbd_state, td->rand_seeds[FIO_RAND_ZBD], use64);=0A=
>  	init_rand_seed(&td->zone_state, td->rand_seeds[FIO_RAND_ZONE_OFF], fals=
e);=0A=
>  	init_rand_seed(&td->prio_state, td->rand_seeds[FIO_RAND_PRIO_CMDS], fal=
se);=0A=
>  =0A=
> diff --git a/io_u.c b/io_u.c=0A=
> index 18e94617..3cd7fb71 100644=0A=
> --- a/io_u.c=0A=
> +++ b/io_u.c=0A=
> @@ -1610,7 +1610,7 @@ static bool check_get_verify(struct thread_data *td=
, struct io_u *io_u)=0A=
>  			get_verify =3D 1;=0A=
>  		}=0A=
>  =0A=
> -		if (get_verify && !get_next_verify(td, io_u)) {=0A=
> +		if (get_verify && !get_next_verify(td, io_u, NULL, NULL)) {=0A=
>  			td->verify_batch--;=0A=
>  			return true;=0A=
>  		}=0A=
> diff --git a/iolog.c b/iolog.c=0A=
> index 917a446c..732861a8 100644=0A=
> --- a/iolog.c=0A=
> +++ b/iolog.c=0A=
> @@ -19,6 +19,7 @@=0A=
>  #include "smalloc.h"=0A=
>  #include "blktrace.h"=0A=
>  #include "pshared.h"=0A=
> +#include "zbd.h"=0A=
>  =0A=
>  #include <netinet/in.h>=0A=
>  #include <netinet/tcp.h>=0A=
> @@ -231,6 +232,7 @@ void log_io_piece(struct thread_data *td, struct io_u=
 *io_u)=0A=
>  	ipo->file =3D io_u->file;=0A=
>  	ipo->offset =3D io_u->offset;=0A=
>  	ipo->len =3D io_u->buflen;=0A=
> +	ipo->seed =3D io_u->rand_seed;=0A=
>  	ipo->numberio =3D io_u->numberio;=0A=
>  	ipo->flags =3D IP_F_IN_FLIGHT;=0A=
>  =0A=
> @@ -241,12 +243,20 @@ void log_io_piece(struct thread_data *td, struct io=
_u *io_u)=0A=
>  		td->trim_entries++;=0A=
>  	}=0A=
>  =0A=
> -	/*=0A=
> -	 * Only sort writes if we don't have a random map in which case we need=
=0A=
> -	 * to check for duplicate blocks and drop the old one, which we rely on=
=0A=
> -	 * the rb insert/lookup for handling.=0A=
> -	 */=0A=
> -	if (file_randommap(td, ipo->file)) {=0A=
> +	if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD) {=0A=
> +		struct fio_file *f =3D ipo->file;=0A=
> +		uint32_t z =3D zbd_zone_idx(f, ipo->offset);=0A=
> +		struct fio_zone_info *zi =3D &f->zbd_info->zone_info[z];=0A=
=0A=
It looks like these 2 lines are now being repeated a lot. Maybe introduce a=
n=0A=
inline helper "inline struct fio_zone_info *get_zone(f, offset)" ? That wou=
ld=0A=
cleanup the code here.=0A=
=0A=
> +=0A=
> +		flist_add_tail(&ipo->list, &zi->write_list);=0A=
> +		ipo->flags |=3D IP_F_ONLIST;=0A=
> +		return;=0A=
=0A=
This change may not be necessary at all. You could force the rbtree use for=
=0A=
zonemode=3Dzbd, which will get your the sorting, so an easy access to all I=
Os for=0A=
a particular zone by searching from the zone start offset up to zone start+=
zone=0A=
size. That will remove a lot of added "if (td->o.zone_mode =3D=3D ZONE_MODE=
_ZBD) {"=0A=
and remove the need for per zone verify list & mutex.=0A=
=0A=
> +	} else if (file_randommap(td, ipo->file)) {=0A=
> +		/*=0A=
> +		 * Only sort writes if we don't have a random map in which case=0A=
> +		 * we need to check for duplicate blocks and drop the old one,=0A=
> +		 * which we rely on the rb insert/lookup for handling.=0A=
> +		 */=0A=
>  		INIT_FLIST_HEAD(&ipo->list);=0A=
>  		flist_add_tail(&ipo->list, &td->io_hist_list);=0A=
>  		ipo->flags |=3D IP_F_ONLIST;=0A=
> @@ -322,7 +332,7 @@ void unlog_io_piece(struct thread_data *td, struct io=
_u *io_u)=0A=
>  =0A=
>  	if (ipo->flags & IP_F_ONRB)=0A=
>  		rb_erase(&ipo->rb_node, &td->io_hist_tree);=0A=
> -	else if (ipo->flags & IP_F_ONLIST)=0A=
> +	else=0A=
>  		flist_del(&ipo->list);=0A=
=0A=
With your above change, both cases set IP_F_ONLIST, so why this change ?=0A=
=0A=
>  =0A=
>  	free(ipo);=0A=
> diff --git a/iolog.h b/iolog.h=0A=
> index 981081f9..7eddb8e0 100644=0A=
> --- a/iolog.h=0A=
> +++ b/iolog.h=0A=
> @@ -211,6 +211,7 @@ struct io_piece {=0A=
>  		struct fio_file *file;=0A=
>  	};=0A=
>  	unsigned long long offset;=0A=
> +	uint64_t seed;=0A=
>  	unsigned short numberio;=0A=
>  	unsigned long len;=0A=
>  	unsigned int flags;=0A=
> diff --git a/verify.c b/verify.c=0A=
> index b7fa6693..025e3eb0 100644=0A=
> --- a/verify.c=0A=
> +++ b/verify.c=0A=
> @@ -11,6 +11,7 @@=0A=
>  #include "fio.h"=0A=
>  #include "verify.h"=0A=
>  #include "trim.h"=0A=
> +#include "zbd.h"=0A=
>  #include "lib/rand.h"=0A=
>  #include "lib/hweight.h"=0A=
>  #include "lib/pattern.h"=0A=
> @@ -54,7 +55,16 @@ void fill_verify_pattern(struct thread_data *td, void =
*p, unsigned int len,=0A=
>  	if (!o->verify_pattern_bytes) {=0A=
>  		dprint(FD_VERIFY, "fill random bytes len=3D%u\n", len);=0A=
>  =0A=
> -		if (!use_seed) {=0A=
> +		if (use_seed) {=0A=
> +		} else if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD) {=0A=
> +			struct fio_file *f =3D io_u->file;=0A=
> +			uint32_t z =3D zbd_zone_idx(f, io_u->offset);=0A=
> +			struct fio_zone_info *zi =3D &f->zbd_info->zone_info[z];=0A=
> +=0A=
> +			seed =3D __rand(&zi->rand_state);=0A=
> +			if (sizeof(int) !=3D sizeof(long *))=0A=
> +				seed *=3D __rand(&zi->rand_state);=0A=
> +		} else {=0A=
>  			seed =3D __rand(&td->verify_state);=0A=
>  			if (sizeof(int) !=3D sizeof(long *))=0A=
>  				seed *=3D (unsigned long)__rand(&td->verify_state);=0A=
> @@ -1291,7 +1301,7 @@ void populate_verify_io_u(struct thread_data *td, s=
truct io_u *io_u)=0A=
>  	fill_pattern_headers(td, io_u, 0, 0);=0A=
>  }=0A=
>  =0A=
> -int get_next_verify(struct thread_data *td, struct io_u *io_u)=0A=
> +int get_next_verify(struct thread_data *td, struct io_u *io_u, struct fi=
o_file *td_f, struct fio_zone_info *zi)=0A=
>  {=0A=
>  	struct io_piece *ipo =3D NULL;=0A=
>  =0A=
> @@ -1301,7 +1311,26 @@ int get_next_verify(struct thread_data *td, struct=
 io_u *io_u)=0A=
>  	if (io_u->file)=0A=
>  		return 0;=0A=
>  =0A=
> -	if (!RB_EMPTY_ROOT(&td->io_hist_tree)) {=0A=
> +	if (zi) {=0A=
> +		pthread_mutex_lock(&zi->mutex);=0A=
> +		if (!flist_empty(&zi->write_list)) {=0A=
> +			ipo =3D flist_first_entry(&zi->write_list, struct io_piece, list);=0A=
> +=0A=
> +			/*=0A=
> +			 * Ensure that the associated IO has completed=0A=
> +			 */=0A=
> +			read_barrier();=0A=
> +			if (ipo->flags & IP_F_IN_FLIGHT) {=0A=
> +				pthread_mutex_unlock(&zi->mutex);=0A=
> +				goto nothing;=0A=
> +			}=0A=
> +=0A=
> +			flist_del(&ipo->list);=0A=
> +			assert(ipo->flags & IP_F_ONLIST);=0A=
> +			ipo->flags &=3D ~IP_F_ONLIST;=0A=
> +		}=0A=
> +		pthread_mutex_unlock(&zi->mutex);=0A=
=0A=
can we move this to zbd.c as a helper function get_next_verify_zbd() ?=0A=
=0A=
> +	} else if (!RB_EMPTY_ROOT(&td->io_hist_tree)) {=0A=
>  		struct fio_rb_node *n =3D rb_first(&td->io_hist_tree);=0A=
>  =0A=
>  		ipo =3D rb_entry(n, struct io_piece, rb_node);=0A=
> @@ -1332,10 +1361,13 @@ int get_next_verify(struct thread_data *td, struc=
t io_u *io_u)=0A=
>  	}=0A=
>  =0A=
>  	if (ipo) {=0A=
> -		td->io_hist_len--;=0A=
> +		if (!zi) {=0A=
> +			td->io_hist_len--;=0A=
> +		}=0A=
=0A=
No need for the curly brackets.=0A=
=0A=
>  =0A=
>  		io_u->offset =3D ipo->offset;=0A=
>  		io_u->buflen =3D ipo->len;=0A=
> +		io_u->rand_seed =3D ipo->seed;=0A=
>  		io_u->numberio =3D ipo->numberio;=0A=
>  		io_u->file =3D ipo->file;=0A=
>  		io_u_set(td, io_u, IO_U_F_VER_LIST);=0A=
> @@ -1363,11 +1395,6 @@ int get_next_verify(struct thread_data *td, struct=
 io_u *io_u)=0A=
>  		free(ipo);=0A=
>  		dprint(FD_VERIFY, "get_next_verify: ret io_u %p\n", io_u);=0A=
>  =0A=
> -		if (!td->o.verify_pattern_bytes) {=0A=
> -			io_u->rand_seed =3D __rand(&td->verify_state);=0A=
> -			if (sizeof(int) !=3D sizeof(long *))=0A=
> -				io_u->rand_seed *=3D __rand(&td->verify_state);=0A=
> -		}=0A=
>  		return 0;=0A=
>  	}=0A=
>  =0A=
> diff --git a/verify.h b/verify.h=0A=
> index 539e6f6c..f046d05b 100644=0A=
> --- a/verify.h=0A=
> +++ b/verify.h=0A=
> @@ -7,6 +7,8 @@=0A=
>  =0A=
>  #define FIO_HDR_MAGIC	0xacca=0A=
>  =0A=
> +struct fio_zone_info;=0A=
> +=0A=
>  enum {=0A=
>  	VERIFY_NONE =3D 0,		/* no verification */=0A=
>  	VERIFY_HDR_ONLY,		/* verify header only, kept for sake of=0A=
> @@ -94,7 +96,7 @@ struct vhdr_xxhash {=0A=
>   * Verify helpers=0A=
>   */=0A=
>  extern void populate_verify_io_u(struct thread_data *, struct io_u *);=
=0A=
> -extern int __must_check get_next_verify(struct thread_data *td, struct i=
o_u *);=0A=
> +extern int __must_check get_next_verify(struct thread_data *td, struct i=
o_u *, struct fio_file *, struct fio_zone_info *);=0A=
>  extern int __must_check verify_io_u(struct thread_data *, struct io_u **=
);=0A=
>  extern int verify_io_u_async(struct thread_data *, struct io_u **);=0A=
>  extern void fill_verify_pattern(struct thread_data *td, void *p, unsigne=
d int len, struct io_u *io_u, uint64_t seed, int use_seed);=0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index df46da42..c926df15 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -118,7 +118,7 @@ int zbd_reset_wp(struct thread_data *td, struct fio_f=
ile *f,=0A=
>   * @offset: offset in bytes. If this offset is in the first zone_size by=
tes=0A=
>   *	    past the disk size then the index of the sentinel is returned.=0A=
>   */=0A=
> -static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)=
=0A=
> +uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)=0A=
>  {=0A=
>  	uint32_t zone_idx;=0A=
>  =0A=
> @@ -130,15 +130,6 @@ static uint32_t zbd_zone_idx(const struct fio_file *=
f, uint64_t offset)=0A=
>  	return min(zone_idx, f->zbd_info->nr_zones);=0A=
>  }=0A=
>  =0A=
> -/**=0A=
> - * zbd_zone_swr - Test whether a zone requires sequential writes=0A=
> - * @z: zone info pointer.=0A=
> - */=0A=
> -static inline bool zbd_zone_swr(struct fio_zone_info *z)=0A=
> -{=0A=
> -	return z->type =3D=3D ZBD_ZONE_TYPE_SWR;=0A=
> -}=0A=
> -=0A=
>  /**=0A=
>   * zbd_zone_full - verify whether a minimum number of bytes remain in a =
zone=0A=
>   * @f: file pointer.=0A=
> @@ -499,6 +490,11 @@ out:=0A=
>  	return ret;=0A=
>  }=0A=
>  =0A=
> +static inline bool td_use64(const struct thread_data *td)=0A=
> +{=0A=
> +	return td->o.random_generator =3D=3D FIO_RAND_GEN_TAUSWORTHE64;=0A=
> +}=0A=
> +=0A=
>  /*=0A=
>   * Allocate zone information and store it into f->zbd_info if zonemode=
=3Dzbd.=0A=
>   *=0A=
> @@ -509,6 +505,7 @@ static int zbd_create_zone_info(struct thread_data *t=
d, struct fio_file *f)=0A=
>  	struct zoned_block_device_info *zbd;=0A=
>  	enum zbd_zoned_model zbd_model;=0A=
>  	pthread_mutexattr_t attr;=0A=
> +	uint64_t diff_seed;=0A=
>  	int ret;=0A=
>  =0A=
>  	assert(td->o.zone_mode =3D=3D ZONE_MODE_ZBD);=0A=
> @@ -543,6 +540,23 @@ static int zbd_create_zone_info(struct thread_data *=
td, struct fio_file *f)=0A=
>  	pthread_mutexattr_init(&attr);=0A=
>  	pthread_mutexattr_setpshared(&attr, true);=0A=
>  	pthread_mutex_init(&zbd->mutex, &attr);=0A=
> +=0A=
> +	diff_seed =3D td_use64(td)=0A=
> +		? ~(uint64_t)0 / zbd->nr_zones=0A=
> +		: ~(uint32_t)0 / zbd->nr_zones;=0A=
> +	for (uint32_t z =3D 0; z < zbd->nr_zones; z++) {=0A=
> +		struct fio_zone_info *zi =3D &zbd->zone_info[z];=0A=
> +=0A=
> +		/*=0A=
> +		 * Spread zone seeds a bit, they will be incremented=0A=
> +		 * with each reset and better stay unique.=0A=
> +		 */=0A=
> +		zi->seed =3D __rand(&td->zbd_state) + z * diff_seed;=0A=
> +		init_rand_seed(&zi->rand_state, zi->seed, td_use64(td));=0A=
> +		INIT_FLIST_HEAD(&zi->write_list);=0A=
> +		pthread_mutex_init(&zi->verify_mutex, &attr);=0A=
> +	}=0A=
> +=0A=
>  	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);=0A=
>  	for (uint32_t z =3D 0; z < zbd->nr_zones; z++) {=0A=
>  		struct fio_zone_info *zi =3D &zbd->zone_info[z];=0A=
> @@ -683,13 +697,26 @@ static int zbd_reset_range(struct thread_data *td, =
struct fio_file *f,=0A=
>  	zone_idx_e =3D zbd_zone_idx(f, offset + length);=0A=
>  	ze =3D &f->zbd_info->zone_info[zone_idx_e];=0A=
>  	for (z =3D zb; z < ze; z++) {=0A=
> +		FLIST_HEAD(write_list);=0A=
> +=0A=
>  		pthread_mutex_lock(&z->mutex);=0A=
>  		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
>  		f->zbd_info->sectors_with_data -=3D z->wp - z->start;=0A=
>  		pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
>  		z->wp =3D z->start;=0A=
> -		z->verify_block =3D 0;=0A=
> +		z->seed++;=0A=
> +		init_rand_seed(&z->rand_state, z->seed, td_use64(td));=0A=
> +		flist_splice_init(&z->write_list, &write_list);=0A=
>  		pthread_mutex_unlock(&z->mutex);=0A=
> +=0A=
> +		while (!flist_empty(&write_list)) {=0A=
> +			struct io_piece *ipo =3D flist_first_entry(&write_list, struct io_pie=
ce, list);=0A=
> +=0A=
> +			/* Data "loss"... */=0A=
=0A=
Why not force verify to run here to avoid the loss and verify failure ?=0A=
=0A=
> +			flist_del(&ipo->list);=0A=
> +			assert(ipo->flags & IP_F_ONLIST);=0A=
> +			free(ipo);=0A=
> +		}=0A=
>  	}=0A=
>  =0A=
>  	td->ts.nr_zone_resets +=3D ze - zb;=0A=
> @@ -1142,27 +1169,6 @@ out:=0A=
>  	return z;=0A=
>  }=0A=
>  =0A=
> -/* The caller must hold z->mutex. */=0A=
> -static struct fio_zone_info *zbd_replay_write_order(struct thread_data *=
td,=0A=
> -						    struct io_u *io_u,=0A=
> -						    struct fio_zone_info *z)=0A=
> -{=0A=
> -	const struct fio_file *f =3D io_u->file;=0A=
> -	const uint32_t min_bs =3D td->o.min_bs[DDIR_WRITE];=0A=
> -=0A=
> -	if (!zbd_open_zone(td, io_u, z - f->zbd_info->zone_info)) {=0A=
> -		pthread_mutex_unlock(&z->mutex);=0A=
> -		z =3D zbd_convert_to_open_zone(td, io_u);=0A=
> -		assert(z);=0A=
> -	}=0A=
> -=0A=
> -	if (z->verify_block * min_bs >=3D f->zbd_info->zone_size)=0A=
> -		log_err("%s: %d * %d >=3D %llu\n", f->file_name, z->verify_block,=0A=
> -			min_bs, (unsigned long long) f->zbd_info->zone_size);=0A=
> -	io_u->offset =3D z->start + z->verify_block++ * min_bs;=0A=
> -	return z;=0A=
> -}=0A=
> -=0A=
>  /*=0A=
>   * Find another zone for which @io_u fits below the write pointer. Start=
=0A=
>   * searching in zones @zb + 1 .. @zl and continue searching in zones=0A=
> @@ -1454,10 +1460,6 @@ enum io_u_action zbd_adjust_block(struct thread_da=
ta *td, struct io_u *io_u)=0A=
>  =0A=
>  	switch (io_u->ddir) {=0A=
>  	case DDIR_READ:=0A=
> -		if (td->runstate =3D=3D TD_VERIFYING) {=0A=
> -			zb =3D zbd_replay_write_order(td, io_u, zb);=0A=
> -			goto accept;=0A=
> -		}=0A=
>  		/*=0A=
>  		 * Check that there is enough written data in the zone to do an=0A=
>  		 * I/O of at least min_bs B. If there isn't, find a new zone for=0A=
> @@ -1532,7 +1534,6 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)=0A=
>  		}=0A=
>  		/* Reset the zone pointer if necessary */=0A=
>  		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {=0A=
> -			assert(td->o.verify =3D=3D VERIFY_NONE);=0A=
>  			/*=0A=
>  			 * Since previous write requests may have been submitted=0A=
>  			 * asynchronously and since we will submit the zone=0A=
> diff --git a/zbd.h b/zbd.h=0A=
> index fb39fb82..013c08c9 100644=0A=
> --- a/zbd.h=0A=
> +++ b/zbd.h=0A=
> @@ -23,23 +23,29 @@ enum io_u_action {=0A=
>   * struct fio_zone_info - information about a single ZBD zone=0A=
>   * @start: zone start location (bytes)=0A=
>   * @wp: zone write pointer location (bytes)=0A=
> - * @verify_block: number of blocks that have been verified for this zone=
=0A=
>   * @mutex: protects the modifiable members in this structure=0A=
>   * @type: zone type (BLK_ZONE_TYPE_*)=0A=
>   * @cond: zone state (BLK_ZONE_COND_*)=0A=
>   * @open: whether or not this zone is currently open. Only relevant if=
=0A=
>   *		max_open_zones > 0.=0A=
>   * @reset_zone: whether or not this zone should be reset before writing =
to it=0A=
> + * @seed:=0A=
> + * @rand_state:=0A=
> + * @write_list:=0A=
> + * @verify_mutex:=0A=
>   */=0A=
>  struct fio_zone_info {=0A=
>  	pthread_mutex_t		mutex;=0A=
>  	uint64_t		start;=0A=
>  	uint64_t		wp;=0A=
> -	uint32_t		verify_block;=0A=
>  	enum zbd_zone_type	type:2;=0A=
>  	enum zbd_zone_cond	cond:4;=0A=
>  	unsigned int		open:1;=0A=
>  	unsigned int		reset_zone:1;=0A=
> +	uint64_t		seed;=0A=
> +	struct frand_state	rand_state;=0A=
> +	struct flist_head	write_list;=0A=
> +	pthread_mutex_t		verify_mutex;=0A=
>  };=0A=
>  =0A=
>  /**=0A=
> @@ -89,6 +95,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, s=
truct io_u *io_u,=0A=
>  			      enum fio_ddir ddir);=0A=
>  enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *i=
o_u);=0A=
>  char *zbd_write_status(const struct thread_stat *ts);=0A=
> +uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset);=0A=
>  =0A=
>  static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status s=
tatus)=0A=
>  {=0A=
> @@ -107,4 +114,13 @@ static inline void zbd_put_io_u(struct io_u *io_u)=
=0A=
>  	}=0A=
>  }=0A=
>  =0A=
> +/**=0A=
> + * zbd_zone_swr - Test whether a zone requires sequential writes=0A=
> + * @z: zone info pointer.=0A=
> + */=0A=
> +static inline bool zbd_zone_swr(struct fio_zone_info *z)=0A=
> +{=0A=
> +	return z->type =3D=3D ZBD_ZONE_TYPE_SWR;=0A=
> +}=0A=
> +=0A=
=0A=
This change is unrelated to this patch goal. Please make this into another =
patch.=0A=
=0A=
>  #endif /* FIO_ZBD_H */=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

