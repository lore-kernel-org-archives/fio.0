Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:39343 "EHLO
        mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754358AbdJIUAl (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 9 Oct 2017 16:00:41 -0400
From: "Justin Eno (jeno)" <jeno@micron.com>
Subject: RE: Re: [PATCH] set td->io_ops to NULL before dlclose()
Date: Mon, 9 Oct 2017 20:00:39 +0000
Message-ID: <96ad64828e76442fa0106d3c132d6374@bowex17a.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "Harris, James R" <james.r.harris@intel.com>

On Tue, Jun 13, 2017 at 14:45:09, Harris, James R <james.r.harris@intel.com=
> wrote:=20
>=20
>> On Jun 13, 2017, at 12:45 PM, Harris, James R <james.r.harris@intel.com>=
 wrote:=20
>>=20
>> If using ioengine=3D/path/to/ioengine to dynamically load=20
>> an ioengine, there is a race between free_ioengine()'s=20
>> dlclose() and the td->io_ops dereference in reap_threads().=20
>>=20
>> To resolve, td->io_ops must be set to NULL before calling=20
>> dlclose() - this ensures the name check in reap_threads()=20
>> does not try to reference memory no longer accessible due=20
>> to the ioengine getting closed.=20
>>=20
>> Signed-off-by: Jim Harris <james.r.harris@intel.com>=20
>> ---=20
>> ioengines.c | 4 ++--=20
>> 1 file changed, 2 insertions(+), 2 deletions(-)=20
>>=20
>> diff --git a/ioengines.c b/ioengines.c=20
>> index c90a2ca5..6caf73da 100644=20
>> --- a/ioengines.c=20
>> +++ b/ioengines.c=20
>> @@ -170,10 +170,10 @@ void free_ioengine(struct thread_data *td)=20
>> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD td->eo =3D NULL;=20
>> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD }=20
>>=20
>> +=EF=BF=BD=EF=BF=BD=EF=BF=BD td->io_ops =3D NULL;=20
>> +=20
>> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD if (td->io_ops_dlhandle)=20
>> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD dlclose(td->io_ops_dlhandle);=20
>> -=20
>> -=EF=BF=BD=EF=BF=BD=EF=BF=BD td->io_ops =3D NULL;=20
>> }=20
>>=20
>> void close_ioengine(struct thread_data *td)=20
>> --=20
>> 2.12.2=20
>>=20
>=20
>Please ignore.=EF=BF=BD This only narrows the race window - it does not cl=
ose it.=20
>=20
>--=20

I also have a system that is prone to this segfault.  Without some type of =
mutex, td_iops cannot be dereferenced safely in reap_threads().

This alternative patch works for me:

Signed-off-by: Justin Eno <jeno@micron.com>
---
 backend.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/backend.c b/backend.c
index ba6f585..17c0d5b 100644
--- a/backend.c
+++ b/backend.c
@@ -1929,11 +1929,7 @@ static void reap_threads(unsigned int *nr_running, u=
int64_t *t_rate,
        for_each_td(td, i) {
                int flags =3D 0;

-               /*
-                * ->io_ops is NULL for a thread that has closed its
-                * io engine
-                */
-               if (td->io_ops && !strcmp(td->io_ops->name, "cpuio"))
+               if (!strcmp(td->o.ioengine, "cpuio"))
                        cputhreads++;
                else
                        realthreads++;
--
1.8.3.1

