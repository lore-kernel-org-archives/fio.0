Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39033 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847Ab2KNRyN (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Nov 2012 12:54:13 -0500
Message-ID: <50A3DABD.3020807@kernel.dk>
Date: Wed, 14 Nov 2012 10:54:05 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: All clients impatient
References: <201211132323.qADNNb1I29385361@zion.americas.sgi.com> <50A3D823.4050707@kernel.dk>
In-Reply-To: <50A3D823.4050707@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Scott Emery <emery@sgi.com>
Cc: fio@vger.kernel.org

On 2012-11-14 10:42, Jens Axboe wrote:
>> 	For a while it was totting things up after four clients,
>> which kind of made sense... now it's stuck on three.  Back when
>> it made more sense I thought that maybe handle_ts only dealt with
>> the information from a single thread for each client rather than
>> the aggregate of multiple thread jobs.  That part seems to hold
>> true even when it doesn't have the info for all the clients.
>>
>> 	Is this reporting the aggregate as expected?
>> 	Is there a parameter change that I need to make to get
>> the output I expect?
> 
> As the job file is written, it will not aggregate results from a single
> "instance" of the server. You would want group_reporting=1 to do that.
> However, that will still give you one set of outputs per connection, not
> one for all of them. Right now fio does not support collecting outputs
> from all connections, a higher level group reporting if you will.

Actually, I misremembered that and didn't check before replying. It
_will_ sum all clients, if it has more than one connection. But there's
a bug where we race on client exit and dec the expected client count.
Does it work better with the below patch?


diff --git a/client.c b/client.c
index bf09d7e..f82bc30 100644
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
@@ -921,7 +926,7 @@ static int handle_client(struct fio_client *client)
 		free(cmd);
 		break;
 	case FIO_NET_CMD_TS:
-		handle_ts(cmd);
+		handle_ts(client, cmd);
 		free(cmd);
 		break;
 	case FIO_NET_CMD_GS:
@@ -1054,6 +1059,9 @@ int fio_handle_clients(void)
 	pfds = malloc(nr_clients * sizeof(struct pollfd));
 
 	sum_stat_clients = nr_clients;
+	if (sum_stat_clients > 1)
+		do_output_all_clients = 1;
+
 	init_thread_stat(&client_ts);
 	init_group_run_stat(&client_gs);
 

-- 
Jens Axboe

