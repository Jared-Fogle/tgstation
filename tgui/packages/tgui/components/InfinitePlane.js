import { clamp } from "common/math";
import { computeBoxProps } from "./Box";
import { Component } from "inferno";

const MAX_ZOOM = 10;
const ZOOM_SLIDER_WIDTH = "25px";

// TODO: <input type="range"> don't work on IE 9
// And IE 8 supports fuck all.
const ZoomSlider = (props, context) => {
  const { setZoom, zoom } = props;

  return (<div style={{
    background: "blue",

    height: "125px",
    width: ZOOM_SLIDER_WIDTH,

    position: "absolute",
    bottom: "0",
    right: "0",
  }}>
    <input
      min={1}
      max={MAX_ZOOM}
      // TODO: Does this re-render every time?
      onChange={(event) => setZoom(event.target.value)}
      style={{
        position: "absolute",
        right: "-47px",
        top: "calc(50% - 25px)",
        transform: "rotate(270deg)",
        width: "100px",
      }}
      type="range"
      value={zoom}
    />
  </div>);
}

export class InfinitePlane extends Component {
  constructor() {
    super();

    this.state = {
      mouseDown: false,

      left: 0,
      top: 0,

      lastLeft: 0,
      lastTop: 0,

      zoom: MAX_ZOOM / 2,
    };

    this.onMouseDown = this.onMouseDown.bind(this);
    this.onMouseMove = this.onMouseMove.bind(this);
    this.onMouseUp = this.onMouseUp.bind(this);

    this.setZoom = this.setZoom.bind(this);
  }

  componentDidMount() {
    window.addEventListener("mouseup", this.onMouseUp);
  }

  componentWillUnmount() {
    window.removeEventListener("mouseup", this.onMouseUp);
  }

  onMouseDown(event) {
    this.setState((state) => {
      return {
        mouseDown: true,
        lastLeft: event.clientX - state.left,
        lastTop: event.clientY - state.top,
      };
    });
  }

  onMouseUp() {
    this.setState({
      mouseDown: false,
    });
  }

  onMouseMove(event) {
    if (this.state.mouseDown) {
      this.setState((state) => {
        const bounds = this.props.bounds || Infinity;
        return {
          left: clamp(event.clientX - state.lastLeft, -bounds, bounds),
          top: clamp(event.clientY - state.lastTop, -bounds, bounds),
        };
      });
    }
  }

  setZoom(newZoom) {
    this.setState({
      zoom: newZoom,
    });
  }

  render() {
    const {
      bounds,
      children,
      ...rest
    } = this.props;

    const {
      left,
      top,
      zoom,
    } = this.state;

    return (<div
      ref={this.ref}
      {...computeBoxProps({
        ...rest,
        style: {
          ...rest.style,
          overflow: "hidden",
          position: "relative",
        },
      })}
    >
      {/* A div covering the background to allow the div to be moved */}
      <div
        onMouseDown={this.onMouseDown}
        onMouseMove={this.onMouseMove}

        style={{
          overflow: "hidden",
          position: "absolute",

          height: "100%",
          width: "100%",
        }}
      >
      </div>

      <div style={{
        "background": "green",
        "display": "inline-block",

        "pointer-events": "none",
        "position": "relative",
        "transform": `translate(${left}px, ${top}px) scale(${(zoom / MAX_ZOOM) + 0.5})`,

        "height": "100%",
        "width": "100%",
      }}>
        {children}
      </div>

      <ZoomSlider
        setZoom={this.setZoom}
        zoom={zoom}
      />
    </div>);
  }
}
