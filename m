Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f171.google.com ([209.85.215.171]:45053 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731008AbfEVTcD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 May 2019 15:32:03 -0400
Received: by mail-pg1-f171.google.com with SMTP id n2so1799349pgp.11
        for <fio@vger.kernel.org>; Wed, 22 May 2019 12:32:03 -0700 (PDT)
Date: Wed, 22 May 2019 19:31:59 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC] fio-tests: add framework to build fio tests dynamically
Message-ID: <20190522193159.GC24719@42.do-not-panic.com>
References: <20190521231918.13361-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521231918.13361-1-mcgrof@kernel.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: andrey.o.kudryavtsev@intel.com

On Tue, May 21, 2019 at 11:19:18PM +0000, Luis Chamberlain wrote:
> If its preferred to host this as a standalone
> project I may need a bit of help with that,

Actually here it is as a standalone project:

https://gitlab.com/mcgrof/fio-tests

This way this can advance alone and if folks really think this should be
merged we can do so at any point later. If you have contributions to
make send them my way.

  Luis

