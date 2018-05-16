Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] make fio scripts python3-ready
References: <20180504143449.31934-1-billodo@redhat.com>
 <20180504194340.1835-1-billodo@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <52c2bd12-21ed-c216-b854-4c1d3a11cf76@kernel.dk>
Date: Wed, 16 May 2018 11:18:11 -0600
MIME-Version: 1.0
In-Reply-To: <20180504194340.1835-1-billodo@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bill O'Donnell <billodo@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/4/18 1:43 PM, Bill O'Donnell wrote:
> Many distributions are moving to python3 by default.  Here's
> an attempt to make the python scripts in fio python3-ready.
> 
> Conversion was facilitated with automated tools. A few areas
> were hand fixed: remove superfluous parentheses introduced by
> 2to3 converter in print function calls, shebang modifications
> to use environment variable for python version, and byte-string
> decode correction in steadystate_tests.py following 2to3
> conversion.
> 
> The modified scripts pass rudimentary testing when run under
> python2.7 as well as python3.

Applied, thanks!

-- 
Jens Axboe


