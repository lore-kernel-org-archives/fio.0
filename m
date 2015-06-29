Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:43462 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbF2W4q (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 29 Jun 2015 18:56:46 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id B8F5927334A
	for <fio@vger.kernel.org>; Mon, 29 Jun 2015 16:56:34 -0600 (MDT)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id z7GQYYok1wpi for <fio@vger.kernel.org>;
	Mon, 29 Jun 2015 16:56:34 -0600 (MDT)
Received: from [10.50.3.54] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Mon, 29 Jun 2015 16:56:34 -0600 (MDT)
Message-ID: <5591CD2C.2080806@cran.org.uk>
Date: Mon, 29 Jun 2015 16:56:44 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: t/stest failures
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Is something broken in the t/stest program? It's reporting lots of failures:

$ ./t/stest
fail at 128205317, size 978
Got items: 169847
fail at 128208721, size 1204
Got items: 169614
fail at 128204652, size 1051
Got items: 169831
fail at 128201408, size 1109
Got items: 169809
fail at 128199178, size 1222
Got items: 170102
fail at 128204580, size 1235
Got items: 169646
fail at 128207042, size 944
Got items: 169824
fail at 128202141, size 1139
Got items: 169896
fail at 128209465, size 966
Got items: 169635
fail at 128204399, size 403
Got items: 169778
fail at 128200338, size 757
Got items: 169902
fail at 128196318, size 1070
Got items: 169909
fail at 128203847, size 719
Got items: 169858
fail at 128209279, size 914
Got items: 169777
fail at 128191033, size 745
Got items: 169964
fail at 128198354, size 1218
Got items: 169861
fail at 128202491, size 1069
Got items: 169698
fail at 128204565, size 948
Got items: 169680
fail at 128201762, size 845
Got items: 169711
fail at 128216741, size 1058
Got items: 169665
fail at 128206568, size 1152
Got items: 169919
fail at 128207559, size 1173
Got items: 169750
fail at 128209235, size 1129
Got items: 169803
fail at 128191388, size 1076
Got items: 169888
fail at 128207166, size 689
Got items: 169754
fail at 128200278, size 463
Got items: 169909
fail at 128202813, size 863
Got items: 169931
fail at 128204253, size 833
Got items: 169740
fail at 128208748, size 856
Got items: 169641
fail at 128200122, size 799
Got items: 169943
fail at 128202717, size 1216
Got items: 169742
fail at 128206273, size 1171
Got items: 169638

-- 
Bruce
