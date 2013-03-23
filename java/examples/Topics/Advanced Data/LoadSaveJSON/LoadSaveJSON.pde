/**
 * Loading JSON Data
 * by Daniel Shiffman.  
 * 
 * This example demonstrates how to use loadJSON()
 * to retrieve data from a JSON file and make objects 
 * from that data.
 *
 * Here is what the JSON looks like (partial):
 *
{
  "bubbles": {
    "bubble": [
      {
        "position": {
          "x": 160,
          "y": 103
        },
        "diameter": 43.19838,
        "label": "Happy"
      },
      {
        "position": {
          "x": 121,
          "y": 179
        },
        "diameter": 44.758068,
        "label": "Melancholy"
      }
    ]
  }
}
 */

// An Array of Bubble objects
Bubble[] bubbles;

// A JSON object
JSON json;

void setup() {
  size(640, 360);
  loadData();
}

void draw() {
  background(255);
  // Display all bubbles
  for (Bubble b : bubbles) {
    b.display();
    b.rollover(mouseX, mouseY);
  }

  textAlign(LEFT);
  fill(0);
  text("Click to add bubbles.", 10, height-10);
}

void loadData() {
  // Load JSON file
  json = loadJSON("data.json");

  // The size of the array of Bubble objects is determined by the total JSON elements
  bubbles = new Bubble[json.size()]; 

  for (int i = 0; i < bubbles.length; i++) {
    // Get the JSON representing the bubble
    JSON bubble = json.getJSON(i);

    // The position element has two attributes: x and y
    float x = bubble.getJSON("position").getInt("x");
    float y = bubble.getJSON("position").getInt("y");

    // The diameter is the content of the child named "diamater"
    float diameter = bubble.getFloat("diameter");

    // The label is the content of the child named "label"
    String label = bubble.getString("label");

    // Make a Bubble object out of the data read
    bubbles[i] = new Bubble(x, y, diameter, label);
  }
}

void mousePressed() {

  // Create a new JSON bubble element
  JSON newBubble = new JSON();

  // Set the position element
  JSON position = new JSON();
  position.setInt("x", mouseX);
  position.setInt("y", mouseY);
  newBubble.setJSON("position", position);

  // Set the diameter element
  newBubble.setFloat("diameter", random(40, 80));

  // Set a label
  newBubble.setString("label", "New label");

  // Append the new bubble to the JSON json
  json.append( newBubble );
	
  // Here we are removing the oldest bubble if there are more than 10
  // If the JSON file has more than 10 bubble elements
  if (json.size() > 10) {
    // Delete the first one
    json.removeIndex(0);
  }
	
  // Save a new JSON file
  saveStrings("data/data.json", split(root.toString(), "\n"));

  // reload the new data 
  loadData();
}
