Return-Path: <axboe@kernel.dk>
Subject: Re: fio server/client disconnect bug
From: Jens Axboe <axboe@kernel.dk>
References: <BN3PR0401MB1457692506FCB2E385AE2A2E8FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <SN6PR04MB4064CEF242E2091737402D268FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <47cd0e78-d881-a776-7f2d-c292b35e8211@kernel.dk>
Message-ID: <5d0275d2-889e-314e-63bd-240d326beb47@kernel.dk>
Date: Wed, 21 Mar 2018 10:19:55 -0600
MIME-Version: 1.0
In-Reply-To: <47cd0e78-d881-a776-7f2d-c292b35e8211@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/21/18 9:19 AM, Jens Axboe wrote:
> On 3/20/18 6:16 PM, Jeff Furlong wrote:
>> Revisiting this issue.  It seems the call stack is:
>>
>> fio_handle_clients()
>>     fio_handle_client()
>>         case FIO_NET_CMD_TS:
>>             ops->thread_status(client, cmd);
>>             .thread_status    = handle_ts
>>                 static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
>>                 {
>>                     struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
>>                     struct flist_head *opt_list = NULL;
>>                     struct json_object *tsobj;
>>
>>                     if (client->opt_lists && p->ts.thread_number <= client->jobs)
>>                         opt_list = &client->opt_lists[p->ts.thread_number - 1];
>>
>>                     tsobj = show_thread_status(&p->ts, &p->rs, opt_list, NULL);
>>                     client->did_stat = true;
>>                     if (tsobj) {
>>                         json_object_add_client_info(tsobj, client);
>>                         json_array_add_value_object(clients_array, tsobj);
>>                     }
>>
>>                     if (sum_stat_clients <= 1)
>>                         return;
>>
>>                     sum_thread_stats(&client_ts, &p->ts, sum_stat_nr == 1);
>>                     sum_group_stats(&client_gs, &p->rs);
>>
>>                     client_ts.members++;
>>                     client_ts.thread_number = p->ts.thread_number;
>>                     client_ts.groupid = p->ts.groupid;
>>                     client_ts.unified_rw_rep = p->ts.unified_rw_rep;
>>                     client_ts.sig_figs = p->ts.sig_figs;
>>
>>                     if (++sum_stat_nr == sum_stat_clients) {
>>                         strcpy(client_ts.name, "All clients");
>>                         tsobj = show_thread_status(&client_ts, &client_gs, NULL, NULL);
>>                         if (tsobj) {
>>                             json_object_add_client_info(tsobj, client);
>>                             json_array_add_value_object(clients_array, tsobj);
>>                         }
>>                     }
>>                 }
>>
>> And when sum_stat_clients <= 1, we never print "All clients" summary.
>> Actually, we miss an entire client, so neither the individual client
>> summary is output nor the "all clients" summary is output.  It seems
>> one client finishes just slightly before the other but we remove from
>> the list of clients too quickly.  I tried adjusting the timeout and
>> such, but didn't completely remove the issue.  Any specific thoughts?
> 
> sum_stat_clients is set when we start everything up, so that should
> always be '2' for your case. So I'm a little puzzled as to what is going
> on here. Do any of the jobs ever end in error, and that's why we are
> missing a report from one of the jobs? Or are you referring to timing on
> receiving the stats output, somehow racing with each other and we're
> missing one of them? The latter could result in displaying just one
> output, and never getting ++sum_stat_nr == 2 and displaying the "All
> clients" output.

Does the below patch change anything for you? I forgot that we get
multiple starts (one from each client, of course), which means that we
really should protect the inc from there.

diff --git a/client.c b/client.c
index bff0adc0d972..fb1d1eb233d8 100644
--- a/client.c
+++ b/client.c
@@ -198,7 +198,7 @@ void fio_put_client(struct fio_client *client)
 		free(client->opt_lists);
 
 	if (!client->did_stat)
-		sum_stat_clients--;
+		__sync_fetch_and_sub(&sum_stat_clients, 1);
 
 	if (client->error)
 		error_clients++;
@@ -1440,7 +1440,7 @@ static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd)
 			INIT_FLIST_HEAD(&client->opt_lists[i]);
 	}
 
-	sum_stat_clients += client->nr_stat;
+	__sync_fetch_and_add(&sum_stat_clients, client->nr_stat);
 }
 
 static void handle_stop(struct fio_client *client, struct fio_net_cmd *cmd)

-- 
Jens Axboe


