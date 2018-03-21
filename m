Return-Path: <axboe@kernel.dk>
Subject: Re: fio server/client disconnect bug
From: Jens Axboe <axboe@kernel.dk>
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
Message-ID: <027c68c5-549d-8b4e-f606-84f8b321eb04@kernel.dk>
Date: Wed, 21 Mar 2018 13:03:48 -0600
MIME-Version: 1.0
In-Reply-To: <590553ff-0e9c-b679-1bcc-be9ae3a840ef@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Shoot, I think I see what it is. Some commands we punt to out-of-line
sending, others we do inline. STOP/QUIT are inline, whereas the ts/gs/du
are not. So we could potentially have a situation where we queue up the
ts/gs/du, but then process the STOP/QUIT first. If we do that, then we
don't get any output...

Let me think about this for a bit, and see what I can come up with.

-- 
Jens Axboe


