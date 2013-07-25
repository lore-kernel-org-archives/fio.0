Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Helping to model this workload
Date: Thu, 25 Jul 2013 18:59:39 +0000
Message-ID: <CE16ED93.12D3F%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <20130725184244.GI29296@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <576B89AE399A0647B2AF29961DE36B78@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 7/25/13 2:42 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On Thu, Jul 25 2013, Neto, Antonio Jose Rodrigues wrote:
>> >BTW, if you use filename=3D twice like you do above, only the last one
>> >will be effective.
>>=20
>> And if I do this? file_service_type=3Drandom
>
>Doesn't matter. You have to give all files in one filename=3D statement,
>there are not additive.
>
>The below should add bs_is_seq_rand support. If you set that to 1, then:
>
>bs=3D4k,64k
>
>will not be reads 4k and writes 64k, it will be sequential 4k and random
>64k instead. Totally untested...
>
>
>diff --git a/cconv.c b/cconv.c
>index 9de4e25..8e7c69e 100644
>--- a/cconv.c
>+++ b/cconv.c
>@@ -123,6 +123,7 @@ void convert_thread_options_to_cpu(struct
>thread_options *o,
> 	o->softrandommap =3D le32_to_cpu(top->softrandommap);
> 	o->bs_unaligned =3D le32_to_cpu(top->bs_unaligned);
> 	o->fsync_on_close =3D le32_to_cpu(top->fsync_on_close);
>+	o->bs_is_seq_rand =3D le32_to_cpu(top->bs_is_seq_rand);
> 	o->random_distribution =3D le32_to_cpu(top->random_distribution);
> 	o->zipf_theta.u.f =3D
>fio_uint64_to_double(le64_to_cpu(top->zipf_theta.u.i));
> 	o->pareto_h.u.f =3D fio_uint64_to_double(le64_to_cpu(top->pareto_h.u.i))=
;
>@@ -281,6 +282,7 @@ void convert_thread_options_to_net(struct
>thread_options_pack *top,
> 	top->softrandommap =3D cpu_to_le32(o->softrandommap);
> 	top->bs_unaligned =3D cpu_to_le32(o->bs_unaligned);
> 	top->fsync_on_close =3D cpu_to_le32(o->fsync_on_close);
>+	top->bs_is_seq_rand =3D cpu_to_le32(o->bs_is_seq_rand);
> 	top->random_distribution =3D cpu_to_le32(o->random_distribution);
> 	top->zipf_theta.u.i =3D
>__cpu_to_le64(fio_double_to_uint64(o->zipf_theta.u.f));
> 	top->pareto_h.u.i =3D
>__cpu_to_le64(fio_double_to_uint64(o->pareto_h.u.f));
>diff --git a/io_u.c b/io_u.c
>index 8401719..6537c90 100644
>--- a/io_u.c
>+++ b/io_u.c
>@@ -293,7 +293,8 @@ static int get_next_seq_offset(struct thread_data
>*td, struct fio_file *f,
> }
>=20
> static int get_next_block(struct thread_data *td, struct io_u *io_u,
>-			  enum fio_ddir ddir, int rw_seq)
>+			  enum fio_ddir ddir, int rw_seq,
>+			  unsigned int *is_random)
> {
> 	struct fio_file *f =3D io_u->file;
> 	uint64_t b, offset;
>@@ -305,23 +306,30 @@ static int get_next_block(struct thread_data *td,
>struct io_u *io_u,
>=20
> 	if (rw_seq) {
> 		if (td_random(td)) {
>-			if (should_do_random(td, ddir))
>+			if (should_do_random(td, ddir)) {
> 				ret =3D get_next_rand_block(td, f, ddir, &b);
>-			else {
>+				*is_random =3D 1;
>+			} else {
>+				*is_random =3D 0;
> 				io_u->flags |=3D IO_U_F_BUSY_OK;
> 				ret =3D get_next_seq_offset(td, f, ddir, &offset);
> 				if (ret)
> 					ret =3D get_next_rand_block(td, f, ddir, &b);
> 			}
>-		} else
>+		} else {
>+			*is_random =3D 0;
> 			ret =3D get_next_seq_offset(td, f, ddir, &offset);
>+		}
> 	} else {
> 		io_u->flags |=3D IO_U_F_BUSY_OK;
>+		*is_random =3D 0;
>=20
> 		if (td->o.rw_seq =3D=3D RW_SEQ_SEQ) {
> 			ret =3D get_next_seq_offset(td, f, ddir, &offset);
>-			if (ret)
>+			if (ret) {
> 				ret =3D get_next_rand_block(td, f, ddir, &b);
>+				*is_random =3D 0;
>+			}
> 		} else if (td->o.rw_seq =3D=3D RW_SEQ_IDENT) {
> 			if (f->last_start !=3D -1ULL)
> 				offset =3D f->last_start - f->file_offset;
>@@ -353,7 +361,8 @@ static int get_next_block(struct thread_data *td,
>struct io_u *io_u,
>  * until we find a free one. For sequential io, just return the end of
>  * the last io issued.
>  */
>-static int __get_next_offset(struct thread_data *td, struct io_u *io_u)
>+static int __get_next_offset(struct thread_data *td, struct io_u *io_u,
>+			     unsigned int *is_random)
> {
> 	struct fio_file *f =3D io_u->file;
> 	enum fio_ddir ddir =3D io_u->ddir;
>@@ -366,7 +375,7 @@ static int __get_next_offset(struct thread_data *td,
>struct io_u *io_u)
> 		td->ddir_seq_nr =3D td->o.ddir_seq_nr;
> 	}
>=20
>-	if (get_next_block(td, io_u, ddir, rw_seq_hit))
>+	if (get_next_block(td, io_u, ddir, rw_seq_hit, is_random))
> 		return 1;
>=20
> 	if (io_u->offset >=3D f->io_size) {
>@@ -387,16 +396,17 @@ static int __get_next_offset(struct thread_data
>*td, struct io_u *io_u)
> 	return 0;
> }
>=20
>-static int get_next_offset(struct thread_data *td, struct io_u *io_u)
>+static int get_next_offset(struct thread_data *td, struct io_u *io_u,
>+			   unsigned int *is_random)
> {
> 	if (td->flags & TD_F_PROFILE_OPS) {
> 		struct prof_io_ops *ops =3D &td->prof_io_ops;
>=20
> 		if (ops->fill_io_u_off)
>-			return ops->fill_io_u_off(td, io_u);
>+			return ops->fill_io_u_off(td, io_u, is_random);
> 	}
>=20
>-	return __get_next_offset(td, io_u);
>+	return __get_next_offset(td, io_u, is_random);
> }
>=20
> static inline int io_u_fits(struct thread_data *td, struct io_u *io_u,
>@@ -407,14 +417,20 @@ static inline int io_u_fits(struct thread_data *td,
>struct io_u *io_u,
> 	return io_u->offset + buflen <=3D f->io_size + get_start_offset(td);
> }
>=20
>-static unsigned int __get_next_buflen(struct thread_data *td, struct
>io_u *io_u)
>+static unsigned int __get_next_buflen(struct thread_data *td, struct
>io_u *io_u,
>+				      unsigned int is_random)
> {
>-	const int ddir =3D io_u->ddir;
>+	int ddir =3D io_u->ddir;
> 	unsigned int buflen =3D 0;
> 	unsigned int minbs, maxbs;
> 	unsigned long r, rand_max;
>=20
>-	assert(ddir_rw(ddir));
>+	assert(ddir_rw(io_u->ddir));
>+
>+	if (td->o.bs_is_seq_rand)
>+		ddir =3D is_random ? DDIR_WRITE: DDIR_READ;
>+	else
>+		ddir =3D io_u->ddir;
>=20
> 	minbs =3D td->o.min_bs[ddir];
> 	maxbs =3D td->o.max_bs[ddir];
>@@ -471,16 +487,17 @@ static unsigned int __get_next_buflen(struct
>thread_data *td, struct io_u *io_u)
> 	return buflen;
> }
>=20
>-static unsigned int get_next_buflen(struct thread_data *td, struct io_u
>*io_u)
>+static unsigned int get_next_buflen(struct thread_data *td, struct io_u
>*io_u,
>+				    unsigned int is_random)
> {
> 	if (td->flags & TD_F_PROFILE_OPS) {
> 		struct prof_io_ops *ops =3D &td->prof_io_ops;
>=20
> 		if (ops->fill_io_u_size)
>-			return ops->fill_io_u_size(td, io_u);
>+			return ops->fill_io_u_size(td, io_u, is_random);
> 	}
>=20
>-	return __get_next_buflen(td, io_u);
>+	return __get_next_buflen(td, io_u, is_random);
> }
>=20
> static void set_rwmix_bytes(struct thread_data *td)
>@@ -715,6 +732,8 @@ void requeue_io_u(struct thread_data *td, struct io_u
>**io_u)
>=20
> static int fill_io_u(struct thread_data *td, struct io_u *io_u)
> {
>+	unsigned int is_random;
>+
> 	if (td->io_ops->flags & FIO_NOIO)
> 		goto out;
>=20
>@@ -740,12 +759,12 @@ static int fill_io_u(struct thread_data *td, struct
>io_u *io_u)
> 	 * No log, let the seq/rand engine retrieve the next buflen and
> 	 * position.
> 	 */
>-	if (get_next_offset(td, io_u)) {
>+	if (get_next_offset(td, io_u, &is_random)) {
> 		dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
> 		return 1;
> 	}
>=20
>-	io_u->buflen =3D get_next_buflen(td, io_u);
>+	io_u->buflen =3D get_next_buflen(td, io_u, is_random);
> 	if (!io_u->buflen) {
> 		dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
> 		return 1;
>diff --git a/options.c b/options.c
>index 3da376e..1816d0b 100644
>--- a/options.c
>+++ b/options.c
>@@ -1558,6 +1558,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
> 		.group	=3D FIO_OPT_G_INVALID,
> 	},
> 	{
>+		.name	=3D "bs_is_seq_rand",
>+		.lname	=3D "Block size division is seq/random (not read/write)",
>+		.type	=3D FIO_OPT_BOOL,
>+		.off1	=3D td_var_offset(bs_is_seq_rand),
>+		.help	=3D "Consider any blocksize setting to be sequential,ramdom",
>+		.def	=3D "0",
>+		.parent =3D "blocksize",
>+		.category =3D FIO_OPT_C_IO,
>+		.group	=3D FIO_OPT_G_INVALID,
>+	},
>+	{
> 		.name	=3D "randrepeat",
> 		.lname	=3D "Random repeatable",
> 		.type	=3D FIO_OPT_BOOL,
>diff --git a/profile.h b/profile.h
>index 3c8d61f..de35e9b 100644
>--- a/profile.h
>+++ b/profile.h
>@@ -10,8 +10,8 @@ struct prof_io_ops {
> 	int (*td_init)(struct thread_data *);
> 	void (*td_exit)(struct thread_data *);
>=20
>-	int (*fill_io_u_off)(struct thread_data *, struct io_u *);
>-	int (*fill_io_u_size)(struct thread_data *, struct io_u *);
>+	int (*fill_io_u_off)(struct thread_data *, struct io_u *, unsigned int
>*);
>+	int (*fill_io_u_size)(struct thread_data *, struct io_u *, unsigned
>int);
> 	struct fio_file *(*get_next_file)(struct thread_data *);
>=20
> 	int (*io_u_lat)(struct thread_data *, uint64_t);
>diff --git a/thread_options.h b/thread_options.h
>index 32677e2..eaafaee 100644
>--- a/thread_options.h
>+++ b/thread_options.h
>@@ -105,6 +105,7 @@ struct thread_options {
> 	unsigned int softrandommap;
> 	unsigned int bs_unaligned;
> 	unsigned int fsync_on_close;
>+	unsigned int bs_is_seq_rand;
>=20
> 	unsigned int random_distribution;
>=20
>@@ -317,6 +318,7 @@ struct thread_options_pack {
> 	uint32_t softrandommap;
> 	uint32_t bs_unaligned;
> 	uint32_t fsync_on_close;
>+	uint32_t bs_is_seq_rand;
>=20
> 	uint32_t random_distribution;
> 	fio_fp64_t zipf_theta;
>
>--=20
>Jens Axboe
>
>--
>To unsubscribe from this list: send the line "unsubscribe fio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thank you Jens, I appreciate. I will test it.

Question: How can I access multiple devices for example /dev/sda and
/dev/sdb?

Something like =3D filename=3D/dev/sda,/dev/sdb?
>


