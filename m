Return-Path: <jeno@micron.com>
From: "Justin Eno (jeno)" <jeno@micron.com>
Subject: RE: RE: Re: [PATCH] set td->io_ops to NULL before dlclose()
Date: Tue, 10 Oct 2017 17:28:55 +0000
Message-ID: <4d573b708a4f4aeda365a2947db3e09b@bowex17a.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

I'm top-posting here to catch your attention.  If it wasn't clear, the patc=
h I sent is generally applicable and not intended just for the original rep=
orter, i.e., it's a candidate for integration.

Thanks,
Justin

On Mon, Oct 09, 2017 at 13:00:39, Justin Eno (jeno) <jeno@micron.com> wrote=
:=20
>On Tue, Jun 13, 2017 at 14:45:09, Harris, James R <james.r.harris@intel.co=
m> wrote:=20
>>=20
>>> On Jun 13, 2017, at 12:45 PM, Harris, James R <james.r.harris@intel.com=
> wrote:=20
>>>=20
>>> If using ioengine=3D/path/to/ioengine to dynamically load=20
>>> an ioengine, there is a race between free_ioengine()'s=20
>>> dlclose() and the td->io_ops dereference in reap_threads().=20
>>>=20
>>> To resolve, td->io_ops must be set to NULL before calling=20
>>> dlclose() - this ensures the name check in reap_threads()=20
>>> does not try to reference memory no longer accessible due=20
>>> to the ioengine getting closed.=20
>>>=20
>>> Signed-off-by: Jim Harris <james.r.harris@intel.com>=20
>>> ---=20
>>> ioengines.c | 4 ++--=20
>>> 1 file changed, 2 insertions(+), 2 deletions(-)=20
>>>=20
>>> diff --git a/ioengines.c b/ioengines.c=20
>>> index c90a2ca5..6caf73da 100644=20
>>> --- a/ioengines.c=20
>>> +++ b/ioengines.c=20
>>> @@ -170,10 +170,10 @@ void free_ioengine(struct thread_data *td)=20
>>> =A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 td->eo =3D NULL;=20
>>> =A0=A0=A0=A0 }=20
>>>=20
>>> +=A0=A0=A0 td->io_ops =3D NULL;=20
>>> +=20
>>> =A0=A0=A0=A0 if (td->io_ops_dlhandle)=20
>>> =A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 dlclose(td->io_ops_dlhandle);=20
>>> -=20
>>> -=A0=A0=A0 td->io_ops =3D NULL;=20
>>> }=20
>>>=20
>>> void close_ioengine(struct thread_data *td)=20
>>> --=20
>>> 2.12.2=20
>>>=20
>>=20
>>Please ignore.=A0 This only narrows the race window - it does not close i=
t.=20
>>=20
>>--=20
>=20
>I also have a system that is prone to this segfault.=A0 Without some type =
of mutex, td_iops cannot be dereferenced safely in reap_threads().
>=20
>This alternative patch works for me:=20
>=20
>Signed-off-by: Justin Eno <jeno@micron.com>=20
>---=20
> backend.c | 6 +-----=20
> 1 file changed, 1 insertion(+), 5 deletions(-)=20
>=20
>diff --git a/backend.c b/backend.c=20
>index ba6f585..17c0d5b 100644=20
>--- a/backend.c=20
>+++ b/backend.c=20
>@@ -1929,11 +1929,7 @@ static void reap_threads(unsigned int *nr_running, =
uint64_t *t_rate,=20
>=A0=A0=A0=A0=A0=A0=A0 for_each_td(td, i) {=20
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int flags =3D 0;=20
>=20
>-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*=20
>-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * ->io_ops is NULL for a th=
read that has closed its=20
>-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * io engine=20
>-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */=20
>-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (td->io_ops && !strcmp(td->=
io_ops->name, "cpuio"))=20
>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!strcmp(td->o.ioengine, "c=
puio"))=20
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cput=
hreads++;=20
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else=20
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 real=
threads++;=20
>--=20
>1.8.3.1=20
>=20
>--=20


