Return-Path: <axboe@kernel.dk>
Subject: Re: fio server/client disconnect bug
References: <BN3PR0401MB1457692506FCB2E385AE2A2E8FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <SN6PR04MB4064CEF242E2091737402D268FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <47cd0e78-d881-a776-7f2d-c292b35e8211@kernel.dk>
 <5d0275d2-889e-314e-63bd-240d326beb47@kernel.dk>
 <33d87376-bbd9-69d9-83e0-120d93bd843d@kernel.dk>
 <SN6PR04MB4064961E38329062931640B68FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7ea6910f-dc7b-d141-432e-62c2ee9f16ee@kernel.dk>
Date: Wed, 21 Mar 2018 10:38:51 -0600
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB4064961E38329062931640B68FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/21/18 10:35 AM, Jeff Furlong wrote:
> No client ends in error.  In fact, I get a full set of iops/lat/bw logs from both clients.  And inspection of those logs looks good; I see the last 1000ms timestamp is valid for the duration of runtime.  But only one client prints the summary info to the output file.

Can you try with this debug patch and see if you can reproduce? Comparing
a good and bad run would likely be key in figuring out wtf is going on
here.

diff --git a/client.c b/client.c
index bff0adc0d972..76c89a496964 100644
--- a/client.c
+++ b/client.c
@@ -1664,7 +1664,7 @@ int fio_handle_client(struct fio_client *client)
 	if (!cmd)
 		return 0;
 
-	dprint(FD_NET, "client: got cmd op %s from %s (pdu=%u)\n",
+	printf("client: got cmd op %s from %s (pdu=%u)\n",
 		fio_server_op(cmd->opcode), client->hostname, cmd->pdu_len);
 
 	client->last_cmd = cmd->opcode;

-- 
Jens Axboe


