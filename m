Return-Path: <lsgunthorpe@gmail.com>
Return-Path: <lsgunthorpe@gmail.com>
Date: Sat, 17 Mar 2018 11:57:43 -0600
Subject: Re: FIO's rdma engine...
Message-ID: <1ki9i1iq876vpc8n312a4fog.1521308394157@email.lge.com>
From: "lsgunthorpe@gmail.com" <lsgunthorpe@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
	boundary="--_com.lge.email_31756968324843847"
To: Sitsofe Wheeler <sitsofe@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Kip Ingram <kip.ingram@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Stephen Bates <sbates@raithlin.com>
List-ID: <fio@vger.kernel.org>

----_com.lge.email_31756968324843847
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

    Hi Kip,
The RDMA engine in FIO was designed to measure the performance of RDMA links similar to the perftest tool set. 
It does not test a block device at all. If I remember correctly 'rw' specifies whether the instance running is a client or server and the 'verb' attribute specifies whether you are reading, writing, sending or recving. 'size' is required to specify the length of the test.
So it doesn't sound like it's what you are looking for. I'd suggest setting up an NVMEof[1] target and initiator then run fio normally on the initiator.
Logan
[1] https://community.mellanox.com/docs/DOC-2504?forceNoRedirect=true
Dictated, not read.
------ Original message------From: Sitsofe WheelerDate: Sat, Mar 17, 2018 02:48To: Jens Axboe;Cc: Kip Ingram;fio@vger.kernel.org;Stephen Bates;logang@deltatee.com;Subject:Re: FIO's rdma engine...
On 23 January 2018 at 17:50, Jens Axboe  wrote:> On 1/23/18 10:48 AM, Kip Ingram wrote:>> Hi Jens.  I'm trying to do some NVME over IB testing, and it seemed>> appropriate to use the rdma engine in FIO.  However, it's complaining>> in various ways:>>>> 1. It says I have to specify the device size.  That's not a>> show-stopper, but it surprised me.>> 2. It says I have to use either read or write traffic - not mixed.>> That is a problem.>> 3. It says I can't use random addressing.  That's also a problem.>>>> Colleagues have set up devices this way and used one of our internal>> tools to do mixed and random traffic.>>>> I don't see anything in the documents that imply mixed and random>> shouldn't work - is there something I'm overlooking?>> CC'ing the fio list, please direct questions there and not to me> directly.CC'ing some RDMA folks.-- Sitsofe | http://sucs.org/~sits/
----_com.lge.email_31756968324843847
Content-Type: text/html;
   charset=utf-8
Content-Transfer-Encoding: 8bit

<html><head>





</head>
<body style="margin-bottom:45px">
    <div style="font-size: 10pt;">    <div style="font-size: 10pt;" dir="ltr"><div dir="ltr" style="margin-top:0;margin-bottom:0;">Hi Kip,</div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><br></div><div dir="ltr" style="margin-top:0;margin-bottom:0;">The RDMA engine in FIO was designed to measure the performance of RDMA links similar to the perftest tool set.&nbsp;</div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><br></div><div dir="ltr" style="margin-top:0;margin-bottom:0;">It does not test a block device at all. If I remember correctly 'rw' specifies whether the instance running is a client or server and the 'verb' attribute specifies whether you are reading, writing, sending or recving. 'size' is required to specify the length of the test.</div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><br></div><div dir="ltr" style="margin-top:0;margin-bottom:0;">So it doesn't sound like it's what you are looking for. I'd suggest setting up an NVMEof[1] target and initiator then run fio normally on the initiator.</div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><br></div><div dir="ltr" style="margin-top:0;margin-bottom:0;">Logan</div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><br></div><div dir="ltr" style="margin-top:0;margin-bottom:0;">[1]&nbsp;<a href="https://community.mellanox.com/docs/DOC-2504?forceNoRedirect=true">https://community.mellanox.com/docs/DOC-2504?forceNoRedirect=true</a></div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><br></div><div id="SignatureBox" dir="ltr" style="margin-top:0;margin-bottom:0;"><div dir="ltr" style="margin-top:0;margin-bottom:0;font-size:9pt;font-style:italic;">Dictated, not read.</div></div></div><div style="font-size: 10pt;" dir="ltr"><div id="LGEmailHeader" dir="ltr" style="margin-top:0;margin-bottom:0;"><div dir="ltr" style="margin-top:0;margin-bottom:0;"><br></div><div dir="ltr" style="margin-top:0;margin-bottom:0;">------ Original message------</div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><b>From: </b>Sitsofe Wheeler<sitsofe@gmail.com></sitsofe@gmail.com></div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><b>Date: </b>Sat, Mar 17, 2018 02:48</div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><b>To: </b>Jens Axboe;</div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><b>Cc: </b>Kip Ingram<a href="mailto:;fio@vger.kernel.org">;fio@vger.kernel.org</a>;Stephen Bates<a href="mailto:;logang@deltatee.com">;logang@deltatee.com</a>;</div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><b>Subject:</b>Re: FIO's rdma engine...</div><div dir="ltr" style="margin-top:0;margin-bottom:0;"><br></div></div><pre>On 23 January 2018 at 17:50, Jens Axboe <axboe@kernel.dk> wrote:&gt; On 1/23/18 10:48 AM, Kip Ingram wrote:&gt;&gt; Hi Jens.  I'm trying to do some NVME over IB testing, and it seemed&gt;&gt; appropriate to use the rdma engine in FIO.  However, it's complaining&gt;&gt; in various ways:&gt;&gt;&gt;&gt; 1. It says I have to specify the device size.  That's not a&gt;&gt; show-stopper, but it surprised me.&gt;&gt; 2. It says I have to use either read or write traffic - not mixed.&gt;&gt; That is a problem.&gt;&gt; 3. It says I can't use random addressing.  That's also a problem.&gt;&gt;&gt;&gt; Colleagues have set up devices this way and used one of our internal&gt;&gt; tools to do mixed and random traffic.&gt;&gt;&gt;&gt; I don't see anything in the documents that imply mixed and random&gt;&gt; shouldn't work - is there something I'm overlooking?&gt;&gt; CC'ing the fio list, please direct questions there and not to me&gt; <a href="http://directly.CC">directly.CC</a>'ing some RDMA folks.-- Sitsofe | <a href="http://sucs.org/~sits/">http://sucs.org/~sits/</a></axboe@kernel.dk></pre></div></div>


</body></html>
----_com.lge.email_31756968324843847--



