Return-Path: <axboe@kernel.dk>
Subject: Re: fio server/client disconnect bug
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
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <590553ff-0e9c-b679-1bcc-be9ae3a840ef@kernel.dk>
Date: Wed, 21 Mar 2018 12:38:46 -0600
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB40649D252EA6B8B0E16BE8E18FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/21/18 12:16 PM, Jeff Furlong wrote:
> Here's the failing case where host1 does not print:
> 
> back=1, groupid=0, nr_ts=1
> client: got cmd op PROBE from host2 (pdu=112)
> client host2 removed 2
> client: got cmd op PROBE from host1 (pdu=112)
> client host1 removed 2
> client: got cmd op START from host2 (pdu=8)
> client host2 removed 2
> client: got cmd op START from host1 (pdu=8)
> client host1 removed 2
> client: got cmd op ADD_JOB from host2 (pdu=23204)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=70)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=90)
> client host2 removed 2
> client: got cmd op ADD_JOB from host1 (pdu=23204)
> client host1 removed 2
> client: got cmd op TEXT from host2 (pdu=51)
> client host2 removed 2
> client: got cmd op TEXT from host1 (pdu=70)
> client host1 removed 2
> client: got cmd op START from host2 (pdu=8)
> client host2 removed 2
> client: got cmd op TEXT from host1 (pdu=90)
> client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=51)
> client host1 removed 2
> client: got cmd op START from host1 (pdu=8)
> client host1 removed 2
> client: got cmd op TEXT from host2 (pdu=33)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=33)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=25)
> client host2 removed 2
> client: got cmd op TEXT from host1 (pdu=33)
> client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=33)
> client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=25)
> client host1 removed 2
> client: got cmd op SERVER_START from host2 (pdu=0)
> client host2 removed 2
> client: got cmd op SERVER_START from host1 (pdu=0)
> client host1 removed 2
> client: got cmd op ETA from host2 (pdu=165)
> client host2 removed 2
> client: got cmd op ETA from host1 (pdu=165)
> client host1 removed 2
> client: got cmd op ETA from host2 (pdu=165)
> client host2 removed 2
> client: got cmd op ETA from host1 (pdu=165)
> client host1 removed 2
> client: got cmd op ETA from host2 (pdu=165)
> client host2 removed 2
> client: got cmd op ETA from host1 (pdu=165)
> client host1 removed 25.0%][r=2667M,w=0k][r=41.7k,w=0 IOPS][eta 00m:02s]
> client: got cmd op ETA from host2 (pdu=165)
> client host2 removed 2
> client: got cmd op ETA from host1 (pdu=165)
> client host1 removed 28.9%][r=2661M,w=0k][r=41.6k,w=0 IOPS][eta 00m:01s]
> client: got cmd op ETA from host2 (pdu=165)
> client host2 removed 2
> client: got cmd op ETA from host1 (pdu=165)
> client host1 removed 200.0%][r=2669M,w=0k][r=41.7k,w=0 IOPS][eta 00m:00s]
> client: got cmd op IOLOG from host2 (pdu=338)
> client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=327)
> client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=337)
> client host2 removed 2
> client: got cmd op IOLOG from host1 (pdu=338)
> client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=325)
> client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=337)
> client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=323)
> client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=320)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op STOP from host1 (pdu=8)
> client host1 removed 2
> client: got cmd op QUIT from host1 (pdu=0)
> client host1 removed 2
> client host1 removed 1
> client: got cmd op IOLOG from host2 (pdu=331)
> client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=327)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op TS from host2 (pdu=94888)
> client host2 removed 2
> client: got cmd op GS from host2 (pdu=164)
> client host2 removed 2
> client: got cmd op DISK_UTIL from host2 (pdu=256)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=25)
> client host2 removed 2
> client: got cmd op STOP from host2 (pdu=8)
> client host2 removed 2
> client: got cmd op QUIT from host2 (pdu=0)
> client host2 removed 2
> client host2 removed 1
> 
> And here's a good case:
> 
> client: got cmd op PROBE from host2 (pdu=112)
> client host2 removed 2
> client: got cmd op PROBE from host1 (pdu=112)
> client host1 removed 2
> client: got cmd op START from host2 (pdu=8)
> client host2 removed 2
> client: got cmd op START from host1 (pdu=8)
> client host1 removed 2
> client: got cmd op ADD_JOB from host2 (pdu=23204)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=70)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=90)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=51)
> client host2 removed 2
> client: got cmd op START from host2 (pdu=8)
> client host2 removed 2
> client: got cmd op ADD_JOB from host1 (pdu=23204)
> client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=70)
> client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=90)
> client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=51)
> client host1 removed 2
> client: got cmd op START from host1 (pdu=8)
> client host1 removed 2
> client: got cmd op TEXT from host2 (pdu=33)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=33)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=25)
> client host2 removed 2
> client: got cmd op SERVER_START from host2 (pdu=0)
> client host2 removed 2
> client: got cmd op TEXT from host1 (pdu=33)
> client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=33)
> client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=25)
> client host1 removed 2
> client: got cmd op SERVER_START from host1 (pdu=0)
> client host1 removed 2
> client: got cmd op ETA from host2 (pdu=165)
> client host2 removed 2
> client: got cmd op ETA from host1 (pdu=165)
> client host1 removed 2
> client: got cmd op ETA from host2 (pdu=165)
> client host2 removed 2
> client: got cmd op ETA from host1 (pdu=165)
> client host1 removed 2
> client: got cmd op ETA from host2 (pdu=165)
> client host2 removed 2
> client: got cmd op ETA from host1 (pdu=165)
> client host1 removed 25.0%][r=2667M,w=0k][r=41.7k,w=0 IOPS][eta 00m:02s]
> client: got cmd op ETA from host2 (pdu=165)
> client host2 removed 2
> client: got cmd op ETA from host1 (pdu=165)
> client host1 removed 28.9%][r=2669M,w=0k][r=41.7k,w=0 IOPS][eta 00m:01s]
> client: got cmd op ETA from host2 (pdu=165)
> client host2 removed 2
> client: got cmd op ETA from host1 (pdu=165)
> client host1 removed 200.0%][r=2675M,w=0k][r=41.8k,w=0 IOPS][eta 00m:00s]
> client: got cmd op IOLOG from host2 (pdu=336)
> client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=327)
> client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=337)
> client host2 removed 2
> client: got cmd op IOLOG from host1 (pdu=338)
> client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=327)
> client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=338)
> client host1 removed 2
> client: got cmd op IOLOG from host2 (pdu=330)
> client host2 removed 2
> client: got cmd op IOLOG from host2 (pdu=327)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client host2 removed 2
> client: got cmd op TS from host2 (pdu=94888)
> client host2 removed 2
> client: got cmd op GS from host2 (pdu=164)
> client host2 removed 2
> client: got cmd op DISK_UTIL from host2 (pdu=256)
> client host2 removed 2
> client: got cmd op TEXT from host2 (pdu=25)
> client host2 removed 2
> client: got cmd op STOP from host2 (pdu=8)
> client host2 removed 2
> client: got cmd op QUIT from host2 (pdu=0)
> client host2 removed 2
> client host2 removed 1
> client: got cmd op IOLOG from host1 (pdu=330)
> client host1 removed 2
> client: got cmd op IOLOG from host1 (pdu=327)
> back=1, groupid=0, nr_ts=1
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client host1 removed 2
> client: got cmd op TS from host1 (pdu=94888)
> client host1 removed 2
> client: got cmd op GS from host1 (pdu=164)
> client host1 removed 2
> client: got cmd op DISK_UTIL from host1 (pdu=256)
> client host1 removed 2
> client: got cmd op TEXT from host1 (pdu=25)
> client host1 removed 2
> client: got cmd op STOP from host1 (pdu=8)
> client host1 removed 2
> client: got cmd op QUIT from host1 (pdu=0)
> client host1 removed 2
> client host1 removed 1

So puzzling... It prints all the right things, but for some reason we
are not doing the ts/gs/disk_util send for the host in some cases.
For the life of me, I can't see how that would happen! We just go
straight from the job option sends, and then don't do the rest in
__show_run_stats().

And thanks for the quick turn-around on the debugging, it's key
to getting this resolved since I can't reproduce this myself. Can you
run with this one? Backout the previous one first.


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
diff --git a/server.c b/server.c
index 65d4484edae5..e78f6f64824d 100644
--- a/server.c
+++ b/server.c
@@ -551,6 +551,8 @@ static void fio_net_queue_entry(struct sk_entry *entry)
 {
 	struct sk_out *sk_out = pthread_getspecific(sk_out_key);
 
+	printf("queue cmd op=%x, sock=%d\n", entry->opcode, sk_out->sk);
+
 	if (entry->flags & SK_F_INLINE)
 		handle_sk_entry(sk_out, entry);
 	else {
@@ -1177,6 +1179,7 @@ static int handle_xmits(struct sk_out *sk_out)
 	while (!flist_empty(&list)) {
 		entry = flist_entry(list.next, struct sk_entry, list);
 		flist_del(&entry->list);
+		printf("xmit op %x\n", entry->opcode);
 		ret += handle_sk_entry(sk_out, entry);
 	}
 
diff --git a/stat.c b/stat.c
index 98ab63893900..558786f52751 100644
--- a/stat.c
+++ b/stat.c
@@ -1891,6 +1891,7 @@ void __show_run_stats(void)
 
 		if (is_backend) {
 			fio_server_send_job_options(opt_lists[i], i);
+			printf("should send TS\n");
 			fio_server_send_ts(ts, rs);
 		} else {
 			if (output_format & FIO_OUTPUT_TERSE)
@@ -1905,6 +1906,7 @@ void __show_run_stats(void)
 	}
 	if (!is_backend && (output_format & FIO_OUTPUT_JSON)) {
 		/* disk util stats, if any */
+		printf("should send DU\n");
 		show_disk_util(1, root, &output[__FIO_OUTPUT_JSON]);
 
 		show_idle_prof_stats(FIO_OUTPUT_JSON, root, &output[__FIO_OUTPUT_JSON]);
@@ -1917,6 +1919,8 @@ void __show_run_stats(void)
 	for (i = 0; i < groupid + 1; i++) {
 		rs = &runstats[i];
 
+		printf("should send GS\n");
+
 		rs->groupid = i;
 		if (is_backend)
 			fio_server_send_gs(rs);

-- 
Jens Axboe


