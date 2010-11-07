Return-Path: <bart.vanassche@gmail.com>
MIME-Version: 1.0
From: Bart Van Assche <bvanassche@acm.org>
Sender: "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>
Date: Sun, 7 Nov 2010 05:58:05 -0700
Subject: Re: RFC: Data pattern buffer filling race condition fix
Message-ID: <AANLkTimVcMvOH55xZvTFHxbZHesTXoyi=Y3bRqnALLTS@mail.gmail.com>
References: <201011061035.18709.bvanassche@acm.org>
 <4CD690DF.6090807@fusionio.com>
In-Reply-To: <4CD690DF.6090807@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Radha Ramachandran <radha@google.com>
List-ID: <fio@vger.kernel.org>

On Sun, Nov 7, 2010 at 12:43 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> On 2010-11-06 10:35, Bart Van Assche wrote:
> > On multicore non-x86 CPUs fio has been observed to frequently reports f=
alse
> > data verification failures with I/O engine libaio and I/O depths above =
one.
> > This is because of a race condition in the function fill_pattern(). The=
 code
> > in that function only works correct if all CPUs of a multicore system
> > observe store instructions in the order they were issued. That is the c=
ase for
> > multicore x86 systems but not for all other CPU families, such as e.g. =
the
> > POWER CPU family.
> >
> > As far as I can see this bug was introduced via commit
> > cbe8d7561cf6d81d741d87eb7940db2a111d2144 (July 14, 2010).
> >
> > I'm posting this patch as an RFC since the fix is GCC-specific.
>
> ppc is notorious for its weaker memory ordering. I do have a ppc test
> box, but haven't used it in a while. But it used to find bugs
> immediately for race conditions, that x86 would never trigger. So since
> you are pin pointing that particular commit, you are convinced that this
> bug manifests itself due to bad ordering between the filled buffer and
> the fill length?

I haven't done a full bisect, but fio version 1.41.6 (Jul 9, 2010) + a
backport of the PowerPC version of get_cpu_clock() (commit
5f39d8f797fcf01bd94b89ef7ed2bdb76deb2601 from August 10, 2010) was working
fine. And it is easy to see how reordered writes will cause commit
cbe8d7561cf6d81d741d87eb7940db2a111d2144 to make fio behave incorrectly.

> > diff --git a/verify.c b/verify.c
> > index ea1a911..3826198 100644
> > --- a/verify.c
> > +++ b/verify.c
> > @@ -31,18 +31,27 @@ void fill_pattern(struct thread_data *td, void *p, =
unsigned int len, struct io_u
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 fill_random_buf(p, len);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> > =A0 =A0 =A0 case 1:
> > +#ifdef __GNUC__
> > + =A0 =A0 =A0 =A0 =A0 =A0 __sync_synchronize();
> > +#endif
>
> You should be able to use the fio included write_barrier() and
> read_barrier(), which are hooked to the architectures. Then you don't
> need to use GNUC additions.

This patch also works for me on PowerPC:

Signed-off-by: Bart Van Assche <bvanassche@acm.org>

diff --git a/verify.c b/verify.c
index ea1a911..c5b2fbe 100644
--- a/verify.c
+++ b/verify.c
@@ -31,18 +31,21 @@ void fill_pattern(struct thread_data *td, void *p,
unsigned int len, struct io_u
 		fill_random_buf(p, len);
 		break;
 	case 1:
+		write_barrier();
 		if (io_u->buf_filled_len >=3D len) {
 			dprint(FD_VERIFY, "using already filled verify pattern b=3D0 len=3D%u\n=
", len);
 			return;
 		}
 		dprint(FD_VERIFY, "fill verify pattern b=3D0 len=3D%u\n", len);
 		memset(p, td->o.verify_pattern[0], len);
+		write_barrier();
 		io_u->buf_filled_len =3D len;
 		break;
 	default: {
 		unsigned int i =3D 0, size =3D 0;
 		unsigned char *b =3D p;

+		write_barrier();
 		if (io_u->buf_filled_len >=3D len) {
 			dprint(FD_VERIFY, "using already filled verify pattern b=3D%d len=3D%u\=
n",
 					td->o.verify_pattern_bytes, len);
@@ -58,6 +61,7 @@ void fill_pattern(struct thread_data *td, void *p,
unsigned int len, struct io_u
 			memcpy(b+i, td->o.verify_pattern, size);
 			i +=3D size;
 		}
+		write_barrier();
 		io_u->buf_filled_len =3D len;
 		break;
 		}

