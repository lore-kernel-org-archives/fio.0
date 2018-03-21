Return-Path: <prvs=611231c00=jeff.furlong@wdc.com>
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: fio server/client disconnect bug
Date: Wed, 21 Mar 2018 19:23:06 +0000
Message-ID: <SN6PR04MB40649636BF7AD5476E55FCAC8FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
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
In-Reply-To: <590553ff-0e9c-b679-1bcc-be9ae3a840ef@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Here's the failing case:

client: got cmd op PROBE from host2 (pdu=3D112)
client: got cmd op PROBE from host1 (pdu=3D112)
client: got cmd op START from host2 (pdu=3D8)
client: got cmd op START from host1 (pdu=3D8)
client: got cmd op ADD_JOB from host2 (pdu=3D23204)
client: got cmd op TEXT from host2 (pdu=3D70)
client: got cmd op ADD_JOB from host1 (pdu=3D23204)
client: got cmd op TEXT from host2 (pdu=3D90)
client: got cmd op TEXT from host1 (pdu=3D70)
client: got cmd op TEXT from host2 (pdu=3D51)
client: got cmd op TEXT from host1 (pdu=3D90)
client: got cmd op START from host2 (pdu=3D8)
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
client: got cmd op ETA from host2 (pdu=3D165)=3D41.7k,w=3D0 IOPS][eta 00m:0=
2s]
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)=3D41.7k,w=3D0 IOPS][eta 00m:0=
1s]
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op IOLOG from host2 (pdu=3D338)41.8k,w=3D0 IOPS][eta 00m:00=
s]
client: got cmd op IOLOG from host2 (pdu=3D328)
client: got cmd op IOLOG from host1 (pdu=3D338)
client: got cmd op IOLOG from host2 (pdu=3D338)
client: got cmd op IOLOG from host1 (pdu=3D329)
client: got cmd op IOLOG from host1 (pdu=3D338)
client: got cmd op IOLOG from host2 (pdu=3D331)
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
client: got cmd op STOP from host2 (pdu=3D8)
client: got cmd op IOLOG from host1 (pdu=3D329)
client: got cmd op QUIT from host2 (pdu=3D0)
client: got cmd op IOLOG from host1 (pdu=3D327)
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
client: got cmd op STOP from host1 (pdu=3D8)
client: got cmd op QUIT from host1 (pdu=3D0)

And a good case:

client: got cmd op PROBE from host2 (pdu=3D112)
client: got cmd op PROBE from host1 (pdu=3D112)
client: got cmd op START from host2 (pdu=3D8)
client: got cmd op START from host1 (pdu=3D8)
client: got cmd op ADD_JOB from host1 (pdu=3D23204)
client: got cmd op TEXT from host1 (pdu=3D70)
client: got cmd op TEXT from host1 (pdu=3D90)
client: got cmd op TEXT from host1 (pdu=3D51)
client: got cmd op START from host1 (pdu=3D8)
client: got cmd op ADD_JOB from host2 (pdu=3D23204)
client: got cmd op TEXT from host2 (pdu=3D70)
client: got cmd op TEXT from host2 (pdu=3D90)
client: got cmd op TEXT from host2 (pdu=3D51)
client: got cmd op START from host2 (pdu=3D8)
client: got cmd op TEXT from host1 (pdu=3D33)
client: got cmd op TEXT from host1 (pdu=3D33)
client: got cmd op TEXT from host1 (pdu=3D25)
client: got cmd op TEXT from host2 (pdu=3D33)
client: got cmd op TEXT from host2 (pdu=3D33)
client: got cmd op TEXT from host2 (pdu=3D25)
client: got cmd op SERVER_START from host1 (pdu=3D0)
client: got cmd op SERVER_START from host2 (pdu=3D0)
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op ETA from host1 (pdu=3D165)
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op ETA from host1 (pdu=3D165)=3D41.5k,w=3D0 IOPS][eta 00m:0=
2s]
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op ETA from host1 (pdu=3D165)=3D41.5k,w=3D0 IOPS][eta 00m:0=
1s]
client: got cmd op ETA from host2 (pdu=3D165)
client: got cmd op IOLOG from host1 (pdu=3D336)41.7k,w=3D0 IOPS][eta 00m:00=
s]
client: got cmd op IOLOG from host1 (pdu=3D328)
client: got cmd op IOLOG from host1 (pdu=3D338)
client: got cmd op IOLOG from host2 (pdu=3D335)
client: got cmd op IOLOG from host2 (pdu=3D327)
client: got cmd op IOLOG from host2 (pdu=3D337)
client: got cmd op IOLOG from host1 (pdu=3D329)
client: got cmd op IOLOG from host1 (pdu=3D328)
should send TS
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
should send GS
client: got cmd op JOB_OPT from host1 (pdu=3D200)
client: got cmd op TS from host1 (pdu=3D94888)
client: got cmd op STOP from host1 (pdu=3D8)
client: got cmd op QUIT from host1 (pdu=3D0)
client: got cmd op IOLOG from host2 (pdu=3D322)
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
client: got cmd op STOP from host2 (pdu=3D8)
client: got cmd op QUIT from host2 (pdu=3D0)

Let me try your latest patch.

Regards,
Jeff


-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, March 21, 2018 11:39 AM
To: Jeff Furlong <jeff.furlong@wdc.com>; fio@vger.kernel.org
Subject: Re: fio server/client disconnect bug

On 3/21/18 12:16 PM, Jeff Furlong wrote:
> Here's the failing case where host1 does not print:
>=20
> back=3D1, groupid=3D0, nr_ts=3D1
> client: got cmd op PROBE from host2 (pdu=3D112) client host2 removed 2
> client: got cmd op PROBE from host1 (pdu=3D112) client host1 removed 2
> client: got cmd op START from host2 (pdu=3D8) client host2 removed 2
> client: got cmd op START from host1 (pdu=3D8) client host1 removed 2
> client: got cmd op ADD_JOB from host2 (pdu=3D23204) client host2 removed=
=20
> 2
> client: got cmd op TEXT from host2 (pdu=3D70) client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=3D90) client host2 removed 2
> client: got cmd op ADD_JOB from host1 (pdu=3D23204) client host1 removed=
=20
> 2
> client: got cmd op TEXT from host2 (pdu=3D51) client host2 removed 2
> client: got cmd op TEXT from host1 (pdu=3D70) client host1 removed 2
> client: got cmd op START from host2 (pdu=3D8) client host2 removed 2
> client: got cmd op TEXT from host1 (pdu=3D90) client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=3D51) client host1 removed 2
> client: got cmd op START from host1 (pdu=3D8) client host1 removed 2
> client: got cmd op TEXT from host2 (pdu=3D33) client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=3D33) client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=3D25) client host2 removed 2
> client: got cmd op TEXT from host1 (pdu=3D33) client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=3D33) client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=3D25) client host1 removed 2
> client: got cmd op SERVER_START from host2 (pdu=3D0) client host2=20
> removed 2
> client: got cmd op SERVER_START from host1 (pdu=3D0) client host1=20
> removed 2
> client: got cmd op ETA from host2 (pdu=3D165) client host2 removed 2
> client: got cmd op ETA from host1 (pdu=3D165) client host1 removed 2
> client: got cmd op ETA from host2 (pdu=3D165) client host2 removed 2
> client: got cmd op ETA from host1 (pdu=3D165) client host1 removed 2
> client: got cmd op ETA from host2 (pdu=3D165) client host2 removed 2
> client: got cmd op ETA from host1 (pdu=3D165) client host1 removed=20
> 25.0%][r=3D2667M,w=3D0k][r=3D41.7k,w=3D0 IOPS][eta 00m:02s]
> client: got cmd op ETA from host2 (pdu=3D165) client host2 removed 2
> client: got cmd op ETA from host1 (pdu=3D165) client host1 removed=20
> 28.9%][r=3D2661M,w=3D0k][r=3D41.6k,w=3D0 IOPS][eta 00m:01s]
> client: got cmd op ETA from host2 (pdu=3D165) client host2 removed 2
> client: got cmd op ETA from host1 (pdu=3D165) client host1 removed=20
> 200.0%][r=3D2669M,w=3D0k][r=3D41.7k,w=3D0 IOPS][eta 00m:00s]
> client: got cmd op IOLOG from host2 (pdu=3D338) client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=3D327) client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=3D337) client host2 removed 2
> client: got cmd op IOLOG from host1 (pdu=3D338) client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=3D325) client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=3D337) client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=3D323) client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=3D320) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op STOP from host1 (pdu=3D8) client host1 removed 2
> client: got cmd op QUIT from host1 (pdu=3D0) client host1 removed 2=20
> client host1 removed 1
> client: got cmd op IOLOG from host2 (pdu=3D331) client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=3D327) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op TS from host2 (pdu=3D94888) client host2 removed 2
> client: got cmd op GS from host2 (pdu=3D164) client host2 removed 2
> client: got cmd op DISK_UTIL from host2 (pdu=3D256) client host2 removed=
=20
> 2
> client: got cmd op TEXT from host2 (pdu=3D25) client host2 removed 2
> client: got cmd op STOP from host2 (pdu=3D8) client host2 removed 2
> client: got cmd op QUIT from host2 (pdu=3D0) client host2 removed 2=20
> client host2 removed 1
>=20
> And here's a good case:
>=20
> client: got cmd op PROBE from host2 (pdu=3D112) client host2 removed 2
> client: got cmd op PROBE from host1 (pdu=3D112) client host1 removed 2
> client: got cmd op START from host2 (pdu=3D8) client host2 removed 2
> client: got cmd op START from host1 (pdu=3D8) client host1 removed 2
> client: got cmd op ADD_JOB from host2 (pdu=3D23204) client host2 removed=
=20
> 2
> client: got cmd op TEXT from host2 (pdu=3D70) client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=3D90) client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=3D51) client host2 removed 2
> client: got cmd op START from host2 (pdu=3D8) client host2 removed 2
> client: got cmd op ADD_JOB from host1 (pdu=3D23204) client host1 removed=
=20
> 2
> client: got cmd op TEXT from host1 (pdu=3D70) client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=3D90) client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=3D51) client host1 removed 2
> client: got cmd op START from host1 (pdu=3D8) client host1 removed 2
> client: got cmd op TEXT from host2 (pdu=3D33) client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=3D33) client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=3D25) client host2 removed 2
> client: got cmd op SERVER_START from host2 (pdu=3D0) client host2=20
> removed 2
> client: got cmd op TEXT from host1 (pdu=3D33) client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=3D33) client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=3D25) client host1 removed 2
> client: got cmd op SERVER_START from host1 (pdu=3D0) client host1=20
> removed 2
> client: got cmd op ETA from host2 (pdu=3D165) client host2 removed 2
> client: got cmd op ETA from host1 (pdu=3D165) client host1 removed 2
> client: got cmd op ETA from host2 (pdu=3D165) client host2 removed 2
> client: got cmd op ETA from host1 (pdu=3D165) client host1 removed 2
> client: got cmd op ETA from host2 (pdu=3D165) client host2 removed 2
> client: got cmd op ETA from host1 (pdu=3D165) client host1 removed=20
> 25.0%][r=3D2667M,w=3D0k][r=3D41.7k,w=3D0 IOPS][eta 00m:02s]
> client: got cmd op ETA from host2 (pdu=3D165) client host2 removed 2
> client: got cmd op ETA from host1 (pdu=3D165) client host1 removed=20
> 28.9%][r=3D2669M,w=3D0k][r=3D41.7k,w=3D0 IOPS][eta 00m:01s]
> client: got cmd op ETA from host2 (pdu=3D165) client host2 removed 2
> client: got cmd op ETA from host1 (pdu=3D165) client host1 removed=20
> 200.0%][r=3D2675M,w=3D0k][r=3D41.8k,w=3D0 IOPS][eta 00m:00s]
> client: got cmd op IOLOG from host2 (pdu=3D336) client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=3D327) client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=3D337) client host2 removed 2
> client: got cmd op IOLOG from host1 (pdu=3D338) client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=3D327) client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=3D338) client host1 removed 2
> client: got cmd op IOLOG from host2 (pdu=3D330) client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=3D327) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=3D200) client host2 removed 2
> client: got cmd op TS from host2 (pdu=3D94888) client host2 removed 2
> client: got cmd op GS from host2 (pdu=3D164) client host2 removed 2
> client: got cmd op DISK_UTIL from host2 (pdu=3D256) client host2 removed=
=20
> 2
> client: got cmd op TEXT from host2 (pdu=3D25) client host2 removed 2
> client: got cmd op STOP from host2 (pdu=3D8) client host2 removed 2
> client: got cmd op QUIT from host2 (pdu=3D0) client host2 removed 2=20
> client host2 removed 1
> client: got cmd op IOLOG from host1 (pdu=3D330) client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=3D327) back=3D1, groupid=3D0,=20
> nr_ts=3D1 client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=3D200) client host1 removed 2
> client: got cmd op TS from host1 (pdu=3D94888) client host1 removed 2
> client: got cmd op GS from host1 (pdu=3D164) client host1 removed 2
> client: got cmd op DISK_UTIL from host1 (pdu=3D256) client host1 removed=
=20
> 2
> client: got cmd op TEXT from host1 (pdu=3D25) client host1 removed 2
> client: got cmd op STOP from host1 (pdu=3D8) client host1 removed 2
> client: got cmd op QUIT from host1 (pdu=3D0) client host1 removed 2=20
> client host1 removed 1

So puzzling... It prints all the right things, but for some reason we are n=
ot doing the ts/gs/disk_util send for the host in some cases.
For the life of me, I can't see how that would happen! We just go straight =
from the job option sends, and then don't do the rest in __show_run_stats()=
.

And thanks for the quick turn-around on the debugging, it's key to getting =
this resolved since I can't reproduce this myself. Can you run with this on=
e? Backout the previous one first.


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
diff --git a/server.c b/server.c
index 65d4484edae5..e78f6f64824d 100644
--- a/server.c
+++ b/server.c
@@ -551,6 +551,8 @@ static void fio_net_queue_entry(struct sk_entry *entry)=
  {
 	struct sk_out *sk_out =3D pthread_getspecific(sk_out_key);
=20
+	printf("queue cmd op=3D%x, sock=3D%d\n", entry->opcode, sk_out->sk);
+
 	if (entry->flags & SK_F_INLINE)
 		handle_sk_entry(sk_out, entry);
 	else {
@@ -1177,6 +1179,7 @@ static int handle_xmits(struct sk_out *sk_out)
 	while (!flist_empty(&list)) {
 		entry =3D flist_entry(list.next, struct sk_entry, list);
 		flist_del(&entry->list);
+		printf("xmit op %x\n", entry->opcode);
 		ret +=3D handle_sk_entry(sk_out, entry);
 	}
=20
diff --git a/stat.c b/stat.c
index 98ab63893900..558786f52751 100644
--- a/stat.c
+++ b/stat.c
@@ -1891,6 +1891,7 @@ void __show_run_stats(void)
=20
 		if (is_backend) {
 			fio_server_send_job_options(opt_lists[i], i);
+			printf("should send TS\n");
 			fio_server_send_ts(ts, rs);
 		} else {
 			if (output_format & FIO_OUTPUT_TERSE) @@ -1905,6 +1906,7 @@ void __show=
_run_stats(void)
 	}
 	if (!is_backend && (output_format & FIO_OUTPUT_JSON)) {
 		/* disk util stats, if any */
+		printf("should send DU\n");
 		show_disk_util(1, root, &output[__FIO_OUTPUT_JSON]);
=20
 		show_idle_prof_stats(FIO_OUTPUT_JSON, root, &output[__FIO_OUTPUT_JSON]);=
 @@ -1917,6 +1919,8 @@ void __show_run_stats(void)
 	for (i =3D 0; i < groupid + 1; i++) {
 		rs =3D &runstats[i];
=20
+		printf("should send GS\n");
+
 		rs->groupid =3D i;
 		if (is_backend)
 			fio_server_send_gs(rs);

--
Jens Axboe


