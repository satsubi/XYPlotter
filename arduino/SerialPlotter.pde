
/* Pin definitions */
#define X       10
#define Y       9
#define PENDOWN 11

/* Paper range in hpgl units */
#define RANGE 8500

/* Delays in ms */
#define PEN_DOWNTOUP_BEFORE 150
#define PEN_DOWNTOUP_AFTER  150
#define PEN_UPTODOWN_BEFORE 150
#define PEN_UPTODOWN_AFTER  150

int penUp = 1;
int penSpeed = 1;
int lastX = 0;
int lastY = 0;
int xcoord, ycoord;
int i, j, d;


void
setup ()
{
    pinMode(X, OUTPUT);
    pinMode(Y, OUTPUT);
    pinMode(PENDOWN, OUTPUT);
    Serial.begin(9600);
}


void
loop ()
{
    if (Serial.available()) {
        switch (readByte()) {
            /* set Speed */
            case 'S':
                penSpeed = readInt();
                Serial.write('T');
                break;
            /* pen Down */
            case 'D':
                xcoord = readInt();
                ycoord = readInt();
                move(1, xcoord, ycoord);
                Serial.write('T');
	        break;
            /* pen Up */
	    case 'U':
                xcoord = readInt();
                ycoord = readInt();
                move(0, xcoord, ycoord);
                Serial.write('T');
	        break;
        }
    }
}


/*
 * readByte : Read one Byte on Serial
 */
int
readByte ()
{
    while (!Serial.available());
    return Serial.read();
}


/*
 * readInt : Read one Int and one non-digit byte at the end
 */
int
readInt ()
{
    int i, nb = 0, p = 0;
    int buffer[5];

    while (isdigit(buffer[i++] = readByte()));
    for (i -= 2; i >= 0; i--, p++)
        nb += (buffer[i] - '0') * pow(10, p);
    return nb;
}


/*
 * move : Move pen up or down and slowly go to a xy position
 */
void
move (int w, int x, int y)
{
    /* Moving pen up and down */
    if (w && penUp) {
        delay(PEN_UPTODOWN_BEFORE);
        digitalWrite(PENDOWN, HIGH);
        penUp = 0;
        delay(PEN_UPTODOWN_AFTER);
    } else if (!w && !penUp) {
        delay(PEN_DOWNTOUP_BEFORE);
        digitalWrite(PENDOWN, LOW);
        penUp = 1;
        delay(PEN_UPTODOWN_AFTER);
    }

    /* Moderate speed by moving one 1ms step by one */
    d = sqrt(pow(abs(x - lastX), 2) + pow(abs(y - lastY), 2)) / 2;
    if (d < 1) d = 1;
    for (i = 0, j = 0; i < d && j < d; i++, j++) {
        analogWrite(X, map(map(i, 0, d - 1, lastX, x), 0, RANGE, 0, 255));
        analogWrite(Y, map(map(j, 0, d - 1, lastY, y), 0, RANGE, 0, 255));
        delay(1);
    }
    lastX = x;
    lastY = y;
}


