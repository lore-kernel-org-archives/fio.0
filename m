Return-Path: <fio-owner@vger.kernel.org>
Received: from server506f.appriver.com ([50.56.144.36]:65239 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751752Ab3AaXmB convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 31 Jan 2013 18:42:01 -0500
Received: from [10.242.229.139] (HELO smtp.exg6.exghost.com)
  by server506.appriver.com (CommuniGate Pro SMTP 6.0.1)
  with ESMTPS id 46524623 for fio@vger.kernel.org; Thu, 31 Jan 2013 17:41:59 -0600
From: Carl Zwanzig <cpz@coraid.com>
Subject: use of rwmixread option
Date: Thu, 31 Jan 2013 23:43:28 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB010719@DAGN05A-E6.exg6.exghost.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Am I correct that rwmixread/rwmixwrite are completely ignored unless readwrite=rw or =randrw? Experiments suggest yes but I can't find where this is handled in the code. (The HowTo file is silent on this.)

*Is there a description somewhere on how options are processed? Tracking the option definition in options.c to its use has eluded me.

thanks,

z!

