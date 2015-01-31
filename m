Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55890 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbAaBZI convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 30 Jan 2015 20:25:08 -0500
Received: by mail-qa0-f42.google.com with SMTP id dc16so22502825qab.1
        for <fio@vger.kernel.org>; Fri, 30 Jan 2015 17:25:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54C98E9A.5010500@huawei.com>
References: <54C98E9A.5010500@huawei.com>
Date: Fri, 30 Jan 2015 17:25:07 -0800
Message-ID: <CAM8G_B+PTZzMCRi0b05mRdEuNooMg5LJ6VQYysFFLbrMjEFonA@mail.gmail.com>
Subject: Re: Help: FIO testing problem on arm64
From: "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "majun (F)" <majun258@huawei.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Since the intention of the script is to run serially, you dont need
both '&' and 'sleep',  you can remove '&' and let the fio command
block and remove sleep

>                                         fio --time_based --filename=/dev/$disk --rw=$rw --bs=$bs --ioengine=libaio --direct=1 --numjobs=$numjobs --iodepth=$iodepth --name=test --group_reporting --runtime=$runtime &> $logdir/${disk}_${bs}_${rw}_numjobs${numjobs}_iodepth${iodepth_2}.log
>                                 done
>                                 #sleep $runtime
