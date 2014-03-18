Return-Path: <fio-owner@vger.kernel.org>
Received: from server506h.appriver.com ([50.56.144.38]:63240 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752598AbaCRAzD convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 17 Mar 2014 20:55:03 -0400
Received: from [10.242.229.139] (HELO smtp.exg6.exghost.com)
  by server506.appriver.com (CommuniGate Pro SMTP 6.0.2)
  with ESMTPS id 158570167 for fio@vger.kernel.org; Mon, 17 Mar 2014 19:55:00 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: correct file size to use
Date: Tue, 18 Mar 2014 00:54:21 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB0D3E40@DAGN05A-E6.exg6.exghost.com>
References: <53243539.5010405@adon.li>
 <CACVXFVNbNpwH44DHfN+BU2a7KvF=Ah7As3+UwKHB8eGOX6b7ug@mail.gmail.com>
 <CAF+0mvmJqfvzdDrj8qWxmfgAh7jM9=f20v2pMTpFU-75vuTFRw@mail.gmail.com>
 <CACVXFVN9O7HF6LJ=k-mygGHLWcpsQ3chWkkukdp+rFqnunJ60w@mail.gmail.com>
 <5327577B.8050703@adon.li> <20140317203457.GA11577@sucs.org>
 <53275DCC.8050506@adon.li>
In-Reply-To: <53275DCC.8050506@adon.li>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

> From: jvogt [mailto:jvogt@adon.li]
> Sent: Monday, March 17, 2014 1:41 PM

> Please explain, what do you mean with appropriate iodepth? What would
> you suggest?

Something higher than 1 :).  I use 512, since AFAIK no storage array out there will actually queue up that many operations.

z!

