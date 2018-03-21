Return-Path: <prvs=611231c00=jeff.furlong@wdc.com>
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: fio server/client disconnect bug
Date: Wed, 21 Mar 2018 16:58:32 +0000
Message-ID: <SN6PR04MB4064FBCCCA9542C6550E99668FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457692506FCB2E385AE2A2E8FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <SN6PR04MB4064CEF242E2091737402D268FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <47cd0e78-d881-a776-7f2d-c292b35e8211@kernel.dk>
 <5d0275d2-889e-314e-63bd-240d326beb47@kernel.dk>
 <33d87376-bbd9-69d9-83e0-120d93bd843d@kernel.dk>
 <SN6PR04MB4064961E38329062931640B68FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <7ea6910f-dc7b-d141-432e-62c2ee9f16ee@kernel.dk>
In-Reply-To: <7ea6910f-dc7b-d141-432e-62c2ee9f16ee@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Patch applied to latest git.  Failed after 26 iterations.  The host1 did no=
t print output to the summary file.

client: got cmd op PROBE from host2 (pdu=3D112)
client: got cmd op PROBE from host1 (pdu=3D112)
client: got cmd op START from host2 (pdu=3D8)
client: got cmd op START from host1 (pdu=3D8)
client: got cmd op ADD_JOB from host2 (pdu=3D23204)
client: got cmd op TEXT from host2 (pdu=3D70)
client: got cmd op TEXT from host2 (pdu=3D90)
client: got cmd op TEXT from host2 (pdu=3D51)
client: got cmd op ADD_JOB from host1 (pdu=3D23204)
client: got cmd op START from host2 (pdu=3D8)
client: got cmd op TEXT from host1 (pdu=3D70)
client: got cmd op TEXT from host1 (pdu=3D90)
client: got cmd op TEXT from host1 (pdu=3D51)
client: got cmd op START from host1 (pdu=3D8)
client: got cmd op TEXT from host2 (pdu=3D33)
client: got cmd op TEXT from host2 (pdu=3D33)
client: got cmd op TEXT from host2 (pdu=3D25)
client: got cmd op TEXT from host1 (pdu=3D33)
client: got cmd op TEXT from host1 (pdu=3D33)
client: got cmd op TEXT from host1 (pdu=3D25)
client: got cmd op SERVER_START from host2 (pdu=3D0)
client: got cmd op SERVER_START from host1 (pdu=3D0)
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)=3D41.6k,w=3D0 IOPS][eta 00m:0=
2s]
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)=3D41.6k,w=3D0 IOPS][eta 00m:0=
1s]
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op IOLOG from host2 (pdu=3D338)41.6k,w=3D0 IOPS][eta 00m:00=
s]
client: got cmd op IOLOG from host2 (pdu=3D327)
client: got cmd op IOLOG from host2 (pdu=3D338)
client: got cmd op IOLOG from host1 (pdu=3D337)
client: got cmd op IOLOG from host1 (pdu=3D328)
client: got cmd op IOLOG from host1 (pdu=3D336)
client: got cmd op IOLOG from host2 (pdu=3D330)
client: got cmd op IOLOG from host2 (pdu=3D327)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op TS from host2 (pdu=3D94888)
client: got cmd op GS from host2 (pdu=3D164)
client: got cmd op IOLOG from host1 (pdu=3D324)
client: got cmd op DISK_UTIL from host2 (pdu=3D256)
client: got cmd op IOLOG from host1 (pdu=3D320)
client: got cmd op TEXT from host2 (pdu=3D25)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op STOP from host2 (pdu=3D8)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op QUIT from host2 (pdu=3D0)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op STOP from host1 (pdu=3D8)
client: got cmd op QUIT from host1 (pdu=3D0)

Here is a "good" run, but one thing I note is that the host2 prints to the =
summary file first, then host1 prints, then the "all clients" print.  But I=
 list the clients in the order of host1 then host2 when running the fio cmd=
.

client: got cmd op PROBE from host2 (pdu=3D112)
client: got cmd op PROBE from host1 (pdu=3D112)
client: got cmd op START from host2 (pdu=3D8)
client: got cmd op START from host1 (pdu=3D8)
client: got cmd op ADD_JOB from host2 (pdu=3D23204)
client: got cmd op TEXT from host2 (pdu=3D70)
client: got cmd op TEXT from host2 (pdu=3D90)
client: got cmd op TEXT from host2 (pdu=3D51)
client: got cmd op START from host2 (pdu=3D8)
client: got cmd op ADD_JOB from host1 (pdu=3D23204)
client: got cmd op TEXT from host1 (pdu=3D70)
client: got cmd op TEXT from host1 (pdu=3D90)
client: got cmd op TEXT from host1 (pdu=3D51)
client: got cmd op START from host1 (pdu=3D8)
client: got cmd op TEXT from host2 (pdu=3D33)
client: got cmd op TEXT from host2 (pdu=3D33)
client: got cmd op TEXT from host2 (pdu=3D25)
client: got cmd op SERVER_START from host2 (pdu=3D0)
client: got cmd op TEXT from host1 (pdu=3D33)
client: got cmd op TEXT from host1 (pdu=3D33)
client: got cmd op TEXT from host1 (pdu=3D25)
client: got cmd op SERVER_START from host1 (pdu=3D0)
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)=3D41.6k,w=3D0 IOPS][eta 00m:0=
2s]
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)=3D41.8k,w=3D0 IOPS][eta 00m:0=
1s]
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op IOLOG from host2 (pdu=3D338)41.8k,w=3D0 IOPS][eta 00m:00=
s]
client: got cmd op IOLOG from host2 (pdu=3D328)
client: got cmd op IOLOG from host2 (pdu=3D338)
client: got cmd op IOLOG from host1 (pdu=3D337)
client: got cmd op IOLOG from host1 (pdu=3D328)
client: got cmd op IOLOG from host1 (pdu=3D337)
client: got cmd op IOLOG from host2 (pdu=3D323)
client: got cmd op IOLOG from host2 (pdu=3D321)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op JOB_OPT from host2 (pdu=3D200)
client: got cmd op TS from host2 (pdu=3D94888)
client: got cmd op GS from host2 (pdu=3D164)
client: got cmd op DISK_UTIL from host2 (pdu=3D256)
client: got cmd op TEXT from host2 (pdu=3D25)
client: got cmd op STOP from host2 (pdu=3D8)
client: got cmd op QUIT from host2 (pdu=3D0)
client: got cmd op IOLOG from host1 (pdu=3D323)
client: got cmd op IOLOG from host1 (pdu=3D321)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op TS from host1 (pdu=3D94888)
client: got cmd op GS from host1 (pdu=3D164)
client: got cmd op DISK_UTIL from host1 (pdu=3D256)
client: got cmd op TEXT from host1 (pdu=3D25)
client: got cmd op STOP from host1 (pdu=3D8)
client: got cmd op QUIT from host1 (pdu=3D0)

Regards,
Jeff

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, March 21, 2018 9:39 AM
To: Jeff Furlong <jeff.furlong@wdc.com>; fio@vger.kernel.org
Subject: Re: fio server/client disconnect bug

On 3/21/18 10:35 AM, Jeff Furlong wrote:
> No client ends in error.  In fact, I get a full set of iops/lat/bw logs f=
rom both clients.  And inspection of those logs looks good; I see the last =
1000ms timestamp is valid for the duration of runtime.  But only one client=
 prints the summary info to the output file.

Can you try with this debug patch and see if you can reproduce? Comparing a=
 good and bad run would likely be key in figuring out wtf is going on here.

diff --git a/client.c b/client.c
index bff0adc0d972..76c89a496964 100644
--- a/client.c
+++ b/client.c
@@ -1664,7 +1664,7 @@ int fio_handle_client(struct fio_client *client)
 	if (!cmd)
 		return 0;
=20
-	dprint(FD_NET, "client: got cmd op %s from %s (pdu=3D%u)\n",
+	printf("client: got cmd op %s from %s (pdu=3D%u)\n",
 		fio_server_op(cmd->opcode), client->hostname, cmd->pdu_len);
=20
 	client->last_cmd =3D cmd->opcode;

--
Jens Axboe


