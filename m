Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:32770 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbbEMOXk (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 May 2015 10:23:40 -0400
Received: by oica37 with SMTP id a37so32339753oic.0
        for <fio@vger.kernel.org>; Wed, 13 May 2015 07:23:39 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 13 May 2015 11:23:39 -0300
Message-ID: <CAD09ZYSOkoXdHmYPfiF+pQReU1U+UHKfPL=52p818wikTtJDEw@mail.gmail.com>
Subject: --thinktime seems not work
From: Rodrigo Ribeiro Gomes <rodrigorigomes@gmail.com>
Content-Type: text/plain; charset=UTF-8
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

-- 

[]'s Rodrigo Ribeiro Gomes
MCITP: Database Administrator 2008
MCITP: Database Developer 2008

061 8106-2710
(Acesse o blog THE SQL TIMES | http://www.thesqltimes.com)
