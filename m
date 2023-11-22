Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dx.net.pl header.i=@dx.net.pl header.b="ZuQc0rlx"
X-Greylist: delayed 371 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Nov 2023 00:36:04 PST
Received: from mail.dx.net.pl (unknown [80.68.239.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57FE112
	for <fio@vger.kernel.org>; Wed, 22 Nov 2023 00:36:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dx.net.pl; s=dkim;
	t=1700641791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9SAljk5ws8gNEsXqUmHa6gK3/U8WP0FGANsx8px61pQ=;
	b=ZuQc0rlxjiHsagfBuoE5g55WGRoJblmQJr51ZmVOBffQ9l/J2TcVGpkyeTiwcUV6Z5bS++
	Da/eUTI506oNG5paqDEZf6H4XnccoYT5+RIYqrbt1139sIpfEu31RlcYWZo9kHaxBo1TQR
	xqZwCG+R7ggnVH2snZL02mG1L8JD7eyTuEcQjQdogB36/8ivRE7/JDhR3WdBAaRJiLIEov
	uYMwbDUtvkfg+NVgdL1kVzmbWiP+4zgeFW5E1xxOOPREvUY3GEjypvxbQotEycGPBlLgVZ
	l9sYBk77jwJ1e9i/JBVmgUgXFi9xny/jPZtBi51GVZj1250c6iaqfS6zpcICLw==
Authentication-Results: mail.dx.net.pl;
	auth=pass smtp.mailfrom=bartoszek@dx.net.pl
Date: Wed, 22 Nov 2023 09:29:51 +0100
From: bartoszek@dx.net.pl
To: fio@vger.kernel.org
Subject: How to perform an random read test, with normal distribution
Message-ID: <4c92fe6a414a472aaec12b04eae3ffba@dx.net.pl>
X-Sender: bartoszek@dx.net.pl
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Bar: /
X-Spam-Level: *

Hi!

I Want to perform a test scenario

I have a "huge" file in which I want to read out blocks of data randomly 
with some distribution. For example 20% od blocks in test file will get 
~80% od total IO from the engine.

Placement of blocks within the file is not important
The only requirement is that some blocks are read out more frequently 
then others, and the distribution of reads is defined by some parameters

Test should simulate a VM image reads during VM startup (or runtime) 
where not all files are used, and some are used more often then others.

Is there a way to test such scenario using fio?

Best regards,
Bartosz Wieczorek
