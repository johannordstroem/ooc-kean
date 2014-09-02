/*
* Copyright (C) 2014 - Simon Mika <simon@mika.se>
*
* This sofware is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This software is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with this software. If not, see <http://www.gnu.org/licenses/>.
*/

Event: class {
	_head: Func
	_tail: This
	init: func ~nil() {
		this init(func) // FIXME: this is realy a stupid way to create null pointer although no null text is required
	}
	init: func (=_head)
	init: func ~add (=_head, =_tail)
	operator + (action: Func) -> This {
		Event new(action, this)
	}
	operator + (event: This) -> This {
		event != null ? This new(event _head, this) + event _tail : this
	}
	call: func {
		if (this _tail != null)
			this _tail call()
		this _head()
	}
}
Event1: class <T> {
	_head: Func(T)
	_tail: This<T>
	init: func ~nil() {
		this init(func(argument: T)) // FIXME: this is realy a stupid way to create null pointer although no null text is required
	}
	init: func (=_head)
	init: func ~add (=_head, =_tail)
	add: func ~action (action: Func(T)) -> This<T> {
		This<T> new(action, this)
	}
	add: func ~event <T> (other: This<T>) -> This<T> {
		if (this == null)
			other
		else if (other == null)
		  this
		else
			This<T> new(other _head, this) add(other _tail)
	}
	call: func(argument: T) {
		if (this _tail != null)
			this _tail call(argument)
		this _head(argument)
	}
}

Event2: class <T0, T1> { // TODO: Write tests and fix this
	_head: Func(T0, T1)
	_tail: This<T0, T1>
	init: func (=_head)
	init: func ~add (=_head, =_tail)
	operator + (action: Func(T0, T1)) -> This<T0, T1> {
		Event2 new(action, this)
	}
	operator + (event: This<T0, T1>) -> This<T0, T1> {
		event != null ? This new(event _head, this) + event _tail : this
	}
	call: func(argument0: T0, argument1: T1) {
		if (this _tail != null)
			this _tail call(argument0, argument1)
		this _head(argument0, argument1)
	}
}
