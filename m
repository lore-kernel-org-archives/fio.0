Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59688 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaFEUVS (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Jun 2014 16:21:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1WseA1-0007Ia-7x
	for fio@vger.kernel.org; Thu, 05 Jun 2014 22:21:17 +0200
Received: from 216.239.45.76 ([216.239.45.76])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Thu, 05 Jun 2014 22:21:17 +0200
Received: from aschade by 216.239.45.76 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Thu, 05 Jun 2014 22:21:17 +0200
From: Allen Schade <aschade@google.com>
Subject: Re: unable to replay a trace generated w/ fio
Date: Thu, 5 Jun 2014 20:21:05 +0000 (UTC)
Message-ID: <loom.20140605T221951-815@post.gmane.org>
References: <CA+BkS8M8GDkb7st7Q=TZzXmXHW6HrvjnrSoVnP8f74v9r0g1Nw@mail.gmail.com>	<CA+BkS8N4VjKszFaLhZOOcr0Zm1q6B76gwoeyMuk60Q37u3GSFg@mail.gmail.com> <CA+BkS8PN4EOofkBNc+NWO0kXYayE6c=dqmKYLfv96ZZanS=rBQ@mail.gmail.com> <537A5FBD.6010303@kernel.dk> <loom.20140605T205918-969@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Sorry I missed a line at the top of the trace file:

fio version 2 iolog
/dev/hdc add
/dev/hdc open
/dev/hdc write 2045557202944 8192
/dev/hdc close



