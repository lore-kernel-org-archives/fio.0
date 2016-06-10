Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:35480 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbcFJHRP convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 10 Jun 2016 03:17:15 -0400
Received: by mail-vk0-f53.google.com with SMTP id d127so86547773vkh.2
        for <fio@vger.kernel.org>; Fri, 10 Jun 2016 00:17:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457415455A5B0CEFB84447DF75F0@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457415455A5B0CEFB84447DF75F0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 10 Jun 2016 08:17:13 +0100
Message-ID: <CALjAwxhv8pCLJe0uT6PX1r7g4Mu=d8gA19VUFu0pUE9LkHTkrw@mail.gmail.com>
Subject: Re: fio signal 11
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 9 June 2016 at 22:58, Jeff Furlong <jeff.furlong@hgst.com> wrote:
>
> Using the latest version from git, I am getting a signal 11 error when running some workloads.  It may be that workloads fail when we wrap around the device capacity (e.g. runtime and time_based).  See below example parameters:
>
> # fio --name=test_job --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=100% --numjobs=1 --bs=1m --filename=/dev/nvme0n1 --group_reporting --write_bw_log=test_job --write_iops_log=test_job --write_lat_log=test_job --log_avg_msec=1000 --disable_lat=0 --disable_clat=0 --disable_slat=0 --runtime=1500s --time_based --ramp_time=5s --output=test_job
>
> fio-2.11-17-ga275
> Starting 1 process
> fio: pid=145763, got signal=11

Could you run fio under gdb (
gdb ./fio
run --name=test_job --ioengine=libaio etc.
)

and when it crashes get a backtrace with
thread apply all bt
?

-- 
Sitsofe | http://sucs.org/~sits/
