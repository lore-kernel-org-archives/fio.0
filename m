Return-Path: <prvs=611231c00=jeff.furlong@wdc.com>
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: fio server/client disconnect bug
Date: Wed, 21 Mar 2018 21:45:01 +0000
Message-ID: <SN6PR04MB406466E455A80B33C8F6B1958FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
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
 <SN6PR04MB4064F083D89C0947AB30857A8FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <82ede445-cba9-8611-0d28-0f21aaab3875@kernel.dk>
In-Reply-To: <82ede445-cba9-8611-0d28-0f21aaab3875@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Ran over 600 iterations so far without issue.  Will keep running to get a h=
igher confidence.  That way this issue will be fresh in our minds, given th=
e fun sequence we just traced through.

So the summary is to not add the QUIT command to the inline queue, and just=
 process it like most other typical commands?  The only thing that gets pro=
cessed separately are errors or triggers?

Regards,
Jeff


-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, March 21, 2018 12:50 PM
To: Jeff Furlong <jeff.furlong@wdc.com>; fio@vger.kernel.org
Subject: Re: fio server/client disconnect bug

On 3/21/18 1:45 PM, Jeff Furlong wrote:
> There is noticeable slowdown with this patch.  Seems some iterations (eve=
n successful) are taking several seconds of usleep().  Eventually hit a new=
 issue:
>=20
> fio: client host1, timeout on cmd SEND_ETA
> fio: client host1 timed out
>=20
> But host1 still logged the iops/bw/lat logs, but did not send summary to =
output.

Can you try this one?


diff --git a/server.c b/server.c
index 65d4484edae5..6064d8172a3b 100644
--- a/server.c
+++ b/server.c
@@ -616,7 +616,7 @@ static int fio_net_queue_quit(void)  {
 	dprint(FD_NET, "server: sending quit\n");
=20
-	return fio_net_queue_cmd(FIO_NET_CMD_QUIT, NULL, 0, NULL, SK_F_SIMPLE | S=
K_F_INLINE);
+	return fio_net_queue_cmd(FIO_NET_CMD_QUIT, NULL, 0, NULL,=20
+SK_F_SIMPLE);
 }
=20
 int fio_net_send_quit(int sk)
@@ -636,7 +636,7 @@ static int fio_net_send_ack(struct fio_net_cmd *cmd, in=
t error, int signal)
=20
 	epdu.error =3D __cpu_to_le32(error);
 	epdu.signal =3D __cpu_to_le32(signal);
-	return fio_net_queue_cmd(FIO_NET_CMD_STOP, &epdu, sizeof(epdu), &tag, SK_=
F_COPY | SK_F_INLINE);
+	return fio_net_queue_cmd(FIO_NET_CMD_STOP, &epdu, sizeof(epdu), &tag,=20
+SK_F_COPY);
 }
=20
 static int fio_net_queue_stop(int error, int signal)

--
Jens Axboe


