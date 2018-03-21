Return-Path: <prvs=611231c00=jeff.furlong@wdc.com>
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: fio server/client disconnect bug
Date: Wed, 21 Mar 2018 19:45:13 +0000
Message-ID: <SN6PR04MB4064F083D89C0947AB30857A8FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457692506FCB2E385AE2A2E8FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <SN6PR04MB4064CEF242E2091737402D268FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <47cd0e78-d881-a776-7f2d-c292b35e8211@kernel.dk>
 <5d0275d2-889e-314e-63bd-240d326beb47@kernel.dk>
 <33d87376-bbd9-69d9-83e0-120d93bd843d@kernel.dk>
 <SN6PR04MB4064961E38329062931640B68FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <7ea6910f-dc7b-d141-432e-62c2ee9f16ee@kernel.dk>
 <SN6PR04MB4064FBCCCA9542C6550E99668FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <4f5b0878-83fc-a224-e6b0-06896cd2155b@kernel.dk>
 <SN6PR04MB40649D252EA6B8B0E16BE8E18FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <590553ff-0e9c-b679-1bcc-be9ae3a840ef@kernel.dk>
 <027c68c5-549d-8b4e-f606-84f8b321eb04@kernel.dk>
 <920b95c9-070a-b3ba-1da3-8b28cf9a82d9@kernel.dk>
In-Reply-To: <920b95c9-070a-b3ba-1da3-8b28cf9a82d9@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

There is noticeable slowdown with this patch.  Seems some iterations (even =
successful) are taking several seconds of usleep().  Eventually hit a new i=
ssue:

fio: client host1, timeout on cmd SEND_ETA
fio: client host1 timed out

But host1 still logged the iops/bw/lat logs, but did not send summary to ou=
tput.

Regards,
Jeff

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, March 21, 2018 12:10 PM
To: Jeff Furlong <jeff.furlong@wdc.com>; fio@vger.kernel.org
Subject: Re: fio server/client disconnect bug

On 3/21/18 1:03 PM, Jens Axboe wrote:
> Shoot, I think I see what it is. Some commands we punt to out-of-line=20
> sending, others we do inline. STOP/QUIT are inline, whereas the=20
> ts/gs/du are not. So we could potentially have a situation where we=20
> queue up the ts/gs/du, but then process the STOP/QUIT first. If we do=20
> that, then we don't get any output...
>=20
> Let me think about this for a bit, and see what I can come up with.

Can you try with this? Can be improved to have the thread signal us, but it=
 should be a rare occurrence and a 1ms stall from this context isn't a conc=
ern.

diff --git a/server.c b/server.c
index 65d4484edae5..52bcf7bf44c6 100644
--- a/server.c
+++ b/server.c
@@ -551,9 +551,15 @@ static void fio_net_queue_entry(struct sk_entry *entry=
)  {
 	struct sk_out *sk_out =3D pthread_getspecific(sk_out_key);
=20
-	if (entry->flags & SK_F_INLINE)
+	if (entry->flags & SK_F_INLINE) {
+		/*
+		 * Honor ordering - if the out-of-line queue isn't empty,
+		 * wait for it to drain before proceeding.
+		 */
+		while (!flist_empty(&sk_out->list))
+			usleep(1000);
 		handle_sk_entry(sk_out, entry);
-	else {
+	} else {
 		sk_lock(sk_out);
 		flist_add_tail(&entry->list, &sk_out->list);
 		sk_unlock(sk_out);

--
Jens Axboe


