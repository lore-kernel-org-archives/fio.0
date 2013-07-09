Return-Path: <fio-owner@vger.kernel.org>
Received: from server506b.appriver.com ([50.56.144.14]:54445 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751452Ab3GIWoP convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 9 Jul 2013 18:44:15 -0400
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: Question about default random I/O distribution
Date: Tue, 9 Jul 2013 22:44:10 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB04A2DF@DAGN05C-E6.exg6.exghost.com>
References: <CAF+0mvkAjqDsNBeayQ0TnYCao===-iomUMPepxEavYRk3XKPAw@mail.gmail.com>
In-Reply-To: <CAF+0mvkAjqDsNBeayQ0TnYCao===-iomUMPepxEavYRk3XKPAw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

[don't recall seeing an answer to this]

> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Matthew Eaton

> I am calling fio multiple times using the same parameters in a shell
> script loop.  I want to make sure that each time fio is called it will
> generate new random offsets (not continue to use the same random
> offsets).  

I think you want --randrepeat=0.

z!

