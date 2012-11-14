Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40956 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab2KNT6I (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Nov 2012 14:58:08 -0500
Message-ID: <50A3F7C8.4070103@kernel.dk>
Date: Wed, 14 Nov 2012 12:58:00 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: All clients impatient
References: <201211141929.qAEJTMtO29407865@zion.americas.sgi.com>
In-Reply-To: <201211141929.qAEJTMtO29407865@zion.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: emery@sgi.com
Cc: fio@vger.kernel.org

On 2012-11-14 12:29, emery@sgi.com wrote:
> emery@sgi.com:  emery@sgi.com
> In message <201211141909.qAEJ9HtO29431352@zion.americas.sgi.com>, emery@sgi.com
>  writes:
>> emery@sgi.com:  Jens Axboe <axboe@kernel.dk>
>> In message <50A3DE92.3020509@kernel.dk>, Jens Axboe writes:
>>> On 2012-11-14 10:54, Jens Axboe wrote:
>>>> On 2012-11-14 10:42, Jens Axboe wrote:
>>>>>> 	For a while it was totting things up after four clients,
>>>>>> which kind of made sense... now it's stuck on three.  Back when
>>>>>> it made more sense I thought that maybe handle_ts only dealt with
>>>>>> the information from a single thread for each client rather than
>>>>>> the aggregate of multiple thread jobs.  That part seems to hold
>>>>>> true even when it doesn't have the info for all the clients.
>>>>>>
>>>>>> 	Is this reporting the aggregate as expected?
>>>>>> 	Is there a parameter change that I need to make to get
>>>>>> the output I expect?
>>>>>
>>>>> As the job file is written, it will not aggregate results from a single
>>>>> "instance" of the server. You would want group_reporting=1 to do that.
>>>>> However, that will still give you one set of outputs per connection, not
>>>>> one for all of them. Right now fio does not support collecting outputs
>>>>> from all connections, a higher level group reporting if you will.
>>>>
>>>> Actually, I misremembered that and didn't check before replying. It
>>>> _will_ sum all clients, if it has more than one connection. But there's
>>>> a bug where we race on client exit and dec the expected client count.
>>>> Does it work better with the below patch?
>>>
>>> Note that you still need group_reporting=1 in your job file, the all
>>> clients report depend on getting only one set of stats from each client.
>>> I'll look into fixing that up, too.
>>>
>>> -- 
>>> Jens Axboe
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> 	Ah, I just sent an email to you noticing that... :-)
>>
>> Scott Emery
>> emery@sgi.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 	Works great when I add group_reporting.
> 
> [semery@lou2-mds2 multi2]$ egrep 'groupid|bw=' write_tape_2.out
> wt2: (groupid=1, jobs=2): err= 0: pid=3070: Wed Nov 14 11:26:17 2012
>   read : io=20480MB, bw=554641KB/s, iops=270 , runt= 37811msec
> wt2: (groupid=1, jobs=2): err= 0: pid=10638: Wed Nov 14 11:26:17 2012
>   read : io=20480MB, bw=556658KB/s, iops=271 , runt= 37674msec
> wt2: (groupid=1, jobs=2): err= 0: pid=26969: Wed Nov 14 11:26:17 2012
>   read : io=20480MB, bw=553703KB/s, iops=270 , runt= 37875msec
> wt2: (groupid=1, jobs=2): err= 0: pid=14154: Wed Nov 14 11:26:17 2012
>   read : io=20480MB, bw=553251KB/s, iops=270 , runt= 37906msec
> All clients: (groupid=1, jobs=4): err= 0: pid=0: Wed Nov 14 11:26:17 2012
>   read : io=85899MB, bw=2266.2MB/s, iops=1080 , runt= 37906msec

Should work without group_reporting as well with the below patch. Can
you confirm?

diff --git a/backend.c b/backend.c
index fd73eda..b80c903 100644
--- a/backend.c
+++ b/backend.c
@@ -62,6 +62,7 @@ struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 
 int groupid = 0;
 unsigned int thread_number = 0;
+unsigned int stat_number = 0;
 unsigned int nr_process = 0;
 unsigned int nr_thread = 0;
 int shm_id = 0;
diff --git a/client.c b/client.c
index bf09d7e..e02a33b 100644
--- a/client.c
+++ b/client.c
@@ -50,6 +50,7 @@ struct fio_client {
 	int error;
 	int ipv6;
 	int sent_job;
+	int did_stat;
 
 	struct flist_head eta_list;
 	struct client_eta *eta_in_flight;
@@ -83,6 +84,7 @@ static struct thread_stat client_ts;
 static struct group_run_stats client_gs;
 static int sum_stat_clients;
 static int sum_stat_nr;
+static int do_output_all_clients;
 
 #define FIO_CLIENT_HASH_BITS	7
 #define FIO_CLIENT_HASH_SZ	(1 << FIO_CLIENT_HASH_BITS)
@@ -159,9 +161,11 @@ static void remove_client(struct fio_client *client)
 	if (client->ini_file)
 		free(client->ini_file);
 
+	if (!client->did_stat)
+		sum_stat_clients--;
+
 	free(client);
 	nr_clients--;
-	sum_stat_clients--;
 }
 
 static void put_client(struct fio_client *client)
@@ -664,7 +668,7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 	dst->groupid	= le32_to_cpu(src->groupid);
 }
 
-static void handle_ts(struct fio_net_cmd *cmd)
+static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
 
@@ -672,8 +676,9 @@ static void handle_ts(struct fio_net_cmd *cmd)
 	convert_gs(&p->rs, &p->rs);
 
 	show_thread_status(&p->ts, &p->rs);
+	client->did_stat = 1;
 
-	if (sum_stat_clients == 1)
+	if (!do_output_all_clients)
 		return;
 
 	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr);
@@ -870,6 +875,11 @@ static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	client->state = Client_started;
 	client->jobs = le32_to_cpu(pdu->jobs);
+
+	if (sum_stat_clients > 1)
+		do_output_all_clients = 1;
+
+	sum_stat_clients += le32_to_cpu(pdu->stat_outputs);
 }
 
 static void handle_stop(struct fio_client *client, struct fio_net_cmd *cmd)
@@ -921,7 +931,7 @@ static int handle_client(struct fio_client *client)
 		free(cmd);
 		break;
 	case FIO_NET_CMD_TS:
-		handle_ts(cmd);
+		handle_ts(client, cmd);
 		free(cmd);
 		break;
 	case FIO_NET_CMD_GS:
@@ -1053,7 +1063,6 @@ int fio_handle_clients(void)
 
 	pfds = malloc(nr_clients * sizeof(struct pollfd));
 
-	sum_stat_clients = nr_clients;
 	init_thread_stat(&client_ts);
 	init_group_run_stat(&client_gs);
 
diff --git a/fio.h b/fio.h
index ca1a5f0..f69de0d 100644
--- a/fio.h
+++ b/fio.h
@@ -558,6 +558,7 @@ enum {
 
 extern int exitall_on_terminate;
 extern unsigned int thread_number;
+extern unsigned int stat_number;
 extern unsigned int nr_process, nr_thread;
 extern int shm_id;
 extern int groupid;
diff --git a/init.c b/init.c
index 23be863..a682423 100644
--- a/init.c
+++ b/init.c
@@ -317,6 +317,10 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent,
 	profile_add_hooks(td);
 
 	td->thread_number = thread_number;
+
+	if (!parent || !parent->o.group_reporting)
+		stat_number++;
+
 	return td;
 }
 
diff --git a/server.c b/server.c
index 72def7e..f8c3635 100644
--- a/server.c
+++ b/server.c
@@ -342,6 +342,7 @@ static int handle_job_cmd(struct fio_net_cmd *cmd)
 	}
 
 	spdu.jobs = cpu_to_le32(thread_number);
+	spdu.stat_outputs = cpu_to_le32(stat_number);
 	fio_net_send_cmd(server_fd, FIO_NET_CMD_START, &spdu, sizeof(spdu), 0);
 
 	ret = fio_backend();
diff --git a/server.h b/server.h
index 9bf8907..5b8c7ba 100644
--- a/server.h
+++ b/server.h
@@ -96,6 +96,7 @@ struct cmd_line_pdu {
 
 struct cmd_start_pdu {
 	uint32_t jobs;
+	uint32_t stat_outputs;
 };
 
 struct cmd_end_pdu {

-- 
Jens Axboe

