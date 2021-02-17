Return-Path: <fio-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:33343 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231611AbhBQJhz (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Feb 2021 04:37:55 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 2D8C02400FC
        for <fio@vger.kernel.org>; Wed, 17 Feb 2021 10:36:58 +0100 (CET)
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4DgXmT5F5Xz6tmb
        for <fio@vger.kernel.org>; Wed, 17 Feb 2021 10:36:57 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Feb 2021 10:36:57 +0100
From: graf wasili <graf.wasili@posteo.net>
Subject: Accounting for partially filled blocks when modeling workloads
Message-ID: <86429e07f639e08cd89497662cacbfc1@posteo.de>
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello everybody,

Before everything else I wanted to say thanks to Jens and everybody who 
has put their time in this great project :)

I recently started using fio for benchmarking hard disks and possible 
storage setups and also learn more about the workings of the layers 
involved and now ran into a question.
I'm sorry if I'm missing something here - my knowledge of the topic is 
certainly lacking...  However, any help is appreciated.

On an ext4 file system two files cannot share the same block - so 
reading or writing a lot of small files introduces a considerable 
overhead wrt the actual amount of data retrieved from disk.
I want to take this into account when modelling workloads with fio, but 
issuing a command like

> fio --name test --rw=randread --blocksize=4096 --size=1m --nrfiles=100 
> ---directory=path/on/ext4-formated/hard-disk/

will make fio read only 800KiB or 200 blocks. Each file occupies roughly 
2,5 blocks, so partially filled blocks occupied by each file are just 
ignored.


Looking into a possible solution i figured I could issue the parameter

> bssplit=2048:n, 4096:n-1

with

> n = 1 /  ceil[(file size) / (block size)]

to simulate the overhead for reads/writes of partially occupied blocks 
and get a meaningful throughput number for this kind of scenario 
(assuming that in reality, (file size) mod (block size) is uniformly 
distributed).


Does this make sense? Are there maybe better solutions?

Thanks
gw

