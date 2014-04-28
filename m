Return-Path: <fio-owner@vger.kernel.org>
Received: from wdmail02.wdc.com ([129.253.55.42]:4137 "EHLO wdmail02.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280AbaD1X7T convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 28 Apr 2014 19:59:19 -0400
From: Stephen Nichols <Stephen.Nichols@wdc.com>
Subject: Ubuntu-13.10-- fio: engine libaio not loadable
Date: Mon, 28 Apr 2014 23:59:19 +0000
Message-ID: <89470388ACB8A24491F3E64F24385FD75A488BB5@wdscexmb03>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "'fio@vger.kernel.org'" <fio@vger.kernel.org>

Greetings all.

I have a issues using the libaio engine on Ubuntu-13.10. FIO version 2.1.8 is installed and runs fine if I leave the -ioengine option out of my configuration (it defaults to ioengine sync). When I try and use -ioengine=libaio I receive the errors

fio: engine libaio not loadable
fio: failed to lead engine libaio

I have use these identical workloads on Suse 11, RH6, and Cent OS systems with no issue. And even after specifically installing libaio on Ubuntu I still see these issues. 

apt-get install libaio1

Any ideas? I'm suspecting this is user error but I can't see where I went wrong.

Thanks
Stephen "Nick" Nichols
Western Digital
Enterprise Storage Group

