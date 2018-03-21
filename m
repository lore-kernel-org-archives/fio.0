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
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4f5b0878-83fc-a224-e6b0-06896cd2155b@kernel.dk>
Date: Wed, 21 Mar 2018 11:12:14 -0600
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB4064FBCCCA9542C6550E99668FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/21/18 10:58 AM, Jeff Furlong wrote:
> Patch applied to latest git.  Failed after 26 iterations.  The host1 did not print output to the summary file.
> 
> client: got cmd op PROBE from host2 (pdu=112)
> client: got cmd op PROBE from host1 (pdu=112)
> client: got cmd op START from host2 (pdu=8)
> client: got cmd op START from host1 (pdu=8)
> client: got cmd op ADD_JOB from host2 (pdu=23204)
> client: got cmd op TEXT from host2 (pdu=70)
> client: got cmd op TEXT from host2 (pdu=90)
> client: got cmd op TEXT from host2 (pdu=51)
> client: got cmd op ADD_JOB from host1 (pdu=23204)
> client: got cmd op START from host2 (pdu=8)
> client: got cmd op TEXT from host1 (pdu=70)
> client: got cmd op TEXT from host1 (pdu=90)
> client: got cmd op TEXT from host1 (pdu=51)
> client: got cmd op START from host1 (pdu=8)
> client: got cmd op TEXT from host2 (pdu=33)
> client: got cmd op TEXT from host2 (pdu=33)
> client: got cmd op TEXT from host2 (pdu=25)
> client: got cmd op TEXT from host1 (pdu=33)
> client: got cmd op TEXT from host1 (pdu=33)
> client: got cmd op TEXT from host1 (pdu=25)
> client: got cmd op SERVER_START from host2 (pdu=0)
> client: got cmd op SERVER_START from host1 (pdu=0)
> client: got cmd op ETA from host2 (pdu=165)
> client: got cmd op ETA from host1 (pdu=165)
> client: got cmd op ETA from host2 (pdu=165)
> client: got cmd op ETA from host1 (pdu=165)
> client: got cmd op ETA from host2 (pdu=165)
> client: got cmd op ETA from host1 (pdu=165)
> client: got cmd op ETA from host2 (pdu=165)=41.6k,w=0 IOPS][eta 00m:02s]
> client: got cmd op ETA from host1 (pdu=165)
> client: got cmd op ETA from host2 (pdu=165)=41.6k,w=0 IOPS][eta 00m:01s]
> client: got cmd op ETA from host1 (pdu=165)
> client: got cmd op IOLOG from host2 (pdu=338)41.6k,w=0 IOPS][eta 00m:00s]
> client: got cmd op IOLOG from host2 (pdu=327)
> client: got cmd op IOLOG from host2 (pdu=338)
> client: got cmd op IOLOG from host1 (pdu=337)
> client: got cmd op IOLOG from host1 (pdu=328)
> client: got cmd op IOLOG from host1 (pdu=336)
> client: got cmd op IOLOG from host2 (pdu=330)
> client: got cmd op IOLOG from host2 (pdu=327)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op JOB_OPT from host2 (pdu=200)
> client: got cmd op TS from host2 (pdu=94888)
> client: got cmd op GS from host2 (pdu=164)
> client: got cmd op IOLOG from host1 (pdu=324)
> client: got cmd op DISK_UTIL from host2 (pdu=256)
> client: got cmd op IOLOG from host1 (pdu=320)
> client: got cmd op TEXT from host2 (pdu=25)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op STOP from host2 (pdu=8)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op QUIT from host2 (pdu=0)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op JOB_OPT from host1 (pdu=200)
> client: got cmd op STOP from host1 (pdu=8)
> client: got cmd op QUIT from host1 (pdu=0)

So this is weird, after the JOB_OPT it should have send the gs/ts and so
on summary. Which is what triggers the stat display. Can you remove the
previous patch, and add this debug patch with some more printf goodness
in it?


diff --git a/client.c b/client.c
index bff0adc0d972..0f740b5f3057 100644
--- a/client.c
+++ b/client.c
@@ -179,6 +179,8 @@ static struct fio_client *find_client_by_fd(int fd)
 
 void fio_put_client(struct fio_client *client)
 {
+	printf("client %s removed %d\n", client->hostname, client->refs);
+
 	if (--client->refs)
 		return;
 
@@ -1664,7 +1666,7 @@ int fio_handle_client(struct fio_client *client)
 	if (!cmd)
 		return 0;
 
-	dprint(FD_NET, "client: got cmd op %s from %s (pdu=%u)\n",
+	printf("client: got cmd op %s from %s (pdu=%u)\n",
 		fio_server_op(cmd->opcode), client->hostname, cmd->pdu_len);
 
 	client->last_cmd = cmd->opcode;
diff --git a/stat.c b/stat.c
index 98ab63893900..c23a3c9ddabc 100644
--- a/stat.c
+++ b/stat.c
@@ -1882,6 +1882,8 @@ void __show_run_stats(void)
 		json_object_add_value_array(root, "jobs", array);
 	}
 
+	printf("back=%d, groupid=%d, nr_ts=%d\n", is_backend, groupid, nr_ts);
+
 	if (is_backend)
 		fio_server_send_job_options(&get_global_options()->opt_list, -1U);
 

-- 
Jens Axboe


