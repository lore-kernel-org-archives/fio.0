Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34230 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbbCLO4H (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Mar 2015 10:56:07 -0400
Received: by oifu20 with SMTP id u20so3265846oif.1
        for <fio@vger.kernel.org>; Thu, 12 Mar 2015 07:56:07 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 Mar 2015 10:56:06 -0400
Message-ID: <CAE2pAdu25k80mkRii+9NTRFxnkcrf657-0HR_rAb9EJ2Gt9HKA@mail.gmail.com>
Subject: Network to Disk Throughput Testing
From: Ben Randall <ben.randall.2011@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello all,

Jens, first off, thank you for creating such an excellent tool.

I am interested in testing the network to disk performance on a
certain machine.  I know I can benchmark each interface individually,
but I'm specifically after how fast data can be read from one
interface and pushed to the other.

Is fio suitable for such a test?  I think it should be possible if I
can specify an endpoint on the target device, but specifying a
directory and filename to results in an error stating "fio: hostname
not valid for inbound network IO".  My conf file looks something like
this:

[global]
ioengine=net
port=[server-ip-port, 6000 in this case]
protocol=tcp
size=16g

[server] # device being written to
listen
filename=test.out
directory=${HOME}/target-disk-mounted-here
rw=read

[client] # device sending packets
rw=write
startdelay=1
hostname=[server-ip-address; 192.168.1.2 in this case]

Thank you for your time!

Best regards,
Ben
