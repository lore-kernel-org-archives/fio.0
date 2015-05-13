Return-Path: <fio-owner@vger.kernel.org>
Received: from srv02.kosbit.com.br ([198.24.183.18]:33059 "EHLO
	srv02.kosbit.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665AbbEMOfw (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 May 2015 10:35:52 -0400
Date: Wed, 13 May 2015 14:29:34 +0000
Message-ID: <20150513142934.Horde.QxMWDkRsxjXrIDsUMjgLfg1@srv02.kosbit.com.br>
From: rodrigo@thesqltimes.com
Subject: --thinktime seems not work
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


HI guys!

I'm trying use the --thinktime parameter to sleep between each io
request for ten seconds.

But, it seems not working... I'm doing  something incorrect?

fio --name disktst  ... --thinktime 10000000

In HOWTO, this param is described as 'Stall the job x microseconds'...
But fio dont stop between each request and continues issuing. This is
complete command line that i used:


fio --name IoRequestDelayTest --directory J\:\  --iodepth 1 --bs 4k
--size 1G --io_size 1G --direct 1 --thread --runtime 1h --time_based
--rw randread --thinktime 10000000

The J: is mounted on a USB flash drive (Kingston SE9 32GB)

