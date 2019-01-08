Return-Path: <axboe@kernel.dk>
Subject: Re: [fio PATCH] engines/devdax: Make detection of device-dax
 instances more robust
References: <154697605958.939406.14480036379705502215.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <be0f90f5-b26c-43e6-489e-29770e1634c1@kernel.dk>
Date: Tue, 8 Jan 2019 12:47:51 -0700
MIME-Version: 1.0
In-Reply-To: <154697605958.939406.14480036379705502215.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, fio@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <fio@vger.kernel.org>

On 1/8/19 12:34 PM, Dan Williams wrote:
> In preparation for the kernel switching device-dax instances from the
> "/sys/class/dax" subsystem to "/sys/bus/dax" [1], teach the device-dax
> instance detection to be subsystem-type agnostic.
> 
> Note that the subsystem switch will require an administrator, or distro
> opt-in. The opt-in will either be at kernel compile time by disabling
> the default compatibility driver in the kernel, or at runtime with a
> modprobe policy to override which kernel module service device-dax
> devices. The daxctl utility [2] will ship a command to install the
> modprobe policy and include a man page that lists the potential
> regression risk to older FIO and other userspace tools that are hard
> coded to "/sys/class/dax".
> 
> [1]: https://lwn.net/Articles/770128/
> [2]: https://github.com/pmem/ndctl/tree/master/daxctl

Applied, thanks Dan.

-- 
Jens Axboe


