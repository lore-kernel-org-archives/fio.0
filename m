Return-Path: <axboe@kernel.dk>
Subject: Re: client/server mode fails with Assertion `client->eta_in_flight =
 eta' failed
References: <CABtFm2WPnKVVBVPU0N97ipX=RTAVK7Tz0nJUNtAmS9chLw3nHw@mail.gmail.com>
 <56C4D7D4.4020904@kernel.dk>
 <CABtFm2UabELu776EVnrwVUgrfeWcjkM=W1irhxF6L_o-QdTDLg@mail.gmail.com>
 <CANWz5fhXDTu=zKLtHuoecVWcMzvditqs6AqHK-Y-RfsJscJ=GA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <43640b9a-b49c-eee8-ef6a-66333a649930@kernel.dk>
Date: Tue, 13 Sep 2016 09:04:50 -0600
MIME-Version: 1.0
In-Reply-To: <CANWz5fhXDTu=zKLtHuoecVWcMzvditqs6AqHK-Y-RfsJscJ=GA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Chris Worley <worleys@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/30/2016 09:28 AM, Chris Worley wrote:
> Was there ever a solution?  I'm seeing this a lot on v2.9.

Chris/Srinivasa, can you try the below patch? Looks like we're racing
sometimes on the ETA command. And if we don't find a reply tag, we
already decremented the ETA count, so we should just ignore it.

diff --git a/client.c b/client.c
index 3456665009b8..c8069a0159ac 100644
--- a/client.c
+++ b/client.c
@@ -1183,7 +1183,7 @@ void fio_client_sum_jobs_eta(struct jobs_eta *dst, 
struct jobs_eta *je)
  	strcpy((char *) dst->run_str, (char *) je->run_str);
  }

-static void remove_reply_cmd(struct fio_client *client, struct 
fio_net_cmd *cmd)
+static bool remove_reply_cmd(struct fio_client *client, struct 
fio_net_cmd *cmd)
  {
  	struct fio_net_cmd_reply *reply = NULL;
  	struct flist_head *entry;
@@ -1199,12 +1199,13 @@ static void remove_reply_cmd(struct fio_client 
*client, struct fio_net_cmd *cmd)

  	if (!reply) {
  		log_err("fio: client: unable to find matching tag (%llx)\n", 
(unsigned long long) cmd->tag);
-		return;
+		return false;
  	}

  	flist_del(&reply->list);
  	cmd->tag = reply->saved_tag;
  	free(reply);
+	return true;
  }

  int fio_client_wait_for_reply(struct fio_client *client, uint64_t tag)
@@ -1653,7 +1654,8 @@ int fio_handle_client(struct fio_client *client)
  	case FIO_NET_CMD_ETA: {
  		struct jobs_eta *je = (struct jobs_eta *) cmd->payload;

-		remove_reply_cmd(client, cmd);
+		if (!remove_reply_cmd(client, cmd))
+			break;
  		convert_jobs_eta(je);
  		handle_eta(client, cmd);
  		break;

-- 
Jens Axboe


