Return-Path: <fio-owner@vger.kernel.org>
Received: from server506a.appriver.com ([50.56.144.13]:57825 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaCQCCx convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 16 Mar 2014 22:02:53 -0400
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: correct file size to use
Date: Mon, 17 Mar 2014 02:02:51 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB0D2A05@DAGN05A-E6.exg6.exghost.com>
References: <53243539.5010405@adon.li>
	<CACVXFVNbNpwH44DHfN+BU2a7KvF=Ah7As3+UwKHB8eGOX6b7ug@mail.gmail.com>,<CAF+0mvmJqfvzdDrj8qWxmfgAh7jM9=f20v2pMTpFU-75vuTFRw@mail.gmail.com>
In-Reply-To: <CAF+0mvmJqfvzdDrj8qWxmfgAh7jM9=f20v2pMTpFU-75vuTFRw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>, Ming Lei <tom.leiming@gmail.com>
Cc: jvogt <jvogt@adon.li>, "fio@vger.kernel.org" <fio@vger.kernel.org>

[sorry for the lack of quoting, OWA doesn't do it nicely.]

Which OS & file system? If the storage target is an NFS mount, you'll still have the server cache. Also, IIRC solaris doesn't honor direct=1 anyway. If zfs is involved.... there's no escaping it's optimizations :).

Please give us more info about the setup.

z!
