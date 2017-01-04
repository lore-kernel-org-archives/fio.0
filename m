Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-dm3nam03on0130.outbound.protection.outlook.com ([104.47.41.130]:26123
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751688AbdADXse (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Jan 2017 18:48:34 -0500
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 1/4] pmemblk, dev-dax: load libpmem and libpmemblk at
 startup
Date: Wed, 4 Jan 2017 23:48:32 +0000
Message-ID: <DF4PR84MB0169200539C99501DE82D292AB610@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170104065453.15106-1-elliott@hpe.com>
 <20170104065453.15106-2-elliott@hpe.com>
In-Reply-To: <20170104065453.15106-2-elliott@hpe.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>



> -----Original Message-----
> From: Elliott, Robert (Persistent Memory)
> Sent: Wednesday, January 04, 2017 12:55 AM
> Subject: [PATCH 1/4] pmemblk, dev-dax: load libpmem and libpmemblk at
> startup
> 
...
> diff --git a/configure b/configure
> index fc15782..ca69052 100755
> --- a/configure
> +++ b/configure
> @@ -1573,11 +1573,12 @@ int main(int argc, char **argv)
>  {
>    int rc;
>    rc = pmem_is_pmem(0, 0);
> -  return 0;
> +  return rc;

That change should not be applied - the return code is irrelevant
on the compiling machine (0 is the expected result since the len
being checked is zero). This is just used to check if a program
making that function call compiles or not.


