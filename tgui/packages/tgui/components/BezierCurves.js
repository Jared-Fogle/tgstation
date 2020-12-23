export const BezierCurves = (props) => {
  const { curves } = props;

  return <div style={{
    position: "absolute",
    height: "100%",
    width: "100%",
  }}>
    <svg>
      {curves.map(curve => {
        const {
          pointA: [a_x, a_y],
          pointB: [b_x, b_y],
          ...rest
        } = curve;

        return (
          <path
            d={`M${a_x},${a_y} C${a_x},${(b_y - a_y) * 0.5} ${b_x},${(b_y - a_y) * 0.5} ${b_x},${b_y}`}
            fill="transparent"
            {...rest}
          />
        );
      })}
    </svg>
  </div>;
};
