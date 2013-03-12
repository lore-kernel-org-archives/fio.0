Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44754
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944Ab3CLMWk (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Mar 2013 08:22:40 -0400
Date: Tue, 12 Mar 2013 13:22:10 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: TRIM addressing unwritten space?
Message-ID: <20130312122210.GP25165@kernel.dk>
References: <CANvN+ekLXVeKh3t9x23G-AOa9tEOBF+PY=WZB6qp8CEZPzzGJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANvN+ekLXVeKh3t9x23G-AOa9tEOBF+PY=WZB6qp8CEZPzzGJw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org

On Mon, Mar 11 2013, Andrey Kuzmin wrote:
> I may be misreading the fio code, but it looks like there is an issue
> with generation of the offset to ttrim if trim_backlog option is not
> set.
> 
> In this case, get_io_u falls through the check_get_trim (which starts
> with the check if td->flags has TD_F_TRIM_BACKLOG set  and immediately
> returns if not), and the call chain is then
> 
> set_io_u_file->fill_io_u->set_rw_dir->get_rw_dir
> 
> where, in the last else clause of the conditional, ddir is set to DDIR_TRIM.
> 
> Subsequently, the get_next_offset then - say, in the random I/O case -
> ends up in the __get_next_rand_offset returning a random offset not
> necessarily written to previously. TRIMming an unwritten space is not
> necessarily a bug (although some SSD controllers may have different
> view), but is hardly the operation fio intended to perform.
> 
> The very next portion of the __get_next_rand_offset, dealing with  the
> random map, could have solved the issue (if it's real), with the write
> logic reversed for TRIM (return if the offset is busy and look up the
> next busy offset otherwise). For this to work, o_randommap should be
> made required for trim jobs without o_trim_backlog set.

The trim primitive works just like reads or writes. So if you use it
without a backlog explicitly trimming previously written parts, then it
will randomly issue trims just like it would have done a read or a
write.

I can't imagine trimming unwritten extents causing an error on any
device, even the most crappy and cheap ones. First of all, that would
violate any sort of common sense. Secondly, you can expect other
utilities to completely trim a device before using it for eg swap or a
new file system. This will gladly trim any unwritten extent as well.

That said, if you would like fio to explicitly only trim bits that have
previously been written (without using a backlog), then that is a sane
feature to have. It could be done with lfsr magic, or you could use the
randommap (in reverse) as you describe. This would be easy enough to
implement, at least for the pure write case.

-- 
Jens Axboe

