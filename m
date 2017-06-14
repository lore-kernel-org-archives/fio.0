Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:35451 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752154AbdFNGNz (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Jun 2017 02:13:55 -0400
Received: by mail-ua0-f179.google.com with SMTP id q15so88601408uaa.2
        for <fio@vger.kernel.org>; Tue, 13 Jun 2017 23:13:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14572E293EAA4723BE2750058FC90@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457EFC8350E7DAB393315B28FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxjKwFty9C42YcBkb7NStRMZrKRPKda5_gFejd358mCi_g@mail.gmail.com> <BN3PR0401MB14572E293EAA4723BE2750058FC90@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 14 Jun 2017 07:13:23 +0100
Message-ID: <CALjAwxjxvwMDn722Zg10VjNVd5t+6GcE1UOi9ams4Lh-UV9WzQ@mail.gmail.com>
Subject: Re: fio server errors
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 8 June 2017 at 22:53, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> Using fio 2.19 I can reproduce the SEND_ETA issue.  With debug=all, indeed there is a ton of output, but it finishes with roughly:
>
> <server1> diskutil 30748 update io ticks
> <server1> diskutil 30748 open stat file: /sys/block/nvme0n1/stat
> <server1> diskutil 30748 /sys/block/nvme0n1/stat: 1299576802        0 54165895270 1333065028 863486453        0 63615892884 3819260095        0 57718711 859646548
> <server1> diskutil 30748 /sys/block/nvme0n1/stat: stat read ok? 0
> <server1> helperthread 30748 since_ss: 0, next_ss: 1000, next_log: 250, msec_to_next_event: 250
> <server1> diskutil 30748 update io ticks
> <server1> diskutil 30748 open stat file: /sys/block/nvme0n1/stat
> <server1> diskutil 30748 /sys/block/nvme0n1/stat: 1299576802        0 54165895270 1333065028 863486453        0 63615892884 3819260095        0 57718711 859646548
> <server1> diskutil 30748 /sys/block/nvme0n1/stat: stat read ok? 0
> <server1> helperthread 30748 since_ss: 0, next_ss: 1000, next_log: 250, msec_to_next_event: 250
> <server1> fio: pid=30750, got signal=11
> <server1> process  30748 pid=30750: runstate RUNNING -> REAPED
> <server1> process  30748 terminate group_id=-1
> <server1> process  30748 setting terminate on test_job/30750
> <server1> diskutil 30748 update io ticks
> <server1> diskutil 30748 open stat file: /sys/block/nvme0n1/stat
> <server1> diskutil 30748 /sys/block/nvme0n1/stat: 1299576802        0 54165895270 1333065028 863486453        0 63615892884 3819260095        0 57718711 859646548
> <server1> diskutil 30748 /sys/block/nvme0n1/stat: stat read ok? 0
> <server1> helperthread 30748 since_ss: 0, next_ss: 1000, next_log: 500, msec_to_next_event: 157
> <server1> process  30748 pid=30750: runstate REAPED -> FINISHING
> <server1> process  30748 pid=30750: runstate FINISHING -> REAPED
> <server1> net      30748 server sending end stats
> <server1> net      30748 ts->ss_state = 0
> <server1> net      30748 server sending group run stats
> <server1> net      30748 server: sending disk_util 1
> <server1>
> <server1> parse    30748 free options
> <server1> parse    30748 free options
> <server1> net      30707 pid 30748 exited, sig=0, exitval=0
> <server1> net      30707 server: sending stop (0, 0)
> <server1> net      30707 server: sending quit
> <server1> net      30707 server: got op [SEND_ETA], pdu=0, tag=dceae0
> <server1> net      30707 server sending status
> <server1> net      30707 server: got op [SEND_ETA], pdu=0, tag=dcea50
> <server1> net      30707 server sending status
> <server1> net      30707 server: got op [SEND_ETA], pdu=0, tag=dcea50
> <server1> net      30707 server sending status
> <server1> net      30707 server: got op [SEND_ETA], pdu=0, tag=dceae0
> <server1> net      30707 server sending status
> <server1> net      30707 server: got op [SEND_ETA], pdu=0, tag=dceae0
> <server1> net      30707 server sending status
> <server1> net      30707 server: got op [SEND_ETA], pdu=0, tag=dceae0
> <server1> net      30707 server sending status
> <server1> net      30707 server: got op [SEND_ETA], pdu=0, tag=dcea50
> <server1> net      30707 server sending status
> parse    30706 free options

OK so it's not a newly introduced issue. This looks like the client is
continuing to send SEND_ETA messages even though the server has sent
back a "I've quit" message...

If you whittle the job file as much as possible (e.g. no
write_lat_log, smaller iodepth etc) do the symptoms change? What's the
smallest job file that still reproduces this problem?

-- 
Sitsofe | http://sucs.org/~sits/
