Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] client: support --status-interval option in client/server
 mode
References: <1533486614-14022-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <76eb1638-67de-d87f-2c50-d9c3f36782d3@kernel.dk>
Date: Sun, 5 Aug 2018 15:12:25 -0600
MIME-Version: 1.0
In-Reply-To: <1533486614-14022-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/5/18 10:30 AM, Tomohiro Kusumi wrote:
> This fixes "FIO client/server periodic stats" for non JSON output
> (the reporter is using JSON output).
> https://www.spinics.net/lists/fio/msg07204.html
> 
> Mark -L/--status-interval option with FIO_CLIENT_FLAG, so that the
> command line string is sent to the server side.
> 
> The client can now control the server to periodically show status,
> and each status is sent to the client via fio_server_text_output()
> (FIO_NET_CMD_TEXT socket event) in log_info_buf().

Applied, thanks,

-- 
Jens Axboe


