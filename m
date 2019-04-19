Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:58474 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726417AbfDSScb (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 19 Apr 2019 14:32:31 -0400
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: [PATCH fio] engines: Add Network Block Device (NBD) support.
Date: Fri, 19 Apr 2019 15:28:39 +0000
Message-ID: <AT5PR8401MB11690E26E97E292FD0EB44B5AB270@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190418140938.15527-1-rjones@redhat.com>
 <20190418140938.15527-2-rjones@redhat.com>
In-Reply-To: <20190418140938.15527-2-rjones@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "eblake@redhat.com" <eblake@redhat.com>, "nbd@other.debian.org" <nbd@other.debian.org>

Just a few random style comments, not a complete review...

> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Richard W.M. Jones
> Sent: Thursday, April 18, 2019 9:10 AM
> Subject: [PATCH fio] engines: Add Network Block Device (NBD) support.
> 
...
> +        r = getaddrinfo(hostname, port, &hints, &result);
> +        if(r != 0) {

if() is not a function, so include a space.

...
> +                        log_err("fio: nbd: unexpected end of file "
> +                                "reading from server\n");

Please keep strings on one line so they can be found with grep. That's more
important than wrapping at 80 characters.


