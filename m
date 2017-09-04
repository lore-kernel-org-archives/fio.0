Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35034 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753359AbdIDJ3Y (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Sep 2017 05:29:24 -0400
Received: by mail-wm0-f52.google.com with SMTP id v2so1312246wmf.0
        for <fio@vger.kernel.org>; Mon, 04 Sep 2017 02:29:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOfm_=VLQ0cVZPwDHtnzNO1Hj395z+2rq4AQvzhCyT9j75EqWw@mail.gmail.com>
References: <CAOfm_=VLQ0cVZPwDHtnzNO1Hj395z+2rq4AQvzhCyT9j75EqWw@mail.gmail.com>
From: Udi-Yehuda Tamar <udi@excelero.com>
Date: Mon, 4 Sep 2017 12:29:22 +0300
Message-ID: <CAOfm_=WPcxuUQyV1HSBkE07vJhtKfseQiZ2JEG81bVpYV7GENw@mail.gmail.com>
Subject: Fwd: Corrupted json file
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello guys,

we're using the latest stable 2.99GA FIO for our product testing ,
when trying to setup fio to write on ext4 mount we got a line that
failing our code to load the json file .
mt exe cmd:

fio --verify=md5 --randrepeat 0 --direct=1 --rw write --thread=32
 --exitall_on_error=1 --directory /mnt/v1 --verify_interval=4096
--buffered 0 --output-format=json --size 1M --iodepth 1 --name FioJob
--rwmixread 100 --verify_dump=1 --norandommap --verify_fatal=1
--output /var/opt/executions/None/FioFS_f12f9c_1504448587_None.log
--runtime 0 --fill_fs 0 --do_verify=1 --numjobs 20 --blocksize 4K
--verify_pattern=0xaa --time_based=0 --ioengine libaio


output file:

Multiple writers may overwrite blocks that belong to other jobs. This
can cause verification failures.
{
  "fio version" : "fio-2.99-40-ga94a",
  "timestamp" : 1504449007,
  "timestamp_ms" : 1504449007643,
  "time" : "Sun Sep  3 17:30:07 2017",
  "global options" : {
    "verify" : "md5",
    "randrepeat" : "0",
    "direct" : "1",
    "rw" : "write",
    "thread" : "32"..........
}

I understated the message, but how can I avoid this line in the json output?
it's breaking the json format


-- 
Thanks,
Udi-Yehuda Tamar.
