use ooc-base
use ooc-unit
use ooc-geometry

TextLiteralTest: class extends Fixture {
	init: func {
		super("TextLiteral")
		this add("constructors", func {
			t := Text new(c"test string", 5)
			expect(t toString() == "test ")
			t =t"string"
			t2 := t"str"
			expect(t count == 6)
			expect(t toString() == "string")
			expect(t isEmpty == false)
			t = t give()
			t free()
			expect(t count == 0)
			expect(t isEmpty)
			expect(t"from const" == "from const")
			expect(t"12345" count == 5)
		})
		this add("ownership", func {
			t := Text new(c"vidhance", 8)
			expect(t count == 8)
			t take()
			t free()
			expect(t count == 0)
			t = Text new(c"a string", 8)
			t free()
			expect(t isEmpty)
			t = t give()
			t free()
			expect(t isEmpty)
		})
		this add("searching", func {
			t := Text new("test string")
			t2 := t"test"
			expect(t endsWith(t))
			expect(t beginsWith(t))
			expect(t endsWith(t2) == false)
			expect(t beginsWith(t2))
			expect(t2 beginsWith(t2))
			expect(t[0] == 't')
			expect(t[1] == 'e')
			expect(t find('t') == 0)
			expect(t find('e') == 1)
			expect(t find('t', 1) == 3)
			expect(t find('x') == -1)
			expect(t find(t) == 0)
			expect(t find(t"test") == 0)
			expect(t find(t"est") == 1)
			expect(t find("st") == 2)
			expect(t find(t"st", 4) == 5)
			expect(t find("string") == 5)
			expect(t find(t"bad") == -1)
		})
		this add("slicing", func {
			t := Text new(c"text to slice", 13)
			expect(t == t copy())
			expect(t == t slice(0, t count))
			expect(t slice(0, 4) == Text new(c"text", 4))
			expect(t slice(8, 5) == Text new(c"slice", 5))
			expect(t slice(40, 23) isEmpty)
			expect(t slice(-2, -2) == "li")
			expect(t[0 .. 2] == "tex")
			expect(t[0 .. 123] == t)
			expect(t[123 .. 998] isEmpty)
		})
		this add("splitting", func {
			t := t"0,1,2,3,4"
			parts := t split(',')
			expect(parts count == 5)
			expect(parts[0] == "0")
			expect(parts[1] == "1")
			expect(parts[2] == "2")
			expect(parts[3] == "3")
			expect(parts[4] == "4")
			t = t";;;0;;1;;;2;;3;"
			parts = t split(";")
			expect(parts count == 12)
			expect(parts[0] == Text empty)
			expect(parts[3] == "0")
			expect(parts[5] == "1")
			expect(parts[8] == "2")
			expect(parts[10] == "3")
			t = t"</br>simple</br>text</br></br>to</br>split"
			parts = t split(Text new(c"</br>", 5))
			expect(parts count == 6)
			expect(parts[0] == Text empty)
			expect(parts[1] == "simple")
			expect(parts[2] == "text")
			expect(parts[3] == Text empty)
			expect(parts[4] == "to")
			expect(parts[5] == "split")
		})
		this add("Convert to Int", func {
			expect(t"1" toInt(), is equal to(1))
			expect(t"-1" toInt(), is equal to(-1))
			expect(t"-932" toInt(), is equal to(-932))
			expect(t"871" toInt(), is equal to(871))
			expect(t"bad" toInt(), is equal to(0))
			expect(t"123one" toInt(), is equal to(123))
			expect(t"101" toInt(), is equal to(101))
			for (i in 1 .. 100)
				for (j in 1 .. 100) {
					numberString := (i * j) toString()
					expect(Text new(numberString) toInt(), is equal to(i * j))
					numberString free()
				}
		})
		this add("Convert to Int (base 16)", func {
			expect(t"bad" toInt~inBase(16), is equal to(11 * 16 * 16 + 10 * 16 + 13))
			expect(t"BEEF" toInt(), is equal to(0))
			expect(t"BEEF" toInt~inBase(16), is equal to(48879))
			expect(t"BEEF" toInt~inBase(16), is equal to(Text new("beef") toInt~inBase(16)))
			expect(t"0xff" toInt(), is equal to(255))
			expect(t"0x11" toInt(), is equal to(17))
			expect(t"0xAA" toInt(), is equal to(170))
			expect(t"0xffZZZ" toInt(), is equal to(255))
		})
		this add("Convert to Int (other bases)", func {
			expect(t"101" toInt~inBase(2), is equal to(5))
			expect(t"101" toInt~inBase(8), is equal to(8 * 8 + 1))
			expect(t"101" toInt~inBase(7), is equal to(7 * 7 + 1))
			expect(t"654" toInt~inBase(6), is equal to(0))
			expect(t"654" toInt~inBase(7), is equal to(4 + 5 * 7 + 6 * 7 * 7))
		})
		this add("Convert to Long and ULong", func {
			expect(Text new(INT_MAX toString()) toLong(), is equal to(INT_MAX))
			expect(t"0xDEADBEEF" toULong(), is equal to(3735928559))
			expect(t"-9" toULong(), is equal to(0))
			expect(t"-9" toLLong(), is equal to(-9))
			expect(t"-9" toLong(), is equal to(-9))
		})
		this add("Convert to Float", func {
			tolerance := 0.001f
			expect(t"1" toFloat(), is equal to(1.0f) within(tolerance))
			expect(t"-1.0" toFloat(), is equal to(-1.0f) within(tolerance))
			expect(t"-1." toFloat(), is equal to(-1.0f) within(tolerance))
			expect(t"22.5" toFloat(), is equal to(22.5f) within(tolerance))
			expect(t"123.763" toFloat(), is equal to(123.763f) within(tolerance))
			for (i in 1 .. 100)
				for (j in 1 .. 100) {
					numberString := (0.5f * i * j) toString()
					expect(Text new(numberString) toFloat(), is equal to(0.5f * i * j) within(tolerance))
					numberString free()
				}
		})
		this add("Convert to Float (scientific notation)", func {
			tolerance := 0.001f
			expect(t"1e0" toFloat(), is equal to(1.0f) within(tolerance))
			expect(t"5E-2" toFloat(), is equal to(0.05f) within(tolerance))
			expect(t"2E12" toLDouble(), is equal to(2.0 * pow(10, 12) as LDouble) within(tolerance as LDouble))
			expect(t"6.5E5" toFloat(), is equal to(6.5f * pow(10, 5) as Float) within(tolerance))
			expect(t"-34.5E-2" toFloat(), is equal to(-0.345f) within(tolerance))
		})
	}
}

TextLiteralTest new() run() . free()
